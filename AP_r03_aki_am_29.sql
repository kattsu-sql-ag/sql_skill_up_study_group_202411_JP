-- 試験問題からSQLを書いてデータを作成し検証する
-- ※PostgreSQLに対応

-- 【出典】応用情報技術者試験（令和３年 秋期）午前：問２９
-- https://www.ipa.go.jp/shiken/mondai-kaiotu/2021r03.html#aki_ap

-- ◆事前準備 ---------------------------------------------------

-- テーブル定義
CREATE TABLE 部門別売上 (
  部門コード CHAR(3) PRIMARY KEY
  , 第１期売上 INTEGER DEFAULT 0 NOT NULL
  , 第２期売上 INTEGER DEFAULT 0 NOT NULL
 )
;

-- データ登録
INSERT INTO 部門別売上
VALUES
('D01',1000,4000)
,('D02',2000,5000)
,('D03',3000,8000)
;

-- 全データ確認用のSQL
SELECT * FROM 部門別売上
ORDER BY 部門コード
;

-- ◆本題 ---------------------------------------------------

-- 【表示したい問合せ結果】
-- | 部門コード | 期 | 売上 |
-- | D01 | 第１期 | 1000
-- | D01 | 第２期 | 4000
-- | D02 | 第１期 | 2000
-- | D02 | 第２期 | 5000
-- | D03 | 第１期 | 3000
-- | D03 | 第２期 | 8000

-- 【問題】上記の実行結果を得るSQLは、ア～エのどれか？
-- ア
SELECT 部門コード, '第１期' AS 期, 第１期売上 AS 売上
    FROM 部門別売上
    INTERSECT
    (SELECT 部門コード, '第２期' AS 期, 第２期売上 AS 売上
     FROM 部門別売上)
    ORDER BY 部門コード, 期
;

-- イ
SELECT 部門コード, '第１期' AS 期, 第１期売上 AS 売上
    FROM 部門別売上
    UNION
    (SELECT 部門コード, '第２期' AS 期, 第２期売上 AS 売上
     FROM 部門別売上)
    ORDER BY 部門コード, 期
;

-- ウ
SELECT A.部門コード, '第１期' AS 期, A.第１期売上 AS 売上
    FROM 部門別売上 A
    CROSS JOIN
    (SELECT B.部門コード, '第２期' AS 期, B.第２期売上 AS 売上
         FROM 部門別売上 B) T
    ORDER BY 部門コード, 期
;

-- エ
SELECT A.部門コード, '第１期' AS 期, A.第１期売上 AS 売上
    FROM 部門別売上 A
    INNER JOIN
    (SELECT B.部門コード, '第２期' AS 期, B.第２期売上 AS 売上
         FROM 部門別売上 B) T ON A.部門コード = T.部門コード
    ORDER BY 部門コード, 期
;

-- ※正解はIPA公開の解答例を参照
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
-- 【おまけ】集合演算を使わずに結果を表示するSQLを作成してみた ---------------------------------------------------
SELECT DISTINCT
    A.部門コード
    , CASE WHEN 
                A.部門コード = B.部門コード THEN '第２期'
           ELSE '第１期'
      END AS 期
    , CASE WHEN 
                A.部門コード = B.部門コード THEN B.第２期売上
           ELSE A.第１期売上
      END AS 売上
FROM 部門別売上 A
CROSS JOIN 部門別売上 B
ORDER BY A.部門コード ,期
;