SELECT
  "SYMBOL" AS symbol,
  CAST("DATE" AS DATE) AS trade_date,
  CAST("CLOSE" AS FLOAT) AS close,
  CAST("VOLUME" AS INTEGER) AS volume,

  -- Daily change
  CAST("CLOSE" - LAG("CLOSE") OVER (
    PARTITION BY "SYMBOL"
    ORDER BY "DATE"
  ) AS FLOAT) AS daily_change,

  -- 7-day moving average of close price
  ROUND(
    AVG("CLOSE") OVER (
      PARTITION BY "SYMBOL"
      ORDER BY "DATE"
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2
  ) AS moving_avg_7,

  -- Composite key
  CONCAT("SYMBOL", '_', CAST("DATE" AS DATE)) AS stock_id

FROM USER_DB_BLUEJAY.raw.STOCK
ORDER BY symbol, trade_date