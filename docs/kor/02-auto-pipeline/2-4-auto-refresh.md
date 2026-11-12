# 2.4) 7월 엑셀로 자동 반영 확인

이 페이지에서는 트리거가 **Active**가 된 것을 확인한 뒤 7월 엑셀을 업로드 테이블에 덮어씁니다. Job이 자동으로 실행되어 7월이 Gold에 반영되는지 봅니다.

!!! warning "기다리고, 한 번만 올리세요"
    트리거를 저장한 뒤 **1~2분** 기다렸다가 덮어씁니다. 덮어쓴 뒤 자동 실행이 **Succeeded**로 끝날 때까지 다시 올리지 마세요. 처리 중에 또 올리면 중간 업로드가 건너뛰어질 수 있습니다.

## 1단계 - 트리거 상태 확인

1. **Jobs & Pipelines**에서 Job `[<your_name>] excel bronze to gold`를 엽니다.
2. **Schedules & Triggers**에서 트리거 상태가 **Active**인지 확인합니다.
3. Active가 아니면 1분 더 기다렸다가 다시 확인합니다. 2.3의 **Save** 이후 1~2분이 지났는지 시계로 확인합니다.

## 2단계 - 7월 파일을 열고 Add-in에 다시 로그인하기

1. 내려받은 `wanderbricks_bookings_2025-07.xlsx`를 Excel 데스크톱 앱에서 엽니다. 시트 **bookings**에 헤더와 10,359행이 있습니다.
2. Add-in 창에 **Sign in** 버튼이 보이면 1.1의 3단계와 같은 방법으로 다시 로그인합니다. Add-in 로그인은 엑셀 파일마다 따로 합니다.

## 3단계 - 7월 범위를 업로드 테이블에 덮어쓰기

1. Add-in 창에서 **Write back** 탭을 엽니다.
2. **Overwrite existing table**을 선택합니다.
3. 대상을 고릅니다. **Catalog**는 `<your_name>_wanderbricks_excel`, **Schema**는 `landing`, **Table name**은 `bookings_upload`입니다.
4. 범위를 지정합니다. **Cell Range**에 `bookings!A1:J10360`을 입력하거나, 시트의 A1부터 J10360까지 선택한 뒤 **Use selection**을 누릅니다.
5. 미리보기에서 열 형식을 바꿉니다. `check_in`, `check_out`, `total_amount` 세 열을 **string**으로 바꿉니다. 열 이름 왼쪽의 타입 아이콘(`123` 또는 달력 아이콘)을 누르고 목록에서 **string**을 고릅니다. 열 이름 오른쪽의 ⌄는 누르지 않습니다.

    ![7월 파일 쓰기 설정: 열 형식 목록과 Overwrite table](../assets/images/02-auto-pipeline/2-4-01-overwrite-july.png)

!!! info "열을 문자열로 두는 이유"
    `check_in`, `check_out`에는 `TBD`처럼 날짜가 아닌 값이 있어서 날짜 형식으로 두면 쓰기가 실패합니다. `total_amount`는 `1,132.96`처럼 쉼표가 붙은 값을 그대로 남겨야 Silver에서 정제할 수 있습니다.

6. **Overwrite table**을 누릅니다. 웨어하우스가 멈춰 있었다면 쓰기가 끝나기까지 1분쯤 걸릴 수 있습니다.

!!! info "이 덮어쓰기가 자동 실행을 일으킵니다"
    업로드 테이블이 바뀌면 트리거가 Job을 시작합니다. 사람이 Job을 누를 필요가 없습니다.

## 4단계 - 자동 실행 끝까지 기다리기

1. 덮어쓰기 뒤 약 40초 안에 Job이 자동으로 시작됩니다.
2. Job의 **Runs** 탭에서 실행을 확인합니다. 실행 목록의 **Launched** 열에 **By table update**로 시작한 실행이 보입니다.
3. 세 태스크가 모두 **Succeeded**가 될 때까지 기다립니다. 리허설에서는 `load_bronze` 11초, `build_silver_gold` 1분 53초, `write_status` 12초로 전체 약 2분 20초 걸렸습니다.

    ![Job 실행 기록에서 세 태스크 성공](../assets/images/02-auto-pipeline/2-4-02-job-run.png)

!!! info "대기 중에 할 일"
    기다리는 동안 아래 확인 쿼리를 미리 준비해 둡니다. 실행이 끝난 뒤 실행하세요. 실행이 끝나기 전에 다시 엑셀에서 올리지 않습니다.

## 5단계 - 업로드 상태와 Gold 확인

SQL 편집기에서 아래 쿼리를 실행합니다.

```sql
SELECT * FROM <your_name>_wanderbricks_excel.ops.upload_status ORDER BY upload_version;
```

6월 업로드 행 아래에 7월 업로드 행이 보입니다. 가장 최신 업로드 행에 **최신 업로드**가 표시되고, 7월 행 수는 10,359행입니다. 제외 행은 13건입니다.

Gold에 7월이 들어왔는지 확인합니다.

```sql
SELECT booking_month, country, bookings, completed_revenue
FROM <your_name>_wanderbricks_excel.gold.gold_booking_monthly_country
WHERE booking_month = DATE '2025-07-01'
ORDER BY bookings DESC
LIMIT 10;
```

7월 행이 보이면 자동 반영이 끝난 것입니다. 이 페이지 전까지는 7월 행이 없었습니다. 7월 전체 합계는 다음 쿼리로 확인합니다.

```sql
SELECT booking_month, sum(bookings) AS bookings, sum(completed_revenue) AS completed_revenue
FROM <your_name>_wanderbricks_excel.gold.gold_booking_monthly_country
WHERE booking_month = DATE '2025-07-01'
GROUP BY booking_month;
```

리허설 기준 값은 예약 **10,342건**, 완료 매출 **514,860.30**입니다.

## 6단계 - 원본 비교 다시 확인

2.2의 확인 쿼리(`check_excel_equality.sql`)를 다시 실행합니다. 6월과 7월 결과가 모두 **OK**여야 합니다. 2.2에서는 7월이 아직 없어서 **MISMATCH**로 보였을 것입니다. 7월 기대 값은 10,342건 / 5,699,436.87입니다.

## 확인할 결과

- 트리거가 **Active**인 상태에서 7월 덮어쓰기 후 Job이 자동으로 실행됐습니다.
- `ops.upload_status`에 7월 업로드가 최신으로 보입니다.
- `gold_booking_monthly_country`에 2025-07 행이 생겼습니다.
- 6월과 7월 모두 원본과 **OK**입니다.

!!! success "축하합니다!"
    엑셀을 올리기만 했는데 데이터팀이 손대지 않아도 Gold가 바뀌었습니다. 다음 Step에서 이 Gold를 엑셀로 가져옵니다.
