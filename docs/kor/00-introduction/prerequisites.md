# 사전 준비

이 페이지에서는 실습 전에 끝내야 할 설정과 권한을 확인합니다. 엑셀 Add-in 설치는 워크숍 전에 끝내 두는 것을 권장합니다.

## 1단계 - 엑셀 Add-in 설치와 로그인 확인

Databricks Add-in for Excel을 설치합니다. Microsoft 365 관리자가 조직에 배포했다면 설치 작업이 필요 없습니다.

1. Excel을 열고 **Home** 탭 오른쪽 끝에 **Azure Databricks** 버튼이 있는지 확인합니다. 버튼 옆에는 **Add-ins**가 있습니다. <!-- TODO(확인): 배포되지 않은 경우 직접 설치하는 메뉴 경로 (리허설에서는 배포된 상태였습니다). -->
2. **Azure Databricks** 버튼을 누르면 오른쪽에 Add-in 창이 열립니다. 처음에는 **Sign in** 버튼이 보입니다.
3. **Sign in**을 눌러 로그인합니다. 자세한 방법은 [1.1) 엑셀 Add-in 연결하기](../01-excel-upload/1-1-connect.md)에서 봅니다.

!!! warning "설치가 안 되면 워크숍 전에 관리자에게 요청하세요"
    Microsoft 365 관리자가 Add-in을 배포하거나 워크스페이스 URL을 허용 목록에 넣어야 로그인할 수 있습니다. 실습 당일에는 이 작업을 하지 않습니다.

!!! info "Excel 버전"
    Microsoft 365 Excel (Windows, Mac)을 쓰고, Mac은 2019 이상이어야 합니다. Excel 웹에서도 Add-in을 쓸 수 있지만 이 실습은 데스크톱 앱 기준입니다. <!-- TODO(확인): 웹 Excel에서 Write back이 같은 메뉴로 보이는지 리허설로 확인. -->
## 2단계 - 워크스페이스 설정 확인

워크스페이스 관리자가 **Allow spreadsheet writeback**을 켜 두어야 엑셀에서 테이블에 쓸 수 있습니다.

1. Databricks 워크스페이스에서 오른쪽 위 사용자 메뉴를 열고 **Settings**를 엽니다.
2. **Security** 탭을 열고 아래로 스크롤해 **External access** 영역을 찾습니다. **Allow spreadsheet writeback**은 이 영역의 맨 아래에 있습니다 (**Embed dashboards**, **Allowed collaboration platforms** 아래). 켜져 있는지 확인합니다.

!!! tip "관리자가 아니라면"
    이 설정은 관리자만 바꿀 수 있습니다. 꺼져 있으면 관리자에게 켜 달라고 요청하세요.

## 3단계 - SQL warehouse 사용 권한

실습의 모든 SQL은 **SQL warehouse**에서 실행합니다.

1. 왼쪽 사이드바에서 **SQL** → **SQL Warehouses**를 엽니다.
2. 실습에 쓸 warehouse의 **Permissions**에서 본인에게 **Can use** 권한이 있는지 확인합니다.

!!! info "서버리스 warehouse"
    서버리스 SQL warehouse를 권장합니다. 10분 이상 쓰지 않으면 자동으로 멈추고, 쿼리를 실행하면 다시 시작됩니다. 첫 쿼리가 조금 늦을 수 있습니다.

## 4단계 - 카탈로그, 스키마, Job 권한

실습에서 만드는 자산은 모두 본인 이름이 붙은 것입니다.

| 필요한 권한 | 쓰는 곳 | 없으면 |
|---|---|---|
| 카탈로그 생성 | 1.2) 카탈로그 만들기 | 관리자에게 공용 카탈로그를 받고, 그 안의 `<your_name>_wanderbricks_excel` 스키마를 씁니다 |
| 테이블 생성과 쓰기 (`CREATE TABLE`, `MODIFY`) | Step 1, 2 | 관리자에게 요청 |
| Job 생성과 서버리스 Job 실행 | Step 2 | 관리자에게 요청 |
| 서버리스 파이프라인 생성 | Step 2 | 관리자에게 요청 |
| Genie One 접근 | Step 5.2 | 5.2의 Genie One 부분은 건너뛰고 엑셀 안의 Genie만 해 봅니다 |

!!! warning "이름 규칙"
    이름 자리에 들어가는 `<your_name>`은 영문 소문자, 숫자, 밑줄만 씁니다. 예를 들어 이름이 Jiyu라면 `jiyu_wanderbricks_excel`처럼 씁니다. 공유 워크스페이스에서는 이름이 붙은 **본인의 자산만** 만들고 지웁니다.

## 5단계 - 실습 파일 내려받기

실습 엑셀 파일과 SQL 파일은 GitHub 저장소에 있습니다.

- 엑셀 파일 (6월은 Step 1, 7월은 Step 2.4에서 사용): [wanderbricks_bookings_2025-06.xlsx](https://github.com/seungwon2/databricks-wanderbricks-excel-hands-on-lab/raw/main/lab-files/kor/step1/wanderbricks_bookings_2025-06.xlsx), [wanderbricks_bookings_2025-07.xlsx](https://github.com/seungwon2/databricks-wanderbricks-excel-hands-on-lab/raw/main/lab-files/kor/step1/wanderbricks_bookings_2025-07.xlsx)

!!! info "엑셀 파일을 열 때"
    파일을 열어 **bookings** 시트가 보이는지 확인합니다. 6월 파일의 `total_amount` 열은 쉼표가 붙은 서식으로 되어 있습니다. 일부러 넣은 것이니 그대로 두세요.

## 확인 체크리스트

- [ ] 엑셀에서 Databricks Add-in을 열고 워크스페이스에 로그인했습니다
- [ ] SQL warehouse를 선택할 수 있고 Can use 권한이 있습니다
- [ ] 카탈로그 생성 권한이 있거나, 관리자에게 받은 공용 스키마가 있습니다
- [ ] 실습 엑셀 파일 두 개(6월, 7월)를 내려받았습니다
