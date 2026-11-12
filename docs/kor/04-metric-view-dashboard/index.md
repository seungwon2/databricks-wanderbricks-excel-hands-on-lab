# 4) Metric View와 대시보드

## 실습 개요 📋

Ana는 "매출"의 정의가 사람마다 달라 회의가 길어진다고 말합니다. 이 Step에서는 "매출"을 **Metric View**에 한 번만 정의하고, 그 정의로 대시보드를 만듭니다. 엑셀과 Genie도 같은 정의를 씁니다.

## 이번 Step의 역할

<div class="grid" markdown>

<div class="card persona" markdown>

![Ana](../assets/images/personas/ana.svg){ width="96" }

<div markdown>

**📊 Ana - Data Analyst**

여러분은 데이터 분석가 Ana입니다. 예약 Metric View에 "매출은 completed 예약의 금액 합계"라는 정의를 넣고, 그 정의로 대시보드를 만듭니다.

</div>

</div>

</div>

## 실습 구조

| 페이지 | 내용 |
|---|---|
| [4.1) Metric View: 예약](4-1-mv-bookings.md) | `mv_bookings`를 만들고 "매출"을 정의합니다 |
| [4.2) Metric View로 대시보드 만들기](4-2-dashboard.md) | Metric View를 데이터셋으로 쓰는 대시보드를 만듭니다 |

## 이번 Step에서 사용하는 기능

| 기능 | 설명 |
|---|---|
| Unity Catalog Metric View | 측정값(매출, 예약 건수, 취소율)과 차원(월, 국가)을 한 곳에 정의합니다 |
| AI/BI 대시보드 | Metric View를 데이터셋으로 차트를 만듭니다 |

## 학습 목표 🎯

- "매출"과 "총 예약 금액"의 차이를 정의로 분명히 합니다.
- Metric View의 `MEASURE()`로 같은 정의를 여러 곳에서 씁니다.

## 예상 소요 시간 ⏱️

약 35분 (4.2 포함, 생략하면 약 20분)
