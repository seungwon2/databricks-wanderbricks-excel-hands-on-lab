# 3.2) (Optional) 제외 행 고쳐서 다시 올리기

이 페이지에서는 `silver_booking_rejects`를 엑셀로 가져와 사유를 확인하고, 원본 엑셀에서 행을 고쳐 **같은 달 전체를 다시 덮어씁니다**. 이 페이지는 선택 사항이며, 건너뛰어도 다음 Step에 영향이 없습니다.

!!! warning "같은 달 전체를 다시 올려야 합니다"
    `landing.bookings_upload`는 **마지막 업로드 하나**만 담습니다. Silver는 예약 월마다 **가장 최신 업로드 버전**에서 그 달 행을 가져옵니다. 그래서 제외 행만 올리면 그 달의 나머지 행이 사라집니다. 고친 행이 들어 있는 **그 달 원본 파일 전체**를 다시 덮어써야 합니다.

## 1단계 - 제외 행 가져오기

1. 새 엑셀 통합 문서에서 Databricks Add-in 창의 **New import** 탭을 엽니다.
2. `<your_name>_wanderbricks_excel` → `silver` → `silver_booking_rejects`를 고르고 **Save and import**를 누릅니다. 가져오기 창에서 **Confirm**을 누릅니다.
3. 사유 열(`reject_reason`)을 기준으로 정렬합니다.

    ![제외 행과 사유 열](../assets/images/03-excel-results/3-2-01-rejects-sheet.png)

## 2단계 - 원본 파일에서 고치기

가져온 시트에서 `booking_id`와 `reject_reason`을 보고, **원본 7월 파일**에서 같은 행을 찾아 고칩니다. 리허설에서 나온 사유는 네 가지입니다.

| 사유 (`reject_reason`) | 고치는 방법 |
|---|---|
| 상태 값 오류 (예: `on_hold`) | `pending`, `confirmed`, `cancelled`, `completed` 중 하나로 바꿉니다 |
| 금액 음수 | 금액 부호를 바로잡거나, 잘못 들어간 행이면 행을 삭제합니다 |
| 날짜 형식 오류 (YYYY-MM-DD 아님, 예: `2025-7-3`, `TBD`) | `YYYY-MM-DD` 형식으로 고칩니다 |
| booking_id 누락 | 원본 시스템 번호가 있으면 채우고, 없으면 행을 삭제합니다 |

!!! info "실습용 파일이라 일부는 삭제가 맞습니다"
    이 파일의 오류 행은 가짜 행입니다. 실제로는 원본 시스템에서 확인해 고치는 것이 맞지만, 실습에서는 삭제하거나 상태만 고쳐도 됩니다.

## 3단계 - 같은 달 전체 다시 덮어쓰기

1. 고친 원본 7월 파일 전체를 선택합니다. 헤더 포함 A1부터 J10360까지입니다.
2. 2.4의 3단계와 같은 방법으로 **Write back** 탭에서 대상 `<your_name>_wanderbricks_excel.landing.bookings_upload`를 고르고, **Overwrite existing table**로 **Overwrite table**을 누릅니다. 열 형식도 2.4와 같이 `check_in`, `check_out`, `total_amount`를 **string**으로 둡니다.

    <!-- TODO(확인): 이 재업로드 흐름은 리허설에서 실행하지 않았습니다. 제외 행을 고친 뒤 실제 결과를 확인합니다. -->
3. 자동 실행이 **Succeeded**로 끝날 때까지 기다린 뒤 2.2의 확인 쿼리(`check_excel_equality.sql`)를 다시 실행합니다. 다음 업로드는 그때 합니다.

## 확인할 결과

- 제외 행 수가 줄어듭니다. 고친 행이 정상 행이 되어 `silver_bookings_excel`로 들어갑니다.
- Gold의 2025-07 완료 매출이 바뀝니다. 고친 행의 상태가 `completed`로 바뀌었다면 그만큼 늘어납니다.
- **Refresh All**을 누르면 시트도 바뀝니다.

!!! success "축하합니다!"
    엑셀에서 받은 사유를 보고 고쳐서 다시 올렸습니다. 현업이 데이터팀에 요청하지 않고 정제 결과를 바꿀 수 있는 흐름입니다.
