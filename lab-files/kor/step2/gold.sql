-- Wanderbricks Excel HOL · Step 2 · 파이프라인 (Gold): 고객 360 + 엑셀로 가져갈 월별 국가 요약
-- 소스: silver_dim_users, silver_fact_bookings, silver_fact_reviews

-- (주의) bookings·reviews를 같이 조인해 집계하면 팬아웃이 생기므로, 사실 테이블별로 먼저 집계(CTE)한 뒤 사용자에 조인합니다.

CREATE OR REFRESH MATERIALIZED VIEW gold.gold_customer_360 (
  user_id           BIGINT NOT NULL COMMENT '사용자 고유 ID (PK). 고객 1명이 1행.',
  name              STRING    COMMENT '사용자 이름 (PII).',
  country           STRING    COMMENT '사용자 국가. 대문자 전체 국가명 (예: UNITED STATES, SOUTH KOREA, INDIA).',
  user_type         STRING    COMMENT '사용자 유형. 값: individual(개인 고객) / business(비즈니스 고객).',
  is_business       BOOLEAN   COMMENT '비즈니스(법인) 고객 여부.',
  lifetime_bookings BIGINT    COMMENT '생애 누적 예약 수 (모든 상태 포함, 중복 없는 booking_id 기준).',
  lifetime_spend    DOUBLE    COMMENT '생애 누적 지출액. status=completed 예약의 total_amount 합계. 예약이 없으면 NULL.',
  avg_rating_given  DOUBLE    COMMENT '사용자가 남긴 리뷰의 평균 평점(1~5). 리뷰가 없으면 NULL.',
  last_booking_at   TIMESTAMP COMMENT '가장 최근 예약 생성 시각.',
  CONSTRAINT pk_gold_customer_360 PRIMARY KEY (user_id)
)
  COMMENT 'Gold 고객 360. 사용자 1명당 1행으로 생애 예약 수·지출·평균 평점·최근 예약일을 요약.'
AS
WITH bk AS (
  SELECT user_id,
         count(DISTINCT booking_id) AS lifetime_bookings,
         sum(CASE WHEN status = 'completed' THEN total_amount END) AS lifetime_spend,
         max(created_at) AS last_booking_at
  FROM silver_fact_bookings
  GROUP BY user_id
),
rv AS (
  SELECT user_id, avg(rating) AS avg_rating_given
  FROM silver_fact_reviews
  GROUP BY user_id
)
SELECT
  u.user_id, u.name, u.country, u.user_type, u.is_business,
  coalesce(bk.lifetime_bookings, 0) AS lifetime_bookings,
  CAST(round(bk.lifetime_spend, 2) AS DOUBLE) AS lifetime_spend,  -- 선언 타입(DOUBLE)과 맞추려고 캐스트 (DECIMAL 결과와 병합 오류 방지)
  round(rv.avg_rating_given, 3)     AS avg_rating_given,
  bk.last_booking_at
FROM silver_dim_users u
LEFT JOIN bk ON u.user_id = bk.user_id
LEFT JOIN rv ON u.user_id = rv.user_id;

-- 엑셀 가져오기용: 예약 월 × 고객 국가 요약. 엑셀 Step 3과 Step 5의 Genie 답변이 이 숫자를 기준으로 봅니다.
CREATE OR REFRESH MATERIALIZED VIEW gold.gold_booking_monthly_country
  COMMENT '예약 월 × 고객 국가 요약. 예약 건수, 취소 건수, 매출(completed 금액), 취소율.'
AS
SELECT
  CAST(date_trunc('MONTH', b.created_at) AS DATE)                              AS booking_month,
  u.country                                                                     AS country,
  count(*)                                                                      AS bookings,
  count(CASE WHEN b.status = 'cancelled' THEN 1 END)                            AS cancelled_bookings,
  round(sum(CASE WHEN b.status = 'completed' THEN b.total_amount END), 2)       AS completed_revenue,
  round(count(CASE WHEN b.status = 'cancelled' THEN 1 END) / count(*), 4)       AS cancellation_rate
FROM silver_fact_bookings b
-- LEFT JOIN: 사용자 차원에서 빠진 고객(이메일 결측 등)의 예약도 매출에 남깁니다. 국가는 NULL로 나옵니다.
-- Metric View의 조인도 LEFT JOIN이라, 이렇게 해야 엑셀(Gold)과 대시보드(Metric View)의 합계가 같습니다.
LEFT JOIN silver_dim_users u ON b.user_id = u.user_id
GROUP BY ALL;
