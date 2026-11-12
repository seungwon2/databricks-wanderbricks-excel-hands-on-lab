# 4.2) Metric View로 대시보드 만들기

이 페이지에서는 `mv_bookings`를 데이터셋으로 쓰는 AI/BI 대시보드를 만듭니다. 월별 매출 차트를 만들고, 엑셀의 숫자와 같은지 확인합니다.

!!! info "이 페이지는 생략할 수 있습니다"
    시간이 부족하면 이 페이지를 건너뛰어도 됩니다. Step 5의 Genie는 Metric View를 직접 씁니다.

## 1단계 - 대시보드 만들기

1. 왼쪽 사이드바에서 **Dashboards**를 엽니다.
2. **Create dashboard**를 누릅니다. 기본 이름(`New Dashboard`로 시작하는 이름)으로 빈 대시보드가 열립니다.
3. 대시보드 이름을 `<your_name> Wanderbricks 엑셀 매출`로 바꿉니다. 예를 들어 이름이 Jiyu라면 `jiyu Wanderbricks 엑셀 매출`이 됩니다.

## 2단계 - 데이터셋 추가

1. 대시보드의 **Data** 탭에서 **Add SQL dataset**을 누릅니다.
2. 쿼리 입력란에 아래 SQL을 붙여 넣고 `<your_name>`을 바꾼 뒤 **Run**을 누릅니다. 결과 행이 보이면 됩니다.

```sql
SELECT `예약 월`, `고객 국가`, MEASURE(`매출`) AS revenue, MEASURE(`총 예약 금액`) AS gross_booking_value, MEASURE(`예약 건수`) AS bookings
FROM <your_name>_wanderbricks_excel.gold.mv_bookings
GROUP BY `예약 월`, `고객 국가`
```

    ![Data 탭에서 Add SQL dataset으로 Metric View 쿼리 추가](../assets/images/04-metric-view-dashboard/4-2-01-add-dataset.png)

!!! info "국가가 빈 행"
    결과에 **고객 국가**가 비어 있는 행이 하나 있습니다. 3.1과 같이 이메일이 없는 고객의 예약입니다. 매출 합계에는 포함됩니다.

!!! tip "국가 필터"
    **고객 국가**를 기준으로 필터를 추가하면 지역 운영 매니저별로 볼 수 있습니다. <!-- TODO(확인): 필터 위젯 추가 방법. -->
## 3단계 - 위젯 만들기

1. 캔버스에서 **Add a visualization**을 누르고 차트 종류로 **Bar**를 고릅니다.
2. X축에 **예약 월**을 놓고 기간 단위를 **MONTHLY**로 둡니다.
3. Y축에 **SUM(revenue)** 필드를 놓습니다.

![월별 매출 막대 차트: X축 예약 월, Y축 revenue](../assets/images/04-metric-view-dashboard/4-2-02-revenue-chart.png)

!!! tip "차트에 nulls가 보일 때"
    차트 머리글에 `nulls`가 보일 수 있습니다. 매출이 비어 있는 행이 결과에 섞여 있다는 뜻입니다. 합계 숫자에는 영향이 없습니다.

| 위젯 | 종류 | 설정 |
|---|---|---|
| 월별 매출 | 막대 차트 | X: **예약 월** (MONTHLY), Y: **SUM(revenue)** |
| 총 매출 | 카운터 | <!-- TODO(확인): 리허설에서 만들지 않음 --> 같은 데이터셋의 **revenue** 합계로 만듭니다. |
| 국가별 요약 | 표 | <!-- TODO(확인): 리허설에서 만들지 않음 --> 행: **고객 국가**, 열: **revenue**, **bookings** |

## 4단계 - 엑셀 숫자와 비교

1. 3.1에서 엑셀에 가져온 시트를 엽니다.
2. 대시보드의 2025-07 매출과 시트의 2025-07 `completed_revenue` 합계를 비교합니다.
3. 두 숫자가 같으면 같은 정의에서 나온 것입니다.

리허설에서 확인한 값은 다음과 같습니다.

| 예약 월 | 매출 |
|---|---|
| 2025-06 | 561,065.36 |
| 2025-07 | 514,860.30 |

!!! success "축하합니다!"
    대시보드와 엑셀이 같은 정의에서 만들어졌습니다. 다음 Step에서 같은 정의를 Genie에 가르칩니다.
