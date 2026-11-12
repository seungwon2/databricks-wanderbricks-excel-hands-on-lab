# 5.1) Genie Agent 만들기

이 페이지에서는 Metric View와 Gold 테이블을 데이터로 가진 Genie Agent를 만들고, 지침에 "매출" 정의를 넣습니다.

## 1단계 - Agent 만들기

1. 왼쪽 사이드바에서 **Genie Agents**를 엽니다.
2. **New**를 누릅니다. **What should your Genie agent do?** 입력란이 나오면 Agent가 할 일을 짧게 씁니다.
3. **Select tables manually**를 누르고 **Connect your data**에서 **Create manually**를 누릅니다.
4. 아래 표의 데이터 세 개를 추가합니다. (2단계)
5. Agent가 만들어지면 자동 이름이 붙습니다. 오른쪽 **About** 패널에서 **Edit About this agent**를 누르고 이름을 `<your_name> Wanderbricks 엑셀 Genie`로 바꾼 뒤 저장합니다.
6. 같은 패널에서 **Edit description**을 누르고 설명을 `엑셀로 올린 예약 2개월 (2025-06, 2025-07)`로 씁니다. 자동 제안 설명은 그대로 두지 않습니다.

## 2단계 - 데이터 추가

다음 세 개를 데이터로 추가합니다.

| 종류 | 이름 |
|---|---|
| Metric View | `<your_name>_wanderbricks_excel.gold.mv_bookings` |
| 테이블 | `<your_name>_wanderbricks_excel.gold.gold_booking_monthly_country` |
| 테이블 | `<your_name>_wanderbricks_excel.gold.gold_customer_360` |

!!! tip "Metric View를 먼저 추가합니다"
    질문을 매출과 연결하려면 Metric View가 가장 먼저 있어야 합니다. 테이블은 고객 세그먼트 질문에 씁니다.

## 3단계 - 지침 넣기

패널의 **Instructions** 탭을 열고 **General Instructions** 입력란에 아래 내용을 붙여 넣은 뒤 **Save**를 누릅니다.

```text title="지침"
"매출"은 항상 mv_bookings의 측정값 "매출"을 씁니다. 이 값은 status가 completed인 예약의 total_amount 합계입니다.
"총 예약 금액"은 취소 포함 모든 상태의 합계이며, 매출과 다른 값입니다. 사용자가 "매출"이라고 하면 총 예약 금액을 쓰지 않습니다.
"취소율"은 mv_bookings의 취소율을 씁니다.
국가는 대문자 전체 이름을 씁니다 (예: UNITED STATES, SOUTH KOREA).
월은 예약 월 차원으로 자릅니다. 엑셀로 올린 데이터 기간은 2025-06부터 2025-07까지입니다.
```

!!! info "지침이 중요한 이유"
    지침이 없으면 Genie는 "매출"을 `total_amount` 합계로 해석할 수 있습니다. 그러면 취소 예약이 포함되어 엑셀의 실수와 같은 숫자가 나옵니다.

![Genie Agent 지침 입력 화면 (Instructions 탭)](../assets/images/05-genie/5-1-01-instructions.png)

## 4단계 - 샘플 질문으로 확인

1. 채팅 영역에서 **New chat**을 눌러 새 대화를 엽니다.
2. 다음 질문을 입력합니다.

```text title="질문"
7월 국가별 매출을 알려 주세요.
```

3. 답변 아래의 **Thought process**를 펼치고 **Show generated code**를 누릅니다. 생성된 SQL에 `MEASURE(매출)`이 쓰였는지 확인합니다.

![질문 답변과 생성된 SQL 확인 (MEASURE(매출))](../assets/images/05-genie/5-1-02-answer-sql.png)

리허설에서 답의 합계는 **514,860.30**이었습니다. 같은 질문을 새 대화에서 다시 해도 514,860.30이었습니다.

!!! tip "답변 문장의 행 수는 틀릴 수 있습니다"
    답변 문장에 적힌 행 수(예: "상위 N행")가 실제 SQL 결과와 다를 수 있습니다. 행 수와 국가 목록은 생성된 SQL과 결과 표로 확인합니다.

!!! warning "답에 `total_amount` 합계가 보이면"
    지침을 다시 확인합니다. 취소 예약이 포함되면 7월 합계가 약 570만이 됩니다. 이 숫자가 나오면 Metric View 측정값이 아니라 원본 합계를 쓴 것입니다.

## 확인할 결과

- Genie Agent가 만들어져 있고, 데이터 세 개가 연결되어 있습니다.
- 7월 국가별 매출 답의 합계가 514,860.30입니다.
- 답에 `MEASURE(매출)`이 쓰였습니다.

!!! success "축하합니다!"
    Genie가 같은 정의로 답하게 만들었습니다. 다음 페이지에서 Genie One과 엑셀 안의 Genie에서 같은 질문을 합니다.
