# 2.3) Job과 테이블 변경 트리거

이 페이지에서는 세 태스크를 하나의 **Job**으로 묶고, 먼저 한 번 실행해 6월 업로드를 처리한 뒤, 업로드 테이블 변경을 감지하는 **테이블 변경 트리거**를 만듭니다.

!!! warning "순서를 지켜 주세요"
    먼저 Job을 **Run now**로 한 번 실행하고, 그다음 트리거를 만듭니다. 트리거를 만든 직후의 첫 변경은 감지되지 않을 수 있으므로, 트리거는 7월 업로드 전에 만들어 두고 2.4에서 1~2분 기다린 뒤 덮어씁니다.

## 1단계 - 워크스페이스 파일 준비

Job의 SQL 태스크는 워크스페이스 파일을 실행합니다. 2.1에서 쓴 `load_bronze.sql`과 아래 `write_status.sql`을 준비합니다.

1. **Workspace**에서 2.2의 파이프라인 루트 폴더를 엽니다.
2. `load_bronze.sql`, `write_status.sql` 두 파일을 같은 폴더에 만듭니다. 내용은 그대로 붙여 넣고 `<your_name>`을 바꿉니다. 리허설에서는 두 파일을 **RAW** 형식으로 가져와서 SQL file 태스크가 실행됐습니다.

```sql title="write_status.sql"
--8<-- "lab-files/kor/step2/write_status.sql"
```

!!! info "`write_status.sql`이 하는 일"
    파이프라인이 끝난 뒤 실행 기록(`ops.refresh_log`)을 한 줄 남기고, 엑셀에서 볼 업로드 상태 뷰(`ops.upload_status`)를 다시 만듭니다.

## 2단계 - Job 만들기

1. **Jobs & Pipelines**에서 **Create** → **Job**을 선택합니다. <!-- TODO(확인): **Create** 메뉴에서 Job 항목의 정확한 이름. -->
2. Job 이름을 `[<your_name>] excel bronze to gold`로 입력합니다.

!!! tip "기본 이름을 지우고 입력합니다"
    Job을 만들면 기본 이름이 이미 입력되어 있습니다. 이름 칸을 전체 선택(**Cmd+A** 또는 **Ctrl+A**)한 뒤 새 이름을 입력합니다. 그냥 붙여 쓰면 기본 이름 뒤에 글자가 이어 붙습니다.

3. 캔버스에서 **Add a new task**를 눌러 세 태스크를 순서대로 추가합니다. 종류 목록에는 **SQL file**과 **ETL Pipeline**이 있습니다.

| 태스크 이름 | 종류 | 대상 | 앞 태스크 |
|---|---|---|---|
| `load_bronze` | SQL file | `load_bronze.sql` 워크스페이스 파일 | 없음 |
| `build_silver_gold` | ETL Pipeline | 2.2에서 만든 `<your_name>_excel_silver_gold` | `load_bronze` |
| `write_status` | SQL file | `write_status.sql` 워크스페이스 파일 | `build_silver_gold` |

![Job 태스크 세 개의 순서](../assets/images/02-auto-pipeline/2-3-01-job-tasks.png)

!!! tip "컴퓨트"
    SQL file 태스크는 실습 SQL warehouse를 씁니다. 파이프라인 태스크는 서버리스 컴퓨트를 씁니다. <!-- TODO(확인): SQL file 태스크에서 warehouse를 고르는 항목 이름. -->
!!! info "경고가 보여도 실행됩니다"
    Job 설정 화면에 "클래식 웨어하우스는 이 스케줄에 쓸 수 없다"는 경고가 보일 수 있습니다. 실습에서 쓰는 서버리스 warehouse는 그대로 실행됩니다.

## 3단계 - Job을 한 번 실행하기

트리거를 만들기 전에 지금 들어 있는 6월 업로드를 처리합니다.

1. **Run now**를 누릅니다.
2. 세 태스크가 모두 **Succeeded**가 될 때까지 기다립니다. 리허설에서는 약 2분 걸렸습니다 (`load_bronze` 28초, `build_silver_gold` 1분 12초, `write_status` 15초). 기다리는 동안 4단계의 트리거 설정 항목을 미리 읽어 둡니다.

    ![Run now 실행 기록과 세 태스크 성공](../assets/images/02-auto-pipeline/2-3-03-run-now.png)

3. SQL 편집기에서 아래 쿼리로 6월 업로드가 반영됐는지 확인합니다.

```sql
SELECT * FROM <your_name>_wanderbricks_excel.ops.upload_status ORDER BY upload_version;
```

!!! info "6월 업로드가 한 줄로 보여야 합니다"
    `upload_version` 0, 올린 사람, 시각, 행 수 9,694, 제외 행 13이 보이면 정상입니다. 이 한 줄이 **최신 업로드**로 표시됩니다. 같은 파일을 다시 처리해도 Bronze는 같은 버전을 두 번 넣지 않습니다.

## 4단계 - 테이블 변경 트리거 추가

1. Job 화면 오른쪽에서 **Schedules & Triggers**를 엽니다.
2. **Add trigger**를 누르고 **Trigger type**에서 **Table update**를 고릅니다.
3. **Tables**에서 **Add table**을 누르고 `<your_name>_wanderbricks_excel.landing.bookings_upload`를 고릅니다.
4. **Test trigger**를 누릅니다. 결과에 **Success**가 보이면 테이블 연결이 된 것입니다.
5. **Trigger Status**가 **Active**인지 확인하고 **Save**를 누릅니다.

    ![테이블 변경 트리거 설정 화면](../assets/images/02-auto-pipeline/2-3-02-add-trigger.png)

!!! warning "저장 직후에는 아무것도 올리지 않습니다"
    트리거를 저장한 직후 첫 변경은 감지되지 않을 수 있습니다. 다음 페이지에서 1~2분 기다린 뒤에 7월 파일을 올립니다.

!!! tip "트리거 대상은 한 테이블입니다"
    이 Job은 `landing.bookings_upload` 하나를 감시합니다. 다른 사람의 업로드 테이블까지 감시하면 실행이 섞입니다.

## 5단계 - 트리거 상태 확인

1. 트리거 목록에서 **Trigger Status**가 **Active**인지 확인합니다. <!-- TODO(확인): 활성화까지 걸리는 시간. -->
2. 이 단계에서는 **Run now**를 다시 누르지 않습니다. 실행은 다음 페이지의 업로드로 시작합니다.

## 확인할 결과

- Job에 태스크 세 개가 순서대로 보입니다.
- **Run now**로 6월 업로드를 처리했습니다 (`ops.upload_status`에 6월 버전).
- 트리거가 `landing.bookings_upload`에 연결되어 **Active**입니다.

!!! success "축하합니다!"
    Job과 트리거를 만들었습니다. 다음 페이지에서 트리거가 활성화된 것을 확인한 뒤 7월 엑셀을 올려 자동 실행을 봅니다.
