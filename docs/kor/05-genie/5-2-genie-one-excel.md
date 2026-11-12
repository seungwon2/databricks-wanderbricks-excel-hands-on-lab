# 5.2) Genie One과 엑셀 안의 Genie

이 페이지에서는 Mina가 Genie One에서 질문하고, Leo가 엑셀 Add-in의 Genie에서 같은 질문을 합니다. 답을 엑셀 시트로 가져와 숫자가 같은지 확인합니다.

!!! info "Genie One 접근 권한"
    Genie One에 접근할 수 없다면 Genie One 부분은 건너뛰고 엑셀 안의 Genie만 해 봅니다. 권한이 없으면 워크스페이스 관리자에게 요청합니다.

## 1단계 - Genie One에서 묻기

1. 워크스페이스의 **Genie One**을 엽니다. <!-- TODO(확인): 사이드바에서 Genie One 메뉴의 위치. -->
2. **Ask Genie** 입력란에 다음 질문을 입력하고 Enter를 누릅니다.

```text title="질문"
7월 국가별 매출을 알려 주세요.
```

3. 답이 나오면 생성된 코드를 열어 `MEASURE(매출)`이 쓰였는지 확인합니다.

    ![Genie One 답변 화면: 2025년 7월 총 매출 514,860.30](../assets/images/05-genie/5-2-01-genie-one-answer.png)

!!! tip "출처 확인"
    답변 아래의 **N sources** 버튼을 누르면 어떤 데이터를 썼는지 볼 수 있습니다. 리허설에서는 5 sources였습니다.

## 2단계 - 엑셀 안의 Genie에서 같은 질문

1. 3.1에서 만든 엑셀 통합 문서를 엽니다.
2. Databricks Add-in 창의 **New import** 탭에서 **Genie One in Excel** 카드의 **Open Genie**를 누릅니다. 패널 제목은 **Genie One**입니다.
3. 입력란에 같은 질문을 입력합니다.

    ![엑셀 Add-in의 Genie 창과 답변 표](../assets/images/05-genie/5-2-02-genie-in-excel.png)

4. 답에 2025년 7월 총 매출 514,860.30이 보이는지 확인합니다. 국가별 표는 100개국입니다.

## 3단계 - 답을 시트로 가져오기

1. 답의 표 위 오른쪽에 있는 **Import**를 누릅니다.
2. 새 시트(Sheet3)에 표가 들어가고, 답 위에 `"july_revenue_country" imported to Sheet3` 메시지가 뜹니다. 시트 이름은 Genie가 정하므로 화면과 다를 수 있습니다.

    ![Genie 답을 Import한 시트와 imported 메시지](../assets/images/05-genie/5-2-03-genie-import.png)

3. 가져온 시트의 매출 합계가 514,860.30인지 확인합니다. <!-- TODO(확인): 표 위에 "Showing 50 of 100 rows"가 보였으므로, 가져온 시트에 100개국이 모두 들어가는지 확인합니다. -->
## 확인할 결과

| 확인 | 기대 값 (리허설 기준) |
|---|---|
| Genie One 답의 7월 합계 | 514,860.30 |
| 엑셀 Genie 답의 7월 합계 | 514,860.30 |
| 3.1의 시트 7월 `completed_revenue` 합계 | 514,860.30 |

세 값이 같으면 Mina, Leo, Ana가 같은 숫자를 본 것입니다. 답의 문장과 국가 순서는 달라도 괜찮습니다.

!!! success "축하합니다!"
    현업이 엑셀에서 올린 데이터가 데이터팀의 정의를 거쳐, 같은 숫자로 대시보드와 Genie와 엑셀에 나왔습니다. 마지막 페이지에서 리소스를 정리합니다.
