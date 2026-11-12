# 1) 엑셀에서 올리기

## 실습 개요 📋

Leo는 지금까지 지역 예약 데이터를 엑셀로 정리해 메일로 보냈습니다. 이 Step에서는 같은 엑셀을 **Excel Add-in**으로 Databricks 테이블에 바로 씁니다. 메일도, 수작업 취합도 없습니다.

## 이번 Step의 역할

<div class="grid" markdown>

<div class="card persona" markdown>

![Leo](../assets/images/personas/leo.svg){ width="96" }

<div markdown>

**📗 Leo - 지역 운영 매니저**

여러분은 지역 운영 매니저 Leo입니다. 엑셀에서 예약 범위를 선택하고 **Write back**으로 업로드 테이블에 씁니다. 올린 뒤 테이블이 어떻게 보이는지 확인합니다.

</div>

</div>

</div>

## 실습 구조

| 페이지 | 내용 |
|---|---|
| [1.1) 엑셀 Add-in 연결하기](1-1-connect.md) | 실습 엑셀을 열고 Add-in에 로그인합니다 |
| [1.2) 6월 예약을 업로드 테이블로 쓰기](1-2-write-back.md) | 6월 예약을 `landing.bookings_upload`에 씁니다 |

## 이번 Step에서 사용하는 기능

| 기능 | 설명 |
|---|---|
| Databricks Add-in for Excel | 엑셀에서 워크스페이스에 로그인하고 카탈로그를 봅니다 |
| Write back (**Create table**, **Overwrite table**) | 선택한 엑셀 범위를 테이블로 만들거나 덮어씁니다 |

## 학습 목표 🎯

- 엑셀 범위를 Unity Catalog 테이블로 쓸 수 있습니다.
- 엑셀 서식이 붙은 숫자가 테이블에 **문자열**로 들어간다는 것을 확인합니다.

## 예상 소요 시간 ⏱️

약 25분
