DECLARE @n INT = 16;
DECLARE @i INT = 0;


IF (object_id('dwh.d_number', 'U') IS NOT NULL)
BEGIN
  TRUNCATE TABLE d_number;
  DROP TABLE d_number;
END;


CREATE TABLE #d_number_tmp (
  [n] INTEGER NOT NULL
);

WHILE @i < @n
BEGIN
  INSERT INTO #d_number_tmp (n) VALUES (@i);
  SET @i += 1;
END;


CREATE TABLE d_number
WITH (
  HEAP,
  DISTRIBUTION = REPLICATE
)
AS WITH square AS (
  /* contains (@n ^ 2) entries */
  SELECT a.n + (b.n * @n) AS n
  FROM #d_number_tmp AS a
  CROSS JOIN #d_number_tmp AS b
)
/* increase to ((@n ^ 2) ^ 2) entries */
 SELECT a.n + (b.n * @n * @n) AS n
FROM square AS a
CROSS JOIN square AS b;