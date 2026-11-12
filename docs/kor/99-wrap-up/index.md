# 마무리

## 주요 성과 🎯

이번 실습에서 여러분은 다음을 만들었습니다.

- 엑셀 범위를 Unity Catalog 업로드 테이블로 쓰는 흐름
- 업로드 이력(Bronze)과 정제·제외 행(Silver), 고객 360과 월별 국가 요약(Gold)
- 업로드가 바뀌면 자동으로 실행되는 Job과 테이블 변경 트리거
- "매출"을 한 번만 정의한 Metric View와 대시보드
- 같은 정의로 답하는 Genie Agent와 엑셀 안의 Genie

## 학습 하이라이트 📚

- 엑셀 서식이 붙은 숫자는 테이블에 **문자열**로 저장됩니다. 그래서 Bronze는 전부 문자열로 받고, Silver에서 숫자로 바꿉니다.
- 덮어쓰기는 테이블을 다시 만듭니다. 이력은 버전으로 남기고, Silver는 예약 월마다 최신 버전을 씁니다.
- 고칠 수 없는 행은 버리지 말고 사유와 함께 따로 보관해야 현업이 고쳐 다시 올릴 수 있습니다.
- "매출"의 정의는 Metric View 한 곳에 두어야 대시보드, Genie, 엑셀이 같은 숫자를 씁니다.

## 다음 단계 🚀

| 주제 | 문서 |
|---|---|
| Lakeflow 파이프라인과 Expectations | [Lakeflow Spark Declarative Pipelines](https://learn.microsoft.com/azure/databricks/dlt/) |
| Job 테이블 변경 트리거 | [Table update trigger](https://learn.microsoft.com/azure/databricks/jobs/trigger-table-update) |
| Metric View | [Unity Catalog metric views](https://learn.microsoft.com/azure/databricks/metric-views/) |
| Excel Add-in | [Databricks Add-in for Excel](https://learn.microsoft.com/azure/databricks/integrations/excel/) |
| Genie | [Genie](https://learn.microsoft.com/azure/databricks/genie/) |

<!-- TODO(확인): 위 문서 링크가 Azure 경로에서 열리는지 확인. -->
## 리소스 정리하기

!!! warning "본인의 자산만 삭제하세요"
    공유 워크스페이스에서는 이름에 `<your_name>`이 붙은 **본인의 자산만** 삭제합니다. 삭제는 되돌릴 수 없습니다.

아래 순서로 지웁니다. 다른 자산이 참조하는 자산을 먼저 지우도록 순서를 정했습니다. 트리거가 남아 있으면 Job이 계속 실행되므로 Job보다 먼저 트리거를 지웁니다.

1. **Genie Agent 삭제:** **Genie Agents**에서 `<your_name> Wanderbricks 엑셀 Genie`를 열고 actions 메뉴에서 **Move to trash**를 누릅니다.
2. **대시보드 삭제:** `<your_name> Wanderbricks 엑셀 매출` 대시보드에서 **More actions** → **File actions** → **Move to trash**를 누릅니다.
3. **Metric View 삭제:** SQL 편집기에서 아래 쿼리를 실행합니다. <!-- TODO(확인): Metric View를 `DROP VIEW`로 지우는 방법은 리허설에서 확인하지 않았습니다. -->
    ```sql
    DROP VIEW IF EXISTS <your_name>_wanderbricks_excel.gold.mv_bookings;
    ```

4. **트리거 삭제 (Job보다 먼저):** Job `[<your_name>] excel bronze to gold`를 열고 **Schedules & Triggers**에서 테이블 변경 트리거의 **Delete**를 누릅니다. 확인 창 없이 바로 삭제됩니다.
5. **Job 삭제:** 같은 Job 화면에서 **More actions** → **Delete job**을 누릅니다. 확인 대화상자가 뜨면 **Delete job**을 한 번 더 누릅니다.
6. **파이프라인 삭제:** **Jobs & Pipelines**에서 파이프라인 `<your_name>_excel_silver_gold`를 삭제합니다. <!-- TODO(확인): 파이프라인 삭제 메뉴 이름. -->
7. **워크스페이스 파일 삭제:** **Workspace**에서 2.2의 파이프라인 루트 폴더를 엽니다. `load_bronze.sql`, `write_status.sql`, `silver.sql`, `gold.sql`과 날짜가 붙은 중복 파일(`gold 2026-...sql`)을 지웁니다. `transformations` 폴더의 스타터 파일 `my_transformation.py`도 지웁니다. <!-- TODO(확인): 파일 삭제 메뉴 이름. -->
8. **카탈로그 삭제:** SQL 편집기에서 아래 쿼리를 실행합니다. 카탈로그 안의 스키마, 테이블, 뷰가 모두 함께 지워집니다.

    ```sql
    DROP CATALOG <your_name>_wanderbricks_excel CASCADE;
    ```

    !!! warning "카탈로그 이름을 꼭 확인합니다"
        `CASCADE`는 카탈로그 안의 테이블, 뷰, Volume을 모두 함께 삭제하며 되돌릴 수 없습니다. 실행 전에 본인의 카탈로그 이름인지 확인합니다. 공용 카탈로그의 스키마를 받아 썼다면 카탈로그 대신 그 스키마만 `DROP SCHEMA <카탈로그>.<your_name>_wanderbricks_excel CASCADE`로 지웁니다.

9. **SQL 편집기 정리:** 실습에 쓴 쿼리 탭을 닫거나, 저장해 둔 쿼리가 있다면 삭제합니다.
10. Excel 통합 문서는 로컬 파일이므로 직접 닫으면 됩니다.

!!! info "삭제 전에 확인"
    삭제하기 전에 Job 실행 기록과 대시보드를 한 번 더 보고 싶다면 지금 확인하세요. 삭제하면 기록도 함께 사라집니다.

## 피드백

[GitHub Issues](https://github.com/seungwon2/databricks-wanderbricks-excel-hands-on-lab/issues)에 의견을 남겨 주세요.

수고하셨습니다! 🎉
