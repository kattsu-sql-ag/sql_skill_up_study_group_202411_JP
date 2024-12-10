-- 試験問題からSQLを書いてデータを作成し検証する
-- ※PostgreSQLに対応

-- 【出典】応用情報技術者試験（令和２年 秋期）午前：問２９
-- https://www.ipa.go.jp/shiken/mondai-kaiotu/2020r02.html#aki_ap

-- ◆事前準備 ---------------------------------------------------

-- テーブル定義
CREATE TABLE 東京在庫 (
  商品コード CHAR(4) PRIMARY KEY
  , 在庫数 INTEGER DEFAULT 0 NOT NULL
 )
;

CREATE TABLE 大阪在庫 (
  商品コード CHAR(4) PRIMARY KEY
  , 在庫数 INTEGER DEFAULT 0 NOT NULL
 )
;

-- データ登録
INSERT INTO 東京在庫
VALUES
('A001',50)
,('B002',25)
,('C003',35)
;

INSERT INTO 大阪在庫
VALUES
('B002',15)
,('C003',35)
,('D004',80)
;

-- 全データ確認用のSQL
SELECT * FROM 東京在庫
ORDER BY 商品コード -- 主キー順にソート
;

SELECT * FROM 大阪在庫
ORDER BY 商品コード -- 主キー順にソート
;

-- ◆本題 ---------------------------------------------------

-- 【実行して結果を表示したいSQL】
SELECT 商品コード, 在庫数 FROM 東京在庫
    UNION ALL
SELECT 商品コード, 在庫数 FROM 大阪在庫
;

-- 【問題】上記SQLの実行結果は、ア～エのどれか？
-- ア | 商品コード | 在庫数 |
--    | A001 | 50 |
--    | B002 | 25 |
--    | B002 | 15 |
--    | D004 | 80 |

-- イ | 商品コード | 在庫数 |
--    | A001 | 50 |
--    | B002 | 40 |
--    | C003 | 70 |
--    | D004 | 80 |

-- ウ | 商品コード | 在庫数 |
--    | A001 | 50 |
--    | B002 | 25 |
--    | B002 | 15 |
--    | C003 | 35 |
--    | D004 | 80 |

-- エ | 商品コード | 在庫数 |
--    | A001 | 50 |
--    | B002 | 25 |
--    | B002 | 15 |
--    | C003 | 35 |
--    | C003 | 35 |
--    | D004 | 80 |

-- ソート（ORDER BY）をしていないため、表示順は実行の都度変わることがある。
-- 順番を『確実に』選択肢の通りに表示させたい場合は [ ORDER BY 商品コード ,在庫数 DESC ] を追加する。
;
-- ※正解はIPA公開の解答例を参照

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
-- 【おまけ】不正解の選択の結果を表示するSQLを作成してみた ---------------------------------------------------
-- これはどれになる？（allを外すケース）
SELECT 商品コード, 在庫数 FROM 東京在庫
    UNION
SELECT 商品コード, 在庫数 FROM 大阪在庫
;

-- これはどれになる？（union以外の集合演算を使うケース）
(
    SELECT 商品コード, 在庫数 FROM 東京在庫
        EXCEPT ALL
    SELECT 商品コード, 在庫数 FROM 大阪在庫
)
UNION ALL
(
    SELECT 商品コード, 在庫数 FROM 大阪在庫
        EXCEPT ALL
    SELECT 商品コード, 在庫数 FROM 東京在庫
)
ORDER BY 商品コード
;

-- これはどれになる？
WITH 全拠点在庫 AS MATERIALIZED(
    SELECT 商品コード, 在庫数 FROM 東京在庫
        UNION ALL
    SELECT 商品コード, 在庫数 FROM 大阪在庫
)
SELECT 商品コード, SUM(在庫数) AS 在庫数
FROM 全拠点在庫
    GROUP BY 商品コード
    ORDER BY 商品コード
;

-- これはどれになる？（もはや UNION や UNION ALLですらない）
SELECT 
    COALESCE(tk.商品コード,os.商品コード) AS 商品コード
  , COALESCE(tk.在庫数,0) + COALESCE(os.在庫数,0) AS 在庫数
FROM 東京在庫 tk
FULL OUTER JOIN 大阪在庫 os ON tk.商品コード = os.商品コード
ORDER BY 商品コード
;