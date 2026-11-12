-- Wanderbricks Excel HOL · Step 2 · 파이프라인 (Silver): 정제·검증·제외 행
-- 소스: samples.wanderbricks (2025-06-01 이전 예약, users, reviews) + 엑셀 업로드 이력 bronze
-- 게시 위치: 파이프라인 기본 스키마 <your_name>_wanderbricks_excel.silver (gold 테이블은 gold.* 로 게시)

-- 1) 사용자 차원 (시스템 데이터, Wanderbricks와 같은 정제)
CREATE OR REFRESH MATERIALIZED VIEW silver_dim_users (
  CONSTRAINT valid_user_id EXPECT (user_id IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_email   EXPECT (email IS NOT NULL)   ON VIOLATION DROP ROW,
  CONSTRAINT valid_type    EXPECT (user_type IN ('individual','business'))
)
  COMMENT 'Silver 사용자 차원. 이메일 결측 제거, 국가 표준화 (대문자, 공백 정리).'
AS SELECT
  user_id,
  lower(trim(email))                                       AS email,
  trim(name)                                               AS name,
  upper(regexp_replace(trim(country), '\\s+', ' '))        AS country,
  lower(trim(user_type))                                   AS user_type,
  is_business,
  nullif(trim(company_name), '')                           AS company_name,
  created_at
FROM samples.wanderbricks.users;

-- 2) 리뷰 (시스템 데이터): soft-delete 제외, rating 1~5
CREATE OR REFRESH MATERIALIZED VIEW silver_fact_reviews (
  CONSTRAINT valid_review_id EXPECT (review_id IS NOT NULL)  ON VIOLATION DROP ROW,
  CONSTRAINT not_deleted     EXPECT (is_deleted = false)     ON VIOLATION DROP ROW,
  CONSTRAINT valid_rating    EXPECT (rating BETWEEN 1 AND 5) ON VIOLATION DROP ROW
)
  COMMENT 'Silver 리뷰 사실. soft-delete 제외, rating 1~5.'
AS SELECT review_id, booking_id, property_id, user_id, rating, comment, is_deleted, created_at, updated_at
FROM samples.wanderbricks.reviews;

-- 3) 예약 이력 (시스템 데이터): 엑셀 시작월(2025-06-01) 이전 예약만 가져옵니다.
--    2025-06 이후 예약은 엑셀로 받은 것만 씁니다 (중복 방지).
CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_samples AS
SELECT
  booking_id,
  user_id,
  property_id,
  check_in,
  check_out,
  CAST(total_amount AS DECIMAL(12,2))  AS total_amount,
  lower(trim(status))                  AS status,
  guests_count,
  created_at,
  'samples' AS source
FROM samples.wanderbricks.bookings
WHERE created_at < TIMESTAMP '2025-06-01 00:00:00';

-- 4) 엑셀 업로드 정규화: 예약 월마다 가장 최신 업로드 버전만 씁니다.
--    서식 쉼표 제거, 공백·대소문자 정리, try_cast. 변환에 실패한 값은 NULL이 되고 아래 사유 규칙에서 걸립니다.
CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_excel_norm AS
WITH uploads AS (
  SELECT * FROM <your_name>_wanderbricks_excel.bronze.bookings_upload_history
),
latest AS (
  SELECT substring(trim(created_at), 1, 7) AS ym, max(_upload_version) AS v
  FROM uploads
  GROUP BY 1
),
picked AS (
  SELECT u.* FROM uploads u
  JOIN latest l ON substring(trim(u.created_at), 1, 7) = l.ym AND u._upload_version = l.v
),
norm AS (
  SELECT
    _upload_version,
    _uploaded_by,
    _uploaded_at,
    try_cast(nullif(trim(booking_id), '') AS BIGINT)  AS booking_id,
    try_cast(nullif(trim(user_id), '') AS BIGINT)     AS user_id,
    try_cast(nullif(trim(property_id), '') AS BIGINT) AS property_id,
    upper(regexp_replace(trim(country), '\\s+', ' ')) AS country,
    CASE WHEN trim(check_in)  RLIKE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN try_cast(trim(check_in) AS DATE) END  AS check_in,
    CASE WHEN trim(check_out) RLIKE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN try_cast(trim(check_out) AS DATE) END AS check_out,
    try_cast(nullif(trim(guests_count), '') AS INT)   AS guests_count,
    try_cast(regexp_replace(trim(total_amount), ',', '') AS DECIMAL(12,2)) AS total_amount,
    lower(trim(status)) AS status,
    CASE WHEN trim(created_at) RLIKE '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
         THEN try_cast(trim(created_at) AS TIMESTAMP) END AS created_at
  FROM picked
)
SELECT *,
  CASE
    WHEN booking_id IS NULL THEN 'booking_id 누락'
    WHEN total_amount IS NULL THEN '금액이 숫자가 아님'
    WHEN total_amount < 0 THEN '금액 음수'
    WHEN check_in IS NULL OR check_out IS NULL THEN '날짜 형식 오류 (YYYY-MM-DD 아님)'
    WHEN created_at IS NULL THEN '예약 생성일 형식 오류'
    WHEN status NOT IN ('pending','confirmed','cancelled','completed') THEN '상태 값 오류'
    WHEN check_out < check_in THEN '체크아웃이 체크인보다 빠름'
  END AS reject_reason
FROM norm;

-- 5) 제외 행: 사유와 함께 따로 보관합니다. 현업은 이 테이블을 엑셀로 가져가 고쳐서 다시 올립니다.
CREATE OR REFRESH MATERIALIZED VIEW silver_booking_rejects
  COMMENT '엑셀 업로드 중 검증에 실패한 행과 사유. 고쳐서 다시 업로드합니다.'
AS SELECT * FROM silver_bookings_excel_norm WHERE reject_reason IS NOT NULL;

-- 6) 정상 행: 완전 중복(같은 booking_id)은 최신 업로드 기준 1행만 남깁니다.
CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_excel
  COMMENT '엑셀 업로드 중 검증을 통과하고 중복을 제거한 예약.'
AS SELECT
  booking_id, user_id, property_id, country, check_in, check_out, guests_count,
  total_amount, status, created_at, _upload_version
FROM silver_bookings_excel_norm
WHERE reject_reason IS NULL
QUALIFY row_number() OVER (PARTITION BY booking_id ORDER BY _upload_version DESC) = 1;

-- 7) 예약 사실: 시스템 이력 + 엑셀. Expectations로 한 번 더 품질을 강제합니다.
CREATE OR REFRESH MATERIALIZED VIEW silver_fact_bookings (
  CONSTRAINT valid_booking_id EXPECT (booking_id IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_amount     EXPECT (total_amount > 0)       ON VIOLATION DROP ROW,
  CONSTRAINT valid_dates      EXPECT (check_out >= check_in)  ON VIOLATION DROP ROW,
  CONSTRAINT valid_status     EXPECT (status IN ('pending','confirmed','cancelled','completed')) ON VIOLATION DROP ROW,
  CONSTRAINT valid_fk         EXPECT (user_id IS NOT NULL AND property_id IS NOT NULL) ON VIOLATION DROP ROW
)
  COMMENT 'Silver 예약 사실 (시스템 이력 + 엑셀). 금액·날짜·상태 검증을 통과한 행만. nights 파생.'
AS
SELECT booking_id, user_id, property_id, check_in, check_out,
       datediff(check_out, check_in) AS nights, guests_count, total_amount, status, created_at,
       'samples' AS source
FROM silver_bookings_samples
UNION ALL
SELECT booking_id, user_id, property_id, check_in, check_out,
       datediff(check_out, check_in) AS nights, guests_count, total_amount, status, created_at,
       'excel' AS source
FROM silver_bookings_excel;
