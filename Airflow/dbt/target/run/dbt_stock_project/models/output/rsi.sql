
  
    

        create or replace transient table USER_DB_BLUEJAY.analytics.rsi
         as
        (-- models/output/rsi.sql

WITH  __dbt__cte__stock as (
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
), base AS (
  SELECT
    symbol,
    trade_date,
    close,
    LAG(close) OVER (
      PARTITION BY symbol ORDER BY trade_date
    ) AS prev_close
  FROM __dbt__cte__stock
),

gains_losses AS (
  SELECT
    symbol,
    trade_date,
    close,
    prev_close,
    CASE 
      WHEN close - prev_close > 0 THEN close - prev_close
      ELSE 0
    END AS gain,
    CASE 
      WHEN close - prev_close < 0 THEN ABS(close - prev_close)
      ELSE 0
    END AS loss
  FROM base
),

rsi_calc AS (
  SELECT
    symbol,
    trade_date,
    close,
    AVG(gain) OVER (
      PARTITION BY symbol ORDER BY trade_date
      ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
    ) AS avg_gain_14d,
    AVG(loss) OVER (
      PARTITION BY symbol ORDER BY trade_date
      ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
    ) AS avg_loss_14d
  FROM gains_losses
),

rsi_final AS (
  SELECT
    symbol,
    trade_date,
    close,
    avg_gain_14d,
    avg_loss_14d,
    CASE 
      WHEN avg_loss_14d = 0 THEN 100
      ELSE ROUND(100 - (100 / (1 + (avg_gain_14d / NULLIF(avg_loss_14d, 0)))), 2)
    END AS rsi_14d,
    CONCAT(symbol, '_', trade_date) AS stock_id  -- Composite key
  FROM rsi_calc
)

SELECT * FROM rsi_final
ORDER BY symbol, trade_date
        );
      
  