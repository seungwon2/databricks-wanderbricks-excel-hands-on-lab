# 3) 엑셀로 결과 받기

## 실습 개요 📋

Leo는 데이터팀에 숫자를 요청하지 않고, 자기 엑셀에서 Gold 테이블을 직접 가져옵니다. 올린 데이터가 정제된 결과를 같은 엑셀에서 새로고침으로 받습니다.

## 이번 Step의 역할

<div class="grid" markdown>

<div class="card persona" markdown>

![Leo](../assets/images/personas/leo.svg){ width="96" }

<div markdown>

**📗 Leo - 지역 운영 매니저**

여러분은 Leo입니다. Gold의 국가별 월 매출을 엑셀로 가져오고, 새로고침으로 최신 숫자를 받습니다. 제외 행이 있으면 사유를 보고 고쳐서 다시 올릴 수도 있습니다.

</div>

</div>

</div>

## 실습 구조

| 페이지 | 내용 |
|---|---|
| [3.1) Gold 가져오기와 새로고침](3-1-import-refresh.md) | 월별 국가 요약을 엑셀로 가져오고 **Refresh All**로 새로고침합니다 |
| [3.2) (Optional) 제외 행 고쳐서 다시 올리기](3-2-optional-fix-rejects.md) | 제외 행의 사유를 보고 고쳐서 같은 달을 다시 올립니다 |

## 이번 Step에서 사용하는 기능

| 기능 | 설명 |
|---|---|
| Excel Add-in 가져오기 (**New import**, **Save and import**) | 테이블을 엑셀 시트로 가져옵니다 |
| 새로고침 (**Saved imports**, **Refresh All**) | 가져온 시트를 테이블의 최신 값으로 다시 채웁니다 |

## 학습 목표 🎯

- Gold 테이블을 엑셀로 가져오고 새로고침할 수 있습니다.
- 엑셀 숫자가 대시보드와 같은 근거에서 나오는지 확인합니다.

## 예상 소요 시간 ⏱️

약 20분 (3.2 포함, 생략하면 약 10분)
