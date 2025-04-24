-- models/input/stock.sql

SELECT
  symbol,
  CAST(date AS DATE) AS trade_date,
  CAST(open AS FLOAT) AS open,
  CAST(high AS FLOAT) AS high,
  CAST(low AS FLOAT) AS low,
  CAST(close AS FLOAT) AS close,
  CAST(volume AS INTEGER) AS volume,
  CONCAT(symbol, '_', CAST(date AS DATE)) AS stock_id  -- Composite primary key
FROM USER_DB_BLUEJAY.raw.STOCK