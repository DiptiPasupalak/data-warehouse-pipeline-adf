TRUNCATE TABLE d_date;

DECLARE @start_date DATE = '2019-01-01';
DECLARE @end_date DATE = '2021-01-01';

WITH date_series AS (
  SELECT TOP (DATEDIFF(day, @start_date, @end_date) + 1)
    [date] = DATEADD(day, n, @start_date)
  FROM
    d_number
  ORDER BY n
)

, date_series_transformed AS (
  SELECT
    [date],  /* of type timestamp */
    [year] = YEAR([date]),
    [month] = MONTH([date]),
    [day] = DAY([date]),
    [quarter] = DATEPART(quarter, [date])
  FROM
    date_series
)

SELECT
  [date_id] = [year]*10000 + [month]*100 + [day],
  [date],  /* of type timestamp, coerced to date */
  [day],
  [day_suffix] = CASE
    WHEN [day] IN (1, 21, 31)
      THEN 'st'
    WHEN [day] IN (2, 22)
      THEN 'nd'
    WHEN [day] IN (3, 23)
      THEN 'rd'
    ELSE 'th'
  END,
  [weekday] = DATEPART(weekday, [date]),
  [weekday_name] = DATENAME(weekday, [date]),
  [day_of_week_in_month] = 1 + ([day] - 1)/7,
  [day_of_year] = DATENAME(dayofyear, [date]),
  [week_of_month] = DATEPART(week, [date]) - DATEPART(week, DATEFROMPARTS([year], [month], 1)) + 1,
  [week_of_year] = DATEPART(week, [date]),
  [iso_week_of_year] = DATEPART(iso_week, [date]),
  [month],
  [month_name] = DATENAME(month, [date]),
  [quarter],
  [quarter_name] = CASE
    WHEN [quarter] = 1
      THEN 'First'
    WHEN [quarter] = 2
      THEN 'Second'
    WHEN [quarter] = 3
      THEN 'Third'
    WHEN [quarter] = 4
      THEN 'Fourth'
  END,
  [year],
  [mmyyyy] = RIGHT('0' + CAST([month] AS VARCHAR(2)), 2) + CAST([year] AS VARCHAR(4)),
  [month_year] = LEFT(DATENAME(month, [date]), 3) + ' ' + CAST([year] AS VARCHAR(4)),
  [first_day_of_month] = DATEFROMPARTS([year], [month], 1),
  [last_day_of_month] = EOMONTH([date]),
  [first_day_of_quarter] = DATEADD(quarter, DATEDIFF(quarter, 0, [date]), 0),  /* of type timestamp, coerced to date */
  [last_day_of_quarter] = DATEADD(day, -1, DATEADD(quarter, DATEDIFF(quarter, 0, [date]) + 1, 0)),  /* of type timestamp, coerced to date */
  [first_day_of_year] = DATEFROMPARTS([year], 1, 1),
  [last_day_of_year] = DATEFROMPARTS([year], 12, 31),
  [first_day_of_next_month] = DATEADD(day, 1, EOMONTH([date])),
  [first_day_of_next_year] = DATEADD(day, 1, DATEFROMPARTS([year], 12, 31))
INTO
  #d_date_stg
FROM
  date_series_transformed;

/* Failed to execute query. Error: Common table expressions followed by INSERT, UPDATE, DELETE, or MERGE are not supported in this version. */
INSERT INTO d_date (id, date, day, day_suffix, weekday, weekday_name, day_of_week_in_month, day_of_year, week_of_month, week_of_year, iso_week_of_year, month, month_name, quarter, quarter_name, year, mmyyyy, month_year, first_day_of_month, last_day_of_month, first_day_of_quarter, last_day_of_quarter, first_day_of_year, last_day_of_year, first_day_of_next_month, first_day_of_next_year)
SELECT * FROM #d_date_stg;