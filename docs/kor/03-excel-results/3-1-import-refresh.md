# 3.1) Gold 가져오기와 새로고침

이 페이지에서는 `gold_booking_monthly_country`를 엑셀 시트로 가져오고, 새로고침으로 최신 값을 받습니다.

## 1단계 - 가져올 Gold 확인

엑셀에서 가져오기 전에 SQL 편집기에서 어떤 값이 들어갈지 확인합니다.

```sql
SELECT booking_month, country, bookings, cancelled_bookings, completed_revenue, cancellation_rate
FROM <your_name>_wanderbricks_excel.gold.gold_booking_monthly_country
ORDER BY booking_month, country
LIMIT 20;
```

!!! info "국가가 빈 행은 정상입니다"
    국가가 비어 있는 행은 이메일이 없는 고객의 예약입니다. Silver의 사용자 목록에서 빠진 고객이지만, Gold에서는 매출에 남도록 `LEFT JOIN`으로 만들었습니다. 그래서 가져온 시트의 행 수는 3,065행입니다.

## 2단계 - 엑셀에서 가져오기

1. 새 엑셀 통합 문서를 엽니다. Add-in에 **Sign in** 버튼이 보이면 1.1의 3단계와 같은 방법으로 로그인합니다.
2. Databricks Add-in 창에서 **New import** 탭을 엽니다.
3. **Import method**를 **Select data**로 둡니다. 카탈로그에서 `<your_name>_wanderbricks_excel` → `gold` → `gold_booking_monthly_country`를 고릅니다.
4. **Limit** 스위치를 끕니다. 기본값은 **Limit 1000 rows**로 켜져 있어서 두지 않으면 3,065행 중 1,000행만 들어옵니다.

    ![Gold 테이블을 New import로 가져오기: Limit 스위치와 Save and import](../assets/images/03-excel-results/3-1-01-import-gold.png)

5. **Save and import**를 누르면 **Import to worksheet** 창이 열립니다. **Import name**을 확인하고 **Output destination**에서 **New sheet**를 고른 뒤 **Confirm**을 누릅니다.

!!! info "가져온 시트는 테이블과 연결됩니다"
    가져온 시트는 원본 테이블의 복사본입니다. 테이블의 최신 값으로 바꾸려면 3단계의 **Refresh All**을 누릅니다.

!!! tip "1,000행만 들어왔다면"
    **Limit**을 켠 채로 가져왔다면 가져온 행이 1,000행에서 멈춥니다. 이때는 다음과 같이 고칩니다.

    1. Add-in 창에서 **Saved imports** 탭을 엽니다.
    2. 방금 가져온 항목을 열어 편집 화면을 엽니다. 편집 화면에 **Back to Imports**가 보이면 됩니다. <!-- TODO(확인): 편집 화면을 여는 메뉴 이름(⋮ 또는 연필 아이콘). -->
    3. **Limit** 스위치를 끄고 **Update**를 누릅니다.

    ![저장된 가져오기 편집 화면에서 Limit을 끄고 Update](../assets/images/03-excel-results/3-1-03-update-limit.png)

    다시 **Refresh All**을 누르면 3,065행이 보입니다.

## 3단계 - 새로고침

1. 2.4에서 7월을 올린 뒤에 가져왔다면 시트에 두 달이 모두 보입니다. 가져온 뒤 값이 바뀌었을 수 있으니 새로고침합니다.
2. Add-in 창에서 **Saved imports** 탭을 엽니다. 오른쪽 위의 **Refresh All**을 누릅니다.
3. 시트에 2025-06과 2025-07 행이 모두 있는지 확인합니다.

    ![Refresh All 뒤 두 달 행이 보이는 시트](../assets/images/03-excel-results/3-1-02-refresh-all.png)

## 4단계 - 숫자 확인

시트에서 월별로 `completed_revenue`를 더합니다(예: `SUMIF`). 리허설 기준 값은 다음과 같습니다.

| 월 | 완료(completed) 매출 |
|---|---|
| 2025-06 | 561,065.36 |
| 2025-07 | 514,860.30 |

!!! tip "매출은 completed만 더합니다"
    `completed_revenue`는 이미 완료된 예약의 금액입니다. 취소된 예약 금액(`cancelled`)은 들어 있지 않습니다. 엑셀에서 `SUM(total_amount)`으로 예약 금액 전체를 더하면 다른 숫자가 나옵니다. 이 차이가 문제 장면의 원인입니다.

## 확인할 결과

- 가져온 시트에 월별 국가 요약이 보입니다.
- 시트에 2025-06과 2025-07 행이 모두 있습니다.
- 6월과 7월 완료 매출이 위 표와 같습니다.

!!! success "축하합니다!"
    데이터팀의 Gold를 엑셀에서 바로 받았습니다. 다음 페이지에서는 제외 행을 고쳐서 다시 올리는 선택 실습을 합니다. 건너뛰어도 Step 4와 5에 영향이 없습니다.
