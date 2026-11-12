# 스크린샷 촬영 목록 (rev 2)

캡처 원본은 `raw-screenshots/<파일명>.png`로 저장합니다 (git에 올라가지 않음). 저장 후 `docs/assets/images/<섹션>/<파일명>.png`에 빨간 박스를 그려 넣습니다. 캡처 전에 카탈로그 트리에서 실습 카탈로그만 펼치고, 우측 상단 사용자 정보와 주소창의 워크스페이스 URL은 가립니다.

| 파일명 | 페이지 | 캡처할 화면 | 빨간 박스로 표시할 곳 | 상태 |
|---|---|---|---|---|
| 1-1-01-open-workbook.png | kor/01-excel-upload/1-1-connect.md | 실습 파일 열기 화면 (6월 파일) | 하단 시트 탭 **bookings** | ✅ |
| 1-1-02-open-addin.png | kor/01-excel-upload/1-1-connect.md | Insert 메뉴에서 Databricks Add-in을 연 화면 | Add-in 창의 **Sign in** 버튼 | ✅ |
| 1-1-03-signed-in.png | kor/01-excel-upload/1-1-connect.md | 워크스페이스 로그인 완료 화면 | Add-in 상단의 워크스페이스 이름 (주소는 가림) | ✅ |
| 1-1-04-select-warehouse.png | kor/01-excel-upload/1-1-connect.md | Add-in 설정에서 SQL warehouse 선택 | **SQL warehouse** 드롭다운 (다른 팀 warehouse 가림) | ✅ |
| 1-2-01-create-catalog.png | kor/01-excel-upload/1-2-write-back.md | Catalog Explorer의 본인 카탈로그 생성 (**Create catalog**) | **Create catalog** 버튼, 본인 이름 카탈로그 (다른 카탈로그 가림) | ✅ |
| 1-2-02-write-back-tab.png | kor/01-excel-upload/1-2-write-back.md | Add-in의 Write back 탭 | **Write back** 탭 | ✅ |
| 1-2-03-use-selection.png | kor/01-excel-upload/1-2-write-back.md | 엑셀 범위 A1:J9695 선택 후 **Use selection** | **Use selection** 버튼과 범위 입력란 | ✅ |
| 1-2-04-create-table-preview.png | kor/01-excel-upload/1-2-write-back.md | Create table 미리보기 (열 10개와 대상 테이블 이름) | **Create table**, 대상 테이블 이름, 열 목록 | ✅ |
| 1-2-05-total-amount-string.png | kor/01-excel-upload/1-2-write-back.md | Catalog Explorer에서 bookings_upload의 total_amount 값 (쉼표 문자열) | total_amount 열의 값 (예: 1,234.50)과 타입 표시 | ✅ |
| 2-1-01-select-warehouse.png | kor/02-auto-pipeline/2-1-bronze.md | SQL 편집기에서 실습 warehouse 선택 | 오른쪽 위 warehouse 선택 드롭다운 | ✅ |
| 2-1-02-bronze-history.png | kor/02-auto-pipeline/2-1-bronze.md | bronze.bookings_upload_history 결과 (버전 1, 업로더, 시각, 행 수) | _upload_version, _uploaded_by, rows_loaded 열 (이메일 가림) | ✅ |
| 2-2-01-pipeline-graph.png | kor/02-auto-pipeline/2-2-silver-gold.md | 파이프라인 실행 그래프 (두 갈래로 나뉨, Completed) | 갈라지는 노드 2개와 Completed 상태 | ✅ |
| 2-2-02-rejects-by-reason.png | kor/02-auto-pipeline/2-2-silver-gold.md | 제외 행 사유별 집계 결과 (6월 13건) | reject_reason과 rejected 열 | ✅ |
| 2-3-01-job-tasks.png | kor/02-auto-pipeline/2-3-job-trigger.md | Job 태스크 세 개 (load_bronze, build_silver_gold, write_status) | 세 태스크와 의존 화살표 | ✅ |
| 2-3-02-add-trigger.png | kor/02-auto-pipeline/2-3-job-trigger.md | Add trigger 설정 (Table update, 업로드 테이블 선택) | **Trigger type** Table update, **Table** 입력, **Save** 버튼 | ✅ |
| 2-3-03-run-now.png | kor/02-auto-pipeline/2-3-job-trigger.md | Run now 실행 기록 (세 태스크 Succeeded, 6월 처리) | **Run now** 실행 상태와 세 태스크 아이콘 | ✅ |
| 2-4-01-overwrite-july.png | kor/02-auto-pipeline/2-4-auto-refresh.md | 7월 파일 Overwrite table 실행 화면 (A1:J10360) | **Overwrite table** 버튼과 범위 | ✅ |
| 2-4-02-job-run.png | kor/02-auto-pipeline/2-4-auto-refresh.md | Job Runs 탭의 자동 실행 기록 (트리거로 시작, 세 태스크 Succeeded) | Runs 목록의 최신 실행 상태, 트리거 실행 표시 | ✅ |
| 3-1-01-import-gold.png | kor/03-excel-results/3-1-import-refresh.md | Add-in Import로 gold_booking_monthly_country 가져오기 | 카탈로그 트리의 gold 스키마와 테이블 이름, **Save and Import** 버튼 | ✅ |
| 3-1-02-refresh-all.png | kor/03-excel-results/3-1-import-refresh.md | Refresh All 뒤 시트 (2025-06, 2025-07 행 포함) | **Refresh All** 버튼과 booking_month 열 | ✅ |
| 3-2-01-rejects-sheet.png | kor/03-excel-results/3-2-optional-fix-rejects.md | silver_booking_rejects 가져온 시트 (reject_reason 열) | reject_reason 열 헤더와 정렬 | ✅ |
| 4-1-01-create-metric-view.png | kor/04-metric-view-dashboard/4-1-mv-bookings.md | Metric View 생성 화면 (YAML 편집기) | **Save** 버튼, 이름 mv_bookings, YAML 시작 부분 | ✅ |
| 4-1-02-query-measures.png | kor/04-metric-view-dashboard/4-1-mv-bookings.md | MEASURE 조회 결과 (매출, 총 예약 금액, 취소율) | revenue 열과 gross_booking_value 열 | ✅ |
| 4-2-01-add-dataset.png | kor/04-metric-view-dashboard/4-2-dashboard.md | 대시보드 데이터셋에 Metric View 쿼리 추가 | 데이터셋 쿼리 입력란과 **Data** 탭 | ✅ |
| 4-2-02-revenue-chart.png | kor/04-metric-view-dashboard/4-2-dashboard.md | 월별 매출 막대 차트 위젯 | 차트 X축 예약 월과 Y축 revenue | ✅ |
| 5-1-01-instructions.png | kor/05-genie/5-1-genie-agent.md | Genie Agent 지침 입력란 | Instructions 입력란 (매출 정의 문단) | ✅ |
| 5-1-02-answer-sql.png | kor/05-genie/5-1-genie-agent.md | Genie 답변과 생성된 SQL (MEASURE(매출) 포함) | SQL 블록의 MEASURE 문 또는 **Show code** 버튼 | ✅ |
| 5-2-01-genie-one-answer.png | kor/05-genie/5-2-genie-one-excel.md | Genie One 답변 화면 (7월 국가별 매출) | 답변 합계와 출처 표시 | ✅ |
| 5-2-02-genie-in-excel.png | kor/05-genie/5-2-genie-one-excel.md | 엑셀 Add-in의 Genie 창과 답변 | Genie 아이콘과 답변 표 | ✅ |

총 29장. 상태 ⬜ = 미촬영, ✅ = 촬영·박스 처리 완료.

2.3 순서 주의: 2-3-03-run-now는 트리거 생성 전 Run now 실행 화면, 2-4-01/02는 트리거 Active 확인 뒤 자동 실행 화면입니다.
| 3-1-03-update-limit.png | kor/03-excel-results/3-1-import-refresh.md | (문제 해결) 저장된 가져오기 편집 화면에서 Limit 끄고 Update | Limit 스위치, **Update** | ✅ |
| 5-2-03-genie-import.png | kor/05-genie/5-2-genie-one-excel.md | Genie 답 표를 Import한 시트 (Sheet3, july_revenue_country) | 가져온 표와 "imported to Sheet3" 문구 | ✅ |
