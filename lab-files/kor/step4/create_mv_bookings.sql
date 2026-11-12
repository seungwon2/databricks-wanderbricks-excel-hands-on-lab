-- Wanderbricks Excel HOL · Step 4 · Metric View 만들기 (SQL)
-- 아래 YAML은 mv_bookings.yaml과 같은 내용입니다. 고칠 때는 두 파일을 함께 고칩니다.
-- <your_name>을 본인 이름으로 바꾼 뒤 실행합니다 (YAML 안의 source, joins도 함께 바뀝니다).

CREATE OR REPLACE VIEW <your_name>_wanderbricks_excel.gold.mv_bookings
WITH METRICS
LANGUAGE YAML
AS $$
version: 1.1
comment: "Wanderbricks 엑셀 실습 예약 Metric View. 1행 = 예약 1건 (silver_fact_bookings, 시스템 이력 + 엑셀 업로드). 고객 국가는 silver_dim_users와 조인. 데이터 기간: 2025-06 ~ 2025-07 (엑셀 2개월, 2025-06-01 이전은 시스템 이력). 매출 = status가 completed인 예약의 total_amount 합계. 예약 상태: pending / confirmed / cancelled / completed."
source: <your_name>_wanderbricks_excel.silver.silver_fact_bookings
joins:
  - name: dim_user
    source: <your_name>_wanderbricks_excel.silver.silver_dim_users
    'on': source.user_id = dim_user.user_id
dimensions:
  - name: 예약일
    expr: CAST(source.created_at AS DATE)
    comment: 예약이 생성된 날짜 (created_at 기준).
    display_name: 예약일
    synonyms: [예약 날짜, 예약 생성일, booking date]
    format:
      type: date
      date_format: year_month_day
  - name: 예약 월
    expr: "DATE_TRUNC('MONTH', source.created_at)"
    comment: 예약이 생성된 월 (created_at 을 월 단위로 절삭).
    display_name: 예약 월
    synonyms: [예약월, 월별, booking month]
    format:
      type: date
      date_format: locale_short_month
  - name: 예약 상태
    expr: source.status
    comment: "예약 상태. 값: pending(대기) / confirmed(확정) / cancelled(취소) / completed(숙박 완료)."
    display_name: 예약 상태
    synonyms: [상태, status, booking status]
  - name: 고객 국가
    expr: dim_user.country
    comment: 예약한 고객의 국가. 대문자 전체 국가명 (예 UNITED STATES, SOUTH KOREA, JAPAN). 국가 코드(US, KR)가 아님.
    display_name: 고객 국가
    synonyms: [국가, 나라, country, 시장]
  - name: 고객 유형
    expr: dim_user.user_type
    comment: "고객 유형. 값: individual(개인 고객) / business(비즈니스 고객)."
    display_name: 고객 유형
    synonyms: [고객 세그먼트, 세그먼트, user type, 개인/비즈니스]
  - name: 숙박일수 구간
    expr: |
      CASE WHEN source.nights <= 2 THEN '1) 1-2박'
           WHEN source.nights <= 4 THEN '2) 3-4박'
           WHEN source.nights <= 7 THEN '3) 5-7박'
           ELSE '4) 8박 이상' END
    comment: 체크인~체크아웃 숙박일수(nights)를 1-2박 / 3-4박 / 5-7박 / 8박 이상으로 구간화.
    display_name: 숙박일수 구간
    synonyms: [숙박 기간, 박수 구간, length of stay]
measures:
  - name: 매출
    expr: SUM(CASE WHEN source.status = 'completed' THEN source.total_amount END)
    comment: 매출. status = completed 예약의 total_amount 합계. 취소·대기·확정 예약은 제외. 이 Metric View에서 "매출"의 유일한 정의입니다.
    display_name: 매출
    synonyms: [revenue, 매출액, 순매출, completed revenue]
    format:
      type: currency
      currency_code: USD
      decimal_places:
        type: exact
        places: 0
  - name: 총 예약 금액
    expr: SUM(source.total_amount)
    comment: 예약 금액(total_amount) 합계. 모든 예약 상태(pending, confirmed, cancelled, completed)를 포함한 총 거래액(GBV). 매출과 다름.
    display_name: 총 예약 금액
    synonyms: [예약 금액, GBV, 총 거래액, gross booking value]
    format:
      type: currency
      currency_code: USD
      decimal_places:
        type: exact
        places: 0
  - name: 예약 건수
    expr: COUNT(source.booking_id)
    comment: 예약 건수. 모든 예약 상태 포함.
    display_name: 예약 건수
    synonyms: [예약 수, 예약량, bookings, booking count]
    format:
      type: number
      decimal_places:
        type: exact
        places: 0
  - name: 취소율
    expr: "COUNT(source.booking_id) FILTER (WHERE source.status = 'cancelled') / COUNT(source.booking_id)"
    comment: 전체 예약 건수 중 status = cancelled 인 예약의 비율.
    display_name: 취소율
    synonyms: [취소 비율, cancellation rate, 캔슬율]
    format:
      type: percentage
      decimal_places:
        type: exact
        places: 1
  - name: 예약 고객 수
    expr: COUNT(DISTINCT source.user_id)
    comment: 예약을 1건 이상 한 고유 고객 수.
    display_name: 예약 고객 수
    synonyms: [예약자 수, 고객 수, unique bookers]
    format:
      type: number
      decimal_places:
        type: exact
        places: 0
$$;
