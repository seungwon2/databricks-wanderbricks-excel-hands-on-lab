-- Wanderbricks Excel HOL · Step 2 확인 쿼리 (파이프라인 실행 뒤, 엑셀 2개월을 올린 뒤 실행)
-- 엑셀 경로로 들어온 예약이 원본(samples)과 건수·금액이 같은지 확인합니다. 모든 행이 OK면 정제가 맞게 된 것입니다.
-- 기대 결과 (리허설에서 검증한 값): 2025-06 9,678건 / 5,367,628.09, 2025-07 10,342건 / 5,699,436.87

WITH excel AS (
  SELECT date_format(created_at, 'yyyy-MM') AS ym,
         count(*) AS excel_rows,
         sum(total_amount) AS excel_amount
  FROM <your_name>_wanderbricks_excel.silver.silver_fact_bookings
  WHERE source = 'excel'
  GROUP BY 1
),
src AS (
  SELECT date_format(created_at, 'yyyy-MM') AS ym,
         count(*) AS samples_rows,
         sum(CAST(total_amount AS DECIMAL(12,2))) AS samples_amount
  FROM samples.wanderbricks.bookings
  WHERE created_at >= '2025-06-01' AND created_at < '2025-08-01'
  GROUP BY 1
)
SELECT coalesce(s.ym, e.ym) AS ym,
       s.samples_rows,
       e.excel_rows,
       s.samples_amount,
       e.excel_amount,
       CASE WHEN s.samples_rows = e.excel_rows AND s.samples_amount = e.excel_amount THEN 'OK' ELSE 'MISMATCH' END AS result
FROM src s
FULL OUTER JOIN excel e ON s.ym = e.ym
ORDER BY 1;

-- 제외 행 수: 엑셀 2개월의 제외 행은 합계 26건입니다 (6월 13건 + 7월 13건, 리허설에서 검증).
SELECT date_format(created_at, 'yyyy-MM') AS ym, reject_reason, count(*) AS rejected
FROM <your_name>_wanderbricks_excel.silver.silver_booking_rejects
GROUP BY 1, 2
ORDER BY 1, 2;
