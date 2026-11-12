# 소개

## 실습 개요 📋

지역 운영 매니저는 예약 데이터를 엑셀로 정리해 메일로 보내고, 데이터팀은 그 파일을 받아 손으로 합칩니다. 이 실습에서는 엑셀에서 바로 Databricks 테이블로 올리고, 올라오는 순간 자동으로 정제되어 대시보드와 Genie에 반영되는 흐름을 직접 만듭니다.

## 이번 실습에서의 역할

<div class="grid" markdown>

<div class="card persona" markdown>

![Leo](../assets/images/personas/leo.svg){ width="96" }

<div markdown>

**📗 Leo - 지역 운영 매니저**

여러분은 지역 운영 매니저 Leo입니다. 평소처럼 엑셀로 예약 데이터를 정리하고, 그 엑셀을 Databricks 테이블에 올립니다. 올린 숫자는 데이터팀과 같은 숫자로 다시 받아 봅니다.

</div>

</div>

</div>

## 실습 구조

| 페이지 | 내용 |
|---|---|
| [시나리오와 페르소나](scenario.md) | 가상 회사, 문제 장면, 등장인물 |
| [사전 준비](prerequisites.md) | 엑셀 Add-in, 워크스페이스 설정, 권한 확인 |

## 이번 실습에서 사용하는 기능

| 기능 | 설명 |
|---|---|
| Databricks Add-in for Excel | 엑셀 범위를 Unity Catalog 테이블에 쓰고, 테이블을 엑셀로 가져옵니다 |
| Lakeflow Spark Declarative Pipelines | 정제와 검증을 선언형 SQL로 만듭니다 |
| Lakeflow Jobs (테이블 변경 트리거) | 업로드 테이블이 바뀌면 자동으로 실행합니다 |
| Unity Catalog Metric View | "매출" 같은 지표 정의를 한 곳에 둡니다 |
| AI/BI 대시보드, Genie | 같은 지표로 차트와 질문 답변을 만듭니다 |

## 학습 목표 🎯

- 엑셀 범위를 Unity Catalog 테이블에 쓰고, Gold 테이블을 엑셀로 가져올 수 있습니다.
- 테이블 변경 트리거로 업로드가 들어오면 Job이 자동으로 정제하도록 만들 수 있습니다.
- 엑셀에서 생기는 지저분한 값(서식이 붙은 숫자, 공백, 중복, 잘못된 상태·날짜)을 Silver에서 걸러 내고, 제외 행을 사유와 함께 돌려줄 수 있습니다.
- Metric View로 "매출" 정의를 고정하고, 대시보드·Genie·엑셀이 같은 숫자를 쓰게 할 수 있습니다.

## 예상 소요 시간 ⏱️

약 3시간 30분 (휴식 10분 두 번 포함, 강사 설명 시간 포함)
