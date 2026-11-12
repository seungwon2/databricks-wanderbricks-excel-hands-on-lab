# 4.1) Metric View: 예약

이 페이지에서는 예약 Metric View `mv_bookings`를 만듭니다. "매출"은 status가 `completed`인 예약의 `total_amount` 합계로 정의합니다.

## 1단계 - Metric View 정의 확인

아래 YAML이 Metric View의 정의입니다. 원본(`silver_fact_bookings`)과 고객 차원(`silver_dim_users`)을 가리키고, 측정값과 차원을 이름으로 정합니다. 이 YAML은 다음 단계의 SQL 안에 그대로 들어갑니다.

```yaml title="mv_bookings.yaml"
--8<-- "lab-files/kor/step4/mv_bookings.yaml"
```

### 코드 이해하기

| 항목 | 설명 |
|---|---|
| `source` | 측정값의 기준이 되는 Silver 예약 테이블입니다. 1행이 예약 1건입니다. |
| `joins` | 고객 국가와 유형을 가져오기 위해 `silver_dim_users`를 연결합니다. |
| `dimensions` | 월, 국가, 상태처럼 자르는 기준입니다. |
| `measures` / **매출** | `status = 'completed'`인 금액만 더합니다. 이 정의가 실습 전체의 "매출"입니다. |
| **총 예약 금액** | 모든 상태를 더한 금액입니다. 매출과 다르다는 것을 보여 주려고 따로 둡니다. |
| **취소율** | 취소 건수 ÷ 전체 건수입니다. |

## 2단계 - SQL로 Metric View 만들기

SQL로 만드는 것을 권장합니다. UI 편집기에 YAML을 붙여 넣으면 들여쓰기가 흐트러지기 쉽습니다.

1. SQL 편집기에서 새 쿼리 탭을 엽니다.
2. 아래 SQL을 붙여 넣고 `<your_name>`을 본인 이름으로 바꿉니다. 예를 들어 이름이 Jiyu라면 `jiyu_wanderbricks_excel`이 됩니다.
3. **Run all**을 누릅니다. 오류 없이 끝나면 `gold` 스키마에 `mv_bookings`가 생깁니다.

```sql title="create_mv_bookings.sql"
--8<-- "lab-files/kor/step4/create_mv_bookings.sql"
```

### 코드 이해하기

| 구문 | 설명 |
|---|---|
| `CREATE OR REPLACE VIEW` | 같은 이름의 뷰가 있으면 정의를 바꿔서 다시 만듭니다. |
| `WITH METRICS` | 일반 뷰가 아니라 Metric View로 만든다는 표시입니다. |
| `LANGUAGE YAML` | 뒤의 본문을 YAML 정의로 읽습니다. |
| `$$ ... $$` | YAML 본문을 감싸는 구분자입니다. 안에 있는 따옴표나 줄바꿈을 그대로 둡니다. |

실행이 끝나면 카탈로그에서 `mv_bookings`를 열어 측정값 목록을 확인할 수 있습니다. **Measures** 목록에 **매출**과 **총 예약 금액**이 보입니다.

![mv_bookings 카탈로그 개요의 Measures 목록 (매출, 총 예약 금액)](../assets/images/04-metric-view-dashboard/4-1-01-create-metric-view.png)

!!! info "UI로 만들 수도 있습니다 (대안)"
    1. 왼쪽 사이드바에서 **Catalog**를 열고 `<your_name>_wanderbricks_excel` → `gold` 스키마를 고릅니다.
    2. **Create** → **Metric view**를 고릅니다. 대화상자에서 **Name**에 `mv_bookings`를 입력합니다. **Location**은 카탈로그와 스키마가 미리 채워집니다.
    3. 편집기가 열리면 상단의 `<>`(YAML) 아이콘을 눌러 YAML 화면으로 바꾸고, 1단계의 YAML을 붙여 넣습니다. 붙여 넣은 뒤 들여쓰기가 맞는지 확인합니다.
    4. **Save**를 누릅니다.

    !!! warning "붙여 넣기 후 들여쓰기를 꼭 확인합니다"
        리허설에서는 편집기에 YAML을 붙여 넣는 것이 잘 되지 않았습니다. 들여쓰기가 흐트러졌다면 2단계의 SQL로 다시 만듭니다.

## 3단계 - 측정값 조회

SQL 편집기에서 월별 매출과 총 예약 금액을 같이 조회합니다.

```sql
SELECT `예약 월`,
       MEASURE(`매출`)        AS revenue,
       MEASURE(`총 예약 금액`) AS gross_booking_value,
       MEASURE(`취소율`)      AS cancellation_rate
FROM <your_name>_wanderbricks_excel.gold.mv_bookings
GROUP BY `예약 월`
ORDER BY `예약 월`;
```

리허설에서 확인한 값은 다음과 같습니다. 7월 값은 2.4에서 7월 데이터를 올린 뒤의 값입니다.

| 예약 월 | 매출 (completed) | 총 예약 금액 (모든 상태) |
|---|---|---|
| 2025-06 | 561,065.36 | 5,367,628.09 |
| 2025-07 | 514,860.30 | 5,699,436.87 |

![Metric View로 매출과 총 예약 금액 조회 결과 (2025-06, 2025-07 행)](../assets/images/04-metric-view-dashboard/4-1-02-query-measures.png)

!!! tip "편집기 결과는 반올림되어 보일 수 있습니다"
    SQL 편집기의 결과 표는 소수점을 줄여 **514,860**, **5,699,437**처럼 보일 수 있습니다. 같은 값입니다.

!!! warning "두 숫자가 다른 이유"
    **총 예약 금액**은 취소된 예약까지 모두 더합니다. **매출**은 status가 `completed`인 예약만 더합니다. 엑셀 합계가 매출보다 훨씬 큰 이유가 이것입니다. 두 숫자의 정의가 Metric View에 한 번만 적혀 있으므로, 대시보드와 엑셀이 같은 숫자를 씁니다.

## 확인할 결과

- Metric View `mv_bookings`가 `gold` 스키마에 있습니다.
- `MEASURE(매출)`과 `MEASURE(총 예약 금액)`이 다른 숫자로 나옵니다.
- 6월 매출이 561,065.36입니다.

!!! success "축하합니다!"
    "매출"의 정의를 Metric View에 한 번 적었습니다. 다음 페이지에서 이 정의로 대시보드를 만듭니다.
