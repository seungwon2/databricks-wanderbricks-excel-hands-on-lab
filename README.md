# Wanderbricks Excel 핸즈온 랩

Databricks 고객용 Hands-on Lab 가이드입니다. [Zensical](https://zensical.org)로 만든 정적 사이트이며, GitHub Pages로 배포합니다.

- **사이트:** https://seungwon2.github.io/databricks-wanderbricks-excel-hands-on-lab/
- **한국어:** https://seungwon2.github.io/databricks-wanderbricks-excel-hands-on-lab/kor/
- **English:** https://seungwon2.github.io/databricks-wanderbricks-excel-hands-on-lab/eng/

## 저장소 구조

```
lab.json                    # 메뉴(nav)와 페이지 목록의 원본. 메뉴는 여기서만 고칩니다
docs/assets/images/<섹션>/  # 모든 이미지의 원본 (여기에만 넣습니다)
docs/<lang>/                # 언어별 페이지 (.md)
lab-files/<lang>/           # 실습에서 사용하는 SQL·YAML 등 파일
scripts/build.sh            # 모든 언어 사이트를 빌드하는 스크립트
zensical.<lang>.toml        # lab.json에서 생성되는 사이트 설정 (직접 고치지 않습니다)
.github/workflows/          # GitHub Pages 자동 배포
```

## 로컬에서 미리 보기

```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
ZENSICAL=.venv/bin/zensical scripts/build.sh
.venv/bin/zensical serve -f zensical.kor.toml -a localhost:8000
```

## 배포

`main` 브랜치에 push하면 GitHub Actions가 빌드해서 GitHub Pages에 배포합니다. 진행 상황은 **Actions** 탭의 **Deploy to GitHub Pages**에서 확인합니다.

## 주의할 점

- 가이드에서는 사용자 이름 자리에 `<your_name>`을 씁니다.
- 이 저장소가 공개라면 스크린샷과 본문에 고객사 이름, 개인 정보, 워크스페이스 URL, 토큰이 보이지 않아야 합니다.
- `site/`, `docs/<lang>/assets/`는 빌드 결과물이며 git에 올라가지 않습니다.
