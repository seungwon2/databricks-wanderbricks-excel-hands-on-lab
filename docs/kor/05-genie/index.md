# 5) Genie로 묻기

## 실습 개요 📋

Ana는 Metric View를 Genie Agent에 연결하고 지침에 "매출" 정의를 넣습니다. Mina는 회의 전에 Genie One에서 직접 질문하고, Leo는 엑셀 안의 Genie에서 같은 질문을 합니다. 세 사람이 같은 숫자를 봅니다.

## 이번 Step의 역할

<div class="grid" markdown>

<div class="card persona" markdown>

![Ana](../assets/images/personas/ana.svg){ width="96" }

<div markdown>

**📊 Ana - Data Analyst**

Genie Agent를 만들고, 매출 정의와 질문 예시를 지침에 넣습니다. 이 Agent가 Mina와 Leo가 쓰는 Genie의 기준이 됩니다.

</div>

</div>

<div class="card persona" markdown>

![Mina](../assets/images/personas/mina.svg){ width="96" }

<div markdown>

**📣 Mina - Marketing Executive**

회의 전에 Genie One에서 "7월 국가별 매출"을 묻습니다. 엑셀 안의 Genie에서도 같은 질문을 해 봅니다.

</div>

</div>

</div>

## 실습 구조

| 페이지 | 내용 |
|---|---|
| [5.1) Genie Agent 만들기](5-1-genie-agent.md) | Metric View와 Gold 테이블로 Agent를 만들고 지침을 씁니다 |
| [5.2) Genie One과 엑셀 안의 Genie](5-2-genie-one-excel.md) | 두 곳에서 같은 질문을 하고 답을 엑셀로 가져옵니다 |

## 이번 Step에서 사용하는 기능

| 기능 | 설명 |
|---|---|
| Genie Agent | 데이터와 지침을 묶어 질문에 답하는 Agent입니다 |
| Genie One | 워크스페이스에서 자연어로 질문하는 채팅입니다 |
| Genie in Excel | 엑셀 Add-in의 Genie 아이콘에서 같은 질문을 합니다 |

## 학습 목표 🎯

- Genie Agent에 지침으로 지표 정의를 넣을 수 있습니다.
- 같은 질문에 여러 곳에서 같은 숫자가 나오는지 확인합니다.

!!! info "답변은 매번 조금씩 다를 수 있습니다"
    자연어 질문은 같은 질문이라도 표현이나 SQL이 달라질 수 있습니다. 숫자가 같은지 확인하고, 문장이 다른 것은 괜찮습니다.

## 예상 소요 시간 ⏱️

약 30분 (답변 생성 시간 포함)
