-- Wanderbricks Excel HOL · Step 2 · Job 태스크 3 (SQL 태스크): 갱신 기록과 업로드 상태 뷰
-- 파이프라인이 끝난 뒤 한 줄을 남기고, 엑셀에서 볼 업로드 상태 뷰를 다시 만듭니다.

CREATE TABLE IF NOT EXISTS <your_name>_wanderbricks_excel.ops.refresh_log (
  refreshed_at      TIMESTAMP,
  upload_version    BIGINT,
  uploaded_rows     BIGINT,
  accepted_rows     BIGINT,
  rejected_rows     BIGINT
)
COMMENT '파이프라인 실행마다 한 줄: 최신 업로드 버전, 업로드 행 수, 정상 행 수, 제외 행 수.';

INSERT INTO <your_name>_wanderbricks_excel.ops.refresh_log
SELECT
  current_timestamp(),
  (SELECT max(_upload_version) FROM <your_name>_wanderbricks_excel.bronze.bookings_upload_history),
  (SELECT count(*) FROM <your_name>_wanderbricks_excel.bronze.bookings_upload_history
     WHERE _upload_version = (SELECT max(_upload_version) FROM <your_name>_wanderbricks_excel.bronze.bookings_upload_history)),
  (SELECT count(*) FROM <your_name>_wanderbricks_excel.silver.silver_bookings_excel
     WHERE _upload_version = (SELECT max(_upload_version) FROM <your_name>_wanderbricks_excel.bronze.bookings_upload_history)),
  (SELECT count(*) FROM <your_name>_wanderbricks_excel.silver.silver_booking_rejects
     WHERE _upload_version = (SELECT max(_upload_version) FROM <your_name>_wanderbricks_excel.bronze.bookings_upload_history));

CREATE OR REPLACE VIEW <your_name>_wanderbricks_excel.ops.upload_status
  COMMENT '업로드 버전별 상태: 올린 사람, 시각, 행 수, 제외 행 수, 최신 여부.'
AS
WITH up AS (
  SELECT _upload_version, any_value(_uploaded_by) AS uploaded_by, any_value(_uploaded_at) AS uploaded_at,
         count(*) AS uploaded_rows
  FROM <your_name>_wanderbricks_excel.bronze.bookings_upload_history
  GROUP BY _upload_version
),
rj AS (
  SELECT _upload_version, count(*) AS rejected_rows
  FROM <your_name>_wanderbricks_excel.silver.silver_booking_rejects
  GROUP BY _upload_version
)
SELECT
  up.uploaded_at,
  up.uploaded_by,
  up._upload_version AS upload_version,
  up.uploaded_rows,
  coalesce(rj.rejected_rows, 0) AS rejected_rows,
  CASE WHEN up._upload_version = (SELECT max(_upload_version) FROM <your_name>_wanderbricks_excel.bronze.bookings_upload_history)
       THEN '최신 업로드' ELSE '이전 업로드' END AS status
FROM up
LEFT JOIN rj ON up._upload_version = rj._upload_version;
