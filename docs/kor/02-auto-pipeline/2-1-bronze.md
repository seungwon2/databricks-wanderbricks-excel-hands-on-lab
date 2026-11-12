# 2.1) Bronze: 시스템 데이터와 엑셀 업로드 이력

이 페이지에서는 나머지 스키마 4개를 만들고, 업로드 테이블의 최신 버전을 **Bronze 이력 테이블**에 문자열로 적재하는 SQL을 실행합니다. 업로드한 사람, 시각, 버전도 함께 기록합니다.

## 1단계 - SQL 편집기 열고 warehouse 연결하기

1. 왼쪽 사이드바에서 **SQL** → **SQL Editor**를 엽니다. 새 쿼리 탭을 엽니다.
2. 상단의 **Connect** 버튼을 누르고 드롭다운에서 **More…** 메뉴를 고릅니다.
3. **Attach to an existing compute resource** 대화상자에서 **Select a cluster**를 열고 실습 SQL warehouse를 고른 뒤 **Start and attach**를 누릅니다.

    ![SQL 편집기에서 warehouse 선택](../assets/images/02-auto-pipeline/2-1-01-select-warehouse.png)

!!! info "웨어하우스는 몇 초 만에 시작됩니다"
    웨어하우스가 멈춰 있어도 **Start and attach** 뒤 몇 초면 쿼리를 실행할 수 있습니다. 리허설에서는 약 5초였습니다.

## 2단계 - 스키마 4개 만들기

업로드 테이블 `landing`은 1.2에서 만들었습니다. 나머지 `bronze`, `silver`, `gold`, `ops`는 아래 SQL로 한 번에 만듭니다.

```sql title="create_schemas.sql"
--8<-- "lab-files/kor/step2/create_schemas.sql"
```

!!! tip "`<your_name>`을 본인 이름으로 바꿉니다"
    이름이 Jiyu라면 `<your_name>`을 `jiyu`로 바꿔 `jiyu_wanderbricks_excel`이 되게 합니다. 전체를 찾아 바꾸기 (**Ctrl+H** 또는 **Cmd+H**)를 쓰면 편합니다.

### 코드 이해하기

| 구문 | 설명 |
|---|---|
| `CREATE SCHEMA IF NOT EXISTS` | 스키마가 없을 때만 만듭니다. 이미 있으면 오류 없이 넘어갑니다. |
| `<카탈로그>.<스키마>` | 카탈로그 아래에 스키마를 만듭니다. 이 실습에서 카탈로그 이름은 `<your_name>_wanderbricks_excel`입니다. |

쿼리를 **Run all**로 실행합니다. 오류 없이 끝나면 스키마 네 개가 생긴 것입니다.

## 3단계 - 적재 SQL 붙여 넣기

아래 SQL은 업로드 테이블의 **최신 버전**을 읽습니다. 이미 적재한 버전이면 아무것도 하지 않습니다. 열은 이름으로 골라서 `STRING`으로 바꿉니다.

```sql title="load_bronze.sql"
--8<-- "lab-files/kor/step2/load_bronze.sql"
```

!!! tip "`<your_name>`을 본인 이름으로 바꿉니다"
    앞 단계와 같은 방법으로 `<your_name>`을 바꿉니다.

### 코드 이해하기

| 구문 | 설명 |
|---|---|
| `DESCRIBE HISTORY` | 업로드 테이블의 버전, 올린 사람(`userName`), 시각을 읽습니다. 엑셀 Write back이 남긴 기록입니다. |
| `max(version)` | 가장 최근 버전 번호를 `up_version`에 담고, 그 버전을 `_upload_version`으로 기록합니다. |
| `CAST(... AS STRING)` | 엑셀이 정한 타입과 관계없이 모든 열을 문자열로 받습니다. 덮어쓸 때마다 타입이 바뀌어도 깨지지 않습니다. |
| `IF NOT EXISTS` | 같은 버전을 두 번 넣지 않습니다. Job을 다시 실행해도 안전합니다. |

!!! info "`VERSION AS OF`를 쓰지 않습니다"
    버전을 고정해서 읽는 `VERSION AS OF`에는 변수를 쓸 수 없어서, 이 SQL은 현재 버전을 읽습니다. 지금 버전이 `up_version`과 같습니다.

## 4단계 - 실행하고 결과 확인

1. **Run all**을 누릅니다. 행을 돌려주지 않는 쿼리이므로 **Query finished**가 보이면 성공입니다. 리허설에서는 약 10초였습니다.
2. 아래 쿼리로 행 수를 확인합니다. 지금은 **버전 0** 하나만 보입니다. 1.2에서 올린 6월 첫 업로드이고 9,694행입니다.

```sql
SELECT _upload_version, _uploaded_by, _uploaded_at, count(*) AS rows_loaded
FROM <your_name>_wanderbricks_excel.bronze.bookings_upload_history
GROUP BY _upload_version, _uploaded_by, _uploaded_at
ORDER BY _upload_version;
```

    ![Bronze 이력 테이블에서 업로드 버전과 올린 사람 확인](../assets/images/02-auto-pipeline/2-1-02-bronze-history.png)

    !!! info "버전 번호는 0부터 시작합니다"
        테이블의 첫 쓰기가 버전 0입니다. 그래서 첫 업로드는 `_upload_version` 0으로 기록됩니다. 이 실습에서는 6월 업로드가 버전 0이고, 7월 업로드가 이어서 새 버전으로 쌓입니다.

!!! warning "업로드를 두 번 하면 버전도 두 번 생깁니다"
    Bronze 이력은 버전별로 쌓입니다. 같은 파일을 여러 번 올리면 같은 행이 여러 버전으로 남습니다. Silver는 예약 월마다 최신 버전만 쓰므로 결과는 같습니다.

## 확인할 결과

- `bronze`, `silver`, `gold`, `ops` 스키마가 만들어졌습니다.
- `bronze.bookings_upload_history`가 만들어졌습니다.
- 버전 0에 행 9,694개가 있고, 업로드한 사람과 시각이 보입니다. 2.4에서 7월을 덮어쓰면 새 버전이 추가됩니다.
- `total_amount` 열은 문자열이고, `1,132.96`처럼 쉼표가 그대로 남아 있습니다.

!!! success "축하합니다!"
    업로드 원본을 문자열 그대로 이력으로 남겼습니다. 다음 페이지에서 이 이력을 정제합니다.
