-- 試験問題からSQLを書いてデータを作成し検証する
-- ※PostgreSQLに対応

-- 【出典】基本情報技術者試験（令和元年）午前：問２６
-- https://www.ipa.go.jp/shiken/mondai-kaiotu/2019h31.html#aki_fe

-- ◆事前準備 ---------------------------------------------------

-- テーブル定義
CREATE TABLE 得点 (
  学生番号 CHAR(4)
  , 科目 VARCHAR(20)
  , 点数 INTEGER DEFAULT 0 NOT NULL
  , PRIMARY KEY(学生番号,科目) -- 主キーを設定
 )
;

-- サンプルデータ登録（問題文に無いので、このファイル独自のものである）
INSERT INTO 得点
VALUES
('0001','国語',90)
,('0001','数学',72)
,('0002','国語',66)
,('0002','数学',90)
,('0003','国語',85)
,('0003','数学',75)
,('0004','国語',100)
,('0004','数学',58)
,('0005','国語',70)
,('0005','数学',94)
;

-- 全データ確認用のSQL
SELECT * FROM 得点
ORDER BY 学生番号,科目 -- 主キー順にソート
;

-- ◆本題 ---------------------------------------------------

-- 【実行して結果を表示したいSQL】
SELECT 学生番号,AVG(点数)
FROM 得点
GROUP BY -- [a]
;

-- 【問題】空欄[a]には、ア～エのどれが入るか？
-- ア 科目 HAVING AVG(点数) >= 80
-- イ 科目 WHERE 点数 >= 80
-- ウ 学生番号 HAVING AVG(点数) >= 80
-- エ 学生番号 WHERE 点数 >= 80

-- ※正解はIPA公開の解答例を参照

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
-- 【おまけ】問題文のSQLをチューニングしてみた ---------------------------------------------------
WITH 平均 AS MATERIALIZED(
    SELECT DISTINCT
        学生番号 
      , AVG(点数) OVER(PARTITION BY 学生番号) AS 平均点数
    FROM 得点
)
SELECT 学生番号 ,平均点数 FROM 平均
WHERE 平均点数 >= 80
;
