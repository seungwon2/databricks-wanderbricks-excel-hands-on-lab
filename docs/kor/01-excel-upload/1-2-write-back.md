# 1.2) 6월 예약을 업로드 테이블로 쓰기

이 페이지에서는 6월 예약 엑셀을 **Create table**로 업로드 테이블로 만듭니다. 날짜와 금액 열은 문자열로 바꿔서 만들고, 금액의 쉼표가 테이블에 그대로 남는 것을 확인합니다. 7월 파일은 Step 2.4에서 덮어쓰면서 자동 반영을 확인합니다.

!!! warning "업로드 테이블은 한 번에 한 파일만 담습니다"
    `landing.bookings_upload`는 마지막으로 쓴 파일만 담습니다. 덮어쓰면 이전 내용은 테이블에서 사라지고 Bronze 이력에만 남습니다. Silver는 예약 월마다 최신 버전을 쓰므로, 한 달을 고치려면 그 달 파일 전체를 다시 덮어써야 합니다.

## 1단계 - 카탈로그와 스키마 준비

Write back은 이미 있는 카탈로그와 스키마에 테이블을 만듭니다. 먼저 본인 카탈로그를 만듭니다.

1. Databricks 워크스페이스 왼쪽 사이드바에서 **Catalog**를 엽니다. Catalog Explorer 오른쪽 위의 **Create** → **Create a catalog**를 누릅니다.
2. 카탈로그 이름에 `<your_name>_wanderbricks_excel`을 입력합니다. 예를 들어 이름이 Jiyu라면 `jiyu_wanderbricks_excel`입니다. 유형은 **Standard**, 저장 위치는 **Use default storage**로 두고 **Create**를 누릅니다.
3. 카탈로그 화면에서 **Create schema**를 눌러 스키마 `landing`을 만듭니다.

    ![Catalog Explorer에서 본인 카탈로그 생성](../assets/images/01-excel-upload/1-2-01-create-catalog.png)

!!! info "나머지 스키마는 2.1에서 만듭니다"
    `bronze`, `silver`, `gold`, `ops` 스키마는 2.1에서 SQL로 한 번에 만듭니다. 지금은 `landing`만 있으면 됩니다.

!!! info "권한이 없다면"
    카탈로그를 만들 수 없으면 관리자에게 공용 카탈로그를 받아 그 안에 `<your_name>_wanderbricks_excel` 스키마를 만들어 달라고 요청합니다. 이때 테이블 이름 앞에 `landing_`처럼 접두어를 씁니다. <!-- TODO(확인): 접두어 방식의 실제 이름 규칙을 리허설에서 확인. -->
## 2단계 - Write back 탭 열기

1. Excel에서 `wanderbricks_bookings_2025-06.xlsx`의 **bookings** 시트를 엽니다.
2. Databricks Add-in 창에서 **Write back** 탭을 엽니다. **Write mode**의 기본값은 **Create new table**입니다.

    ![Add-in의 Write back 탭](../assets/images/01-excel-upload/1-2-02-write-back-tab.png)

## 3단계 - 6월 범위 선택

1. 엑셀에서 `bookings` 시트의 A1부터 J9695까지 데이터 전체를 선택합니다. 헤더 행을 포함합니다.
2. Add-in의 **Cell Range** 옆 범위 선택 아이콘을 누릅니다. 입력란에 `bookings!A1:J9695`가 채워지고 **Use selection** 버튼이 눌릴 수 있게 됩니다.
3. **Use selection**을 누릅니다. 미리보기에 "Previewing 9 rows, 10 columns"가 보입니다. 이 9행은 미리보기 샘플이고, 전체 행 수가 아닙니다.

    ![Use selection으로 범위 지정](../assets/images/01-excel-upload/1-2-03-use-selection.png)

    !!! tip "행 수가 맞는지 확인"
        헤더 한 줄과 데이터 9,694줄입니다. 빈 줄이 섞이면 빈 행이 함께 써집니다.

## 4단계 - 날짜와 금액 열을 문자열로 바꾸고 테이블 만들기

1. **Catalog**, **Schema**, **Table name**에 각각 `<your_name>_wanderbricks_excel`, `landing`, `bookings_upload`를 입력합니다. 예를 들어 이름이 Jiyu라면 `jiyu_wanderbricks_excel.landing.bookings_upload`입니다.
2. 미리보기에서 열 이름이 `booking_id`, `user_id`, `property_id`, `country`, `check_in`, `check_out`, `guests_count`, `total_amount`, `status`, `created_at`인지 확인합니다.
3. `check_in`, `check_out`, `total_amount` 열 머리글 옆의 타입 아이콘을 누르고 목록에서 **string**을 고릅니다. 세 열의 아이콘이 **ABC**로 바뀌는지 확인합니다.

    !!! info "열 형식은 미리보기 열 머리글에서 바꿉니다"
        **Advanced options**에는 열 형식을 바꾸는 항목이 없습니다. 열 형식은 미리보기의 열 머리글에서 바꿉니다.

    !!! warning "날짜와 금액 열은 문자열로 둡니다"
        - `check_in`, `check_out`을 날짜로 두면 `TBD` 같은 값 때문에 **Create table**이 실패합니다. 메시지는 `Column "check_in" is set to DATE but contains "TBD"...`입니다.
        - `total_amount`를 숫자로 두면 `1,132.96`처럼 쉼표가 붙은 금액 66건이 오류 없이 **NULL**이 됩니다. 문자열로 두면 쉼표가 남고, Silver에서 쉼표를 지우고 숫자로 바꿉니다.

4. **Create table**을 누릅니다. **Write back successful** 메시지가 보이면 완료입니다.

    ![Create table 미리보기와 열 이름](../assets/images/01-excel-upload/1-2-04-create-table-preview.png)

    !!! info "나머지 열 타입은 엑셀 내용을 따릅니다"
        Write back은 엑셀 내용을 보고 나머지 열의 타입을 정합니다. `booking_id`, `user_id`, `property_id`, `guests_count`는 `bigint`, `created_at`은 `timestamp`로 만들어집니다.

    !!! warning "웨어하우스가 멈춰 있으면 1분쯤 기다립니다"
        SQL warehouse가 자동으로 멈춰 있었다면 **Create table**을 누른 뒤 웨어하우스가 시작되고 쓰기가 끝날 때까지 약 1분 걸립니다. 화면이 바로 바뀌지 않아도 기다립니다.

## 5단계 - 결과 확인

1. Catalog Explorer에서 `<your_name>_wanderbricks_excel.landing.bookings_upload`를 엽니다. <!-- TODO(확인): 열 타입과 값을 보는 탭 이름 (**Sample data** 또는 **Preview**). -->
2. `total_amount` 열의 값이 `1,132.96`처럼 쉼표가 붙은 문자열인지 확인합니다. 1,000 이상인 금액에 쉼표가 붙어 있습니다.

    ![테이블에서 total_amount가 문자열로 저장된 화면](../assets/images/01-excel-upload/1-2-05-total-amount-string.png)

!!! warning "이것이 이 실습의 핵심 문제입니다"
    엑셀 서식의 쉼표는 테이블에 **글자**로 남습니다. 숫자로 계산하려면 Step 2의 Silver에서 쉼표를 지우고 숫자로 바꿉니다.

## 확인할 결과

- 업로드 테이블 `landing.bookings_upload`가 보입니다.
- 마지막으로 쓴 것은 6월 파일입니다 (헤더 제외 9,694행).
- `check_in`, `check_out`, `total_amount` 열이 문자열입니다.
- `total_amount` 열의 값에 쉼표가 남아 있습니다.

!!! success "축하합니다!"
    6월 예약을 엑셀에서 Databricks 테이블로 올렸습니다. 다음 Step에서 이 테이블을 자동으로 정제하는 파이프라인을 만듭니다. 7월 파일은 Step 2.4에서 올립니다.
