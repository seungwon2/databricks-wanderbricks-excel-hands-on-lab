-- Wanderbricks Excel HOL · Step 2 · Job 태스크 1 (SQL 태스크): 업로드 테이블 → Bronze 이력
-- 업로드 테이블 <your_name>_wanderbricks_excel.landing.bookings_upload 의 최신 버전을 열 이름 기준으로 전부 STRING으로 적재합니다.
-- 같은 버전은 두 번 적재하지 않습니다 (Job이 여러 번 실행돼도 안전).
-- 열 이름이 빠지면 여기서 실패합니다 (의도된 동작: 필수 열 확인).

BEGIN
  DECLARE up_version BIGINT;
  DECLARE up_by STRING;
  DECLARE up_at TIMESTAMP;

  SET up_version = (SELECT max(version) FROM (DESCRIBE HISTORY <your_name>_wanderbricks_excel.landing.bookings_upload));
  SET up_by = (SELECT coalesce(max(userName), 'unknown')
               FROM (DESCRIBE HISTORY <your_name>_wanderbricks_excel.landing.bookings_upload)
               WHERE version = up_version);
  SET up_at = (SELECT max(timestamp)
               FROM (DESCRIBE HISTORY <your_name>_wanderbricks_excel.landing.bookings_upload)
               WHERE version = up_version);

  CREATE TABLE IF NOT EXISTS <your_name>_wanderbricks_excel.bronze.bookings_upload_history (
    booking_id    STRING,
    user_id       STRING,
    property_id   STRING,
    country       STRING,
    check_in      STRING,
    check_out     STRING,
    guests_count  STRING,
    total_amount  STRING,
    status        STRING,
    created_at    STRING,
    _upload_version BIGINT,
    _uploaded_by    STRING,
    _uploaded_at    TIMESTAMP,
    _loaded_at      TIMESTAMP
  )
  COMMENT 'Bronze 엑셀 업로드 이력. 모든 업로드 버전의 원본을 문자열 그대로 쌓습니다.';

  IF NOT EXISTS (SELECT 1 FROM <your_name>_wanderbricks_excel.bronze.bookings_upload_history
                 WHERE _upload_version = up_version) THEN
    INSERT INTO <your_name>_wanderbricks_excel.bronze.bookings_upload_history
    SELECT CAST(booking_id AS STRING),
           CAST(user_id AS STRING),
           CAST(property_id AS STRING),
           CAST(country AS STRING),
           CAST(check_in AS STRING),
           CAST(check_out AS STRING),
           CAST(guests_count AS STRING),
           CAST(total_amount AS STRING),
           CAST(status AS STRING),
           CAST(created_at AS STRING),
           up_version, up_by, up_at, current_timestamp()
    FROM <your_name>_wanderbricks_excel.landing.bookings_upload;  -- VERSION AS OF 에는 변수를 쓸 수 없어 현재 버전(= up_version)을 읽습니다
  END IF;
END
