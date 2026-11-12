# 2.2) Silver·Gold: 정제, 제외 행, 고객 360

이 페이지에서는 엑셀 값을 정제하는 **Silver**와 집계하는 **Gold**를 만드는 파이프라인을 만듭니다. 고칠 수 없는 행은 사유와 함께 `silver_booking_rejects`로 빠집니다.

## 1단계 - 파이프라인 만들기

1. 왼쪽 사이드바에서 **Jobs & Pipelines**를 엽니다.
2. **Create** → **ETL pipeline**을 선택합니다. 편집기가 바로 열리고, 파이프라인 이름은 `New Pipeline` 뒤에 날짜가 붙은 이름으로 정해집니다. 스타터 파일 `transformations/my_transformation.py`도 같이 생기는데, 이 실습에서는 쓰지 않습니다.
3. 아래 값을 입력합니다. 기본 위치(Catalog, Schema)는 파이프라인 설정의 **Edit catalog and schema**에서 바꿉니다.

| 항목 | 입력 값 |
|---|---|
| Pipeline name | `<your_name>_excel_silver_gold` |
| Default catalog | `<your_name>_wanderbricks_excel` |
| Default schema | `silver` |
| Compute | **Serverless** |

!!! tip "이름을 바꿀 때"
    파이프라인 이름을 바꾸면 루트 폴더 이름도 바꿀지 묻습니다. 여기서는 **Cancel**을 누릅니다.

!!! info "Gold 테이블은 gold 스키마에 만들어집니다"
    `gold.gold_customer_360`처럼 `gold.`으로 시작하는 이름은 기본 스키마(`silver`)가 아니라 `<your_name>_wanderbricks_excel.gold`에 게시됩니다. 이 스키마는 2.1에서 만들었습니다.

## 2단계 - 파이프라인 소스 파일 추가

파이프라인의 기본 소스는 `transformations/` 폴더뿐입니다. 아래 두 파일은 파이프라인 루트 폴더에 두고, 소스로 따로 등록합니다.

1. 파이프라인 루트 폴더에 `silver.sql`, `gold.sql` 두 파일을 올립니다. 아래 내용을 파일로 저장해 **Import**로 가져오며, 리허설에서도 이 방법을 썼습니다. 가져오기 전에 `<your_name>`을 본인 이름으로 바꿉니다.
2. 파이프라인 편집기에서 **Settings** → **Source code** → **Configure paths**를 열고 두 파일의 경로를 추가합니다. 추가하면 **Source code** 목록에 두 파일이 보입니다.

!!! warning "같은 이름으로 다시 가져오면 파일이 하나 더 생깁니다"
    같은 이름의 파일을 다시 **Import**하면 덮어쓰지 않고 날짜가 붙은 새 파일이 생깁니다 (예: `gold 2026-...sql`). 소스로 등록된 파일이 맞는지 **Source code** 목록에서 확인합니다.

### Silver: 정제와 제외 행

```sql title="silver.sql"
--8<-- "lab-files/kor/step2/silver.sql"
```

이 파일이 하는 일:

- 시스템 사용자와 리뷰(samples)를 Wanderbricks와 같은 규칙으로 정제합니다.
- 2025년 6월 1일 이전 예약은 samples에서 가져옵니다.
- 엑셀 예약은 예약 월마다 **가장 최신 업로드 버전**을 씁니다.
- 쉼표 서식(`1,132.96`)을 지우고, 공백과 대소문자를 정리합니다. 변환되지 않는 값은 `try_cast`로 NULL이 됩니다.
- 사유 규칙에 걸린 행은 `silver_booking_rejects`로 보냅니다. 같은 `booking_id`는 최신 1행만 남깁니다.

### Gold: 고객 360과 월별 국가 요약

```sql title="gold.sql"
--8<-- "lab-files/kor/step2/gold.sql"
```

### 코드 이해하기

| 구문 | 설명 |
|---|---|
| `CREATE OR REFRESH MATERIALIZED VIEW` | 선언한 결과를 파이프라인이 유지합니다. 실행할 때마다 다시 계산합니다. |
| `CONSTRAINT ... EXPECT ... ON VIOLATION DROP ROW` | 조건을 어긴 행을 버립니다. 엑셀 행은 이미 사유 규칙을 거치므로 여기서는 안전장치입니다. |
| `try_cast(... AS DECIMAL(12,2))` | 숫자로 바꿀 수 없으면 NULL을 돌려줍니다. 오류로 멈추지 않습니다. |
| `QUALIFY row_number() ... = 1` | 같은 `booking_id`가 여러 번 있으면 최신 한 행만 남깁니다. 완전 중복 행이 여기서 제거됩니다. |
| `reject_reason` | 어떤 규칙에 걸렸는지 사유를 적습니다. 현업에게 돌려줄 때 씁니다. |

## 3단계 - 파이프라인 실행

!!! warning "소스 파일을 등록하기 전에 실행하지 않습니다"
    2단계의 소스 등록 전에 실행하면 `no tables` 오류가 납니다.

1. **Run pipeline**을 누릅니다.
2. 실행 그래프에서 `silver_bookings_excel_norm`에서 `silver_booking_rejects`와 `silver_bookings_excel`로 갈라지는 것을 확인합니다.
3. 실행이 끝날 때까지 기다립니다. 리허설에서는 약 5분 걸렸습니다. 기다리는 동안 위의 **코드 이해하기** 표를 읽어 봅니다.

    ![파이프라인 실행 그래프](../assets/images/02-auto-pipeline/2-2-01-pipeline-graph.png)

## 4단계 - 결과 확인

SQL 편집기에서 아래 쿼리를 실행합니다.

```sql
SELECT date_format(created_at, 'yyyy-MM') AS ym, reject_reason, count(*) AS rejected
FROM <your_name>_wanderbricks_excel.silver.silver_booking_rejects
GROUP BY 1, 2
ORDER BY 1, 2;
```

지금은 6월만 올라 있으므로 제외 행은 **13건**입니다. 사유별로 보면 날짜 형식 오류 4건, 금액 음수 3건, booking_id 누락 3건, 상태 값 오류 3건입니다. 2.4에서 7월을 올리면 두 달을 합쳐 제외 행이 **26건**(6월 13건, 7월 13건)이 됩니다.

![제외 행 사유별 집계](../assets/images/02-auto-pipeline/2-2-02-rejects-by-reason.png)

다음으로 원본과 같은지 확인합니다. 이 쿼리는 `lab-files/kor/step2/check_excel_equality.sql`에 있습니다.

```sql title="check_excel_equality.sql"
--8<-- "lab-files/kor/step2/check_excel_equality.sql"
```

지금은 6월 행만 **OK**입니다. 6월 기대 값은 9,678건 / 5,367,628.09입니다. 7월 행은 아직 없어서 **MISMATCH**로 보이는 것이 정상입니다. 7월 기대 값은 10,342건 / 5,699,436.87입니다. 2.4에서 7월을 올린 뒤 두 달 모두 **OK**가 되는지 다시 확인합니다.

!!! warning "결과가 MISMATCH이면"
    업로드를 다시 하기 전에 제외 행과 `silver_bookings_excel`의 행 수를 먼저 봅니다. 주로 업로드 버전이 최신 규칙과 어긋나거나, 파일이 빠진 경우입니다.

Gold도 확인합니다. 6월 완료 매출은 **561,065.36**입니다.

```sql
SELECT booking_month, sum(completed_revenue) AS completed_revenue
FROM <your_name>_wanderbricks_excel.gold.gold_booking_monthly_country
WHERE booking_month = DATE '2025-06-01'
GROUP BY booking_month;
```

!!! info "국가가 빈 행은 정상입니다"
    `gold_booking_monthly_country`는 `LEFT JOIN`으로 만듭니다. 국가가 비어 있는(NULL) 행은 이메일이 없어서 Silver 사용자 목록에서 빠진 고객의 예약입니다. 이 행까지 포함해야 6월 완료 매출이 561,065.36이 됩니다.

## 확인할 결과

- 파이프라인 실행이 끝나고 그래프의 모든 노드가 완료로 표시됩니다.
- 6월 제외 행 13건이 사유와 함께 보입니다.
- 엑셀 경로의 6월 예약이 원본과 **OK**입니다.
- 6월 완료 매출이 561,065.36입니다.

!!! success "축하합니다!"
    엑셀의 지저분한 값이 정제되고, 고칠 수 없는 행이 사유와 함께 분리됐습니다. 다음 페이지에서 이 파이프라인을 Job으로 묶고 자동으로 실행합니다.
