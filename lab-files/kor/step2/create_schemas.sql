-- Wanderbricks Excel HOL · Step 2 · 스키마 4개 만들기 (landing 스키마는 1.2에서 Catalog Explorer로 만들었습니다)
-- <your_name>을 본인 이름으로 바꾼 뒤 실행합니다.

CREATE SCHEMA IF NOT EXISTS <your_name>_wanderbricks_excel.bronze;
CREATE SCHEMA IF NOT EXISTS <your_name>_wanderbricks_excel.silver;
CREATE SCHEMA IF NOT EXISTS <your_name>_wanderbricks_excel.gold;
CREATE SCHEMA IF NOT EXISTS <your_name>_wanderbricks_excel.ops;
