# 1.1) 엑셀 Add-in 연결하기

이 페이지에서는 실습 엑셀 파일을 열고 Databricks Add-in에 로그인합니다.

## 1단계 - 실습 엑셀 파일 열기

1. 내려받은 `wanderbricks_bookings_2025-06.xlsx`를 Excel 데스크톱 앱에서 엽니다.
2. 아래 시트 탭에 **bookings**가 보이는지 확인합니다.

    ![엑셀에서 실습 파일 열기: bookings 시트](../assets/images/01-excel-upload/1-1-01-open-workbook.png)

!!! info "지금 여는 파일"
    이 Step에서는 6월 파일을 씁니다. 7월 파일은 Step 2.4에서 덮어쓰면서 자동 반영을 확인합니다. 6월 파일의 `total_amount` 열은 `#,##0.00` 서식이 적용되어 있습니다. 나중에 테이블에서 어떻게 보이는지 확인하는 데 쓰입니다.

## 2단계 - Add-in 열기

1. Excel 상단 **Home** 탭 오른쪽 끝의 **Azure Databricks** 버튼을 누릅니다. 버튼 옆에 **Add-ins**가 있습니다.
2. 오른쪽에 Databricks Add-in 창이 열립니다. 처음 열면 **Excel Connector** 카드와 **Sign in** 버튼이 보입니다. **Sign in**을 누릅니다.

    ![Databricks Add-in 창 열기](../assets/images/01-excel-upload/1-1-02-open-addin.png)

## 3단계 - 워크스페이스에 로그인

1. 로그인 화면의 **Recent workspaces** 드롭다운에 워크스페이스가 이미 선택되어 있는지 확인합니다. 목록에 없다면 **Connect to a different workspace**를 누르고 강사가 안내한 주소를 입력합니다.
2. **Sign in**을 누릅니다. 브라우저 창이 열리면 Databricks 계정으로 로그인하고 허용합니다.
3. Add-in 창으로 돌아오면 상단에 워크스페이스 연결 드롭다운이 보입니다. 로그인이 끝난 것입니다. Add-in 창 상단에는 **New import**, **Saved imports**, **Write back** 탭도 보입니다.

    ![워크스페이스 로그인 완료 화면](../assets/images/01-excel-upload/1-1-03-signed-in.png)

    !!! warning "로그인 창이 안 열릴 때"
        팝업 차단이 켜져 있으면 로그인 창이 열리지 않습니다. 팝업을 허용하고 다시 **Sign in**을 누르세요. <!-- TODO(확인): 로그인 실패 메시지 문구를 리허설에서 확인. -->
!!! info "엑셀 파일마다 로그인합니다"
    Add-in 로그인은 엑셀 파일(통합 문서)마다 따로 합니다. 다른 파일을 열었을 때 Add-in에 **Sign in** 버튼이 다시 보이면 같은 방법으로 로그인합니다.

## 4단계 - SQL warehouse 선택

1. Add-in 창 상단의 SQL warehouse 드롭다운을 엽니다. **Serverless warehouses** 목록에서 실습 warehouse를 고릅니다.
2. 목록에 warehouse가 없으면 [사전 준비](../00-introduction/prerequisites.md)의 3단계를 확인합니다.

    ![Add-in에서 SQL warehouse 선택](../assets/images/01-excel-upload/1-1-04-select-warehouse.png)

## 5단계 - 카탈로그 찾아보기

1. Add-in에서 **Catalog** 목록을 엽니다.
2. 본인 이름이 붙은 카탈로그 `<your_name>_wanderbricks_excel`은 아직 없습니다. 예를 들어 이름이 Jiyu라면 `jiyu_wanderbricks_excel`입니다. 다음 페이지에서 만듭니다.

!!! tip "다른 사람의 카탈로그는 열지 않습니다"
    공유 워크스페이스에는 다른 팀의 카탈로그가 많이 보입니다. 실습에서는 본인 카탈로그와 스키마만 씁니다.

!!! warning "목록이 비어 있을 때 (로그인 세션 만료)"
    로그인하고 1시간 30분쯤 지나면 **Catalog** 목록에 `No results found`만 보이고 오류 메시지는 보이지 않을 수 있습니다. 이때는 상단 SQL warehouse 목록을 열어 봅니다. `Error loading SQL warehouses`와 `Fetch request failed due expired user session`이 보이면 세션이 만료된 것입니다.

    Add-in 오른쪽 위 **⋮** 메뉴에서 로그아웃한 뒤 다시 로그인합니다. <!-- TODO(확인): **⋮** 메뉴의 로그아웃 항목 이름. -->
    웨어하우스가 자동으로 멈춘 뒤에도 목록이 비는 경우가 있었습니다. 이때는 창을 닫았다 다시 열어도 해결되지 않았습니다. <!-- TODO(확인): 이 경우에도 로그아웃 후 다시 로그인하면 해결되는지 확인. -->
## 확인할 결과

Add-in 창에 카탈로그 목록이 보이면 연결이 끝난 것입니다. 다음 페이지에서 **Write back** 탭을 엽니다.

!!! success "축하합니다!"
    엑셀에서 워크스페이스에 연결했습니다. 다음 페이지에서 예약 데이터를 업로드 테이블로 씁니다.
