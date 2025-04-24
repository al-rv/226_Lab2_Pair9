-- models/output/moving_averages.sql

WITH base AS (
  SELECT * FROM {{ ref('stock') }}
),

moving_avg_calc AS (
  SELECT
    symbol,
    trade_date,
    close,

    -- 7-day moving average
    ROUND(
      AVG(close) OVER (
        PARTITION BY symbol
        ORDER BY trade_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
      ), 2
    ) AS close_price_7d_ma,

    -- 14-day moving average
    ROUND(
      AVG(close) OVER (
        PARTITION BY symbol
        ORDER BY trade_date
        ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
      ), 2
    ) AS close_price_14d_ma,

    -- 30-day moving average
    ROUND(
      AVG(close) OVER (
        PARTITION BY symbol
        ORDER BY trade_date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
      ), 2
    ) AS close_price_30d_ma,

    CONCAT(symbol, '_', trade_date) AS stock_id  -- Composite key

  FROM base
)

SELECT * FROM moving_avg_calc
ORDER BY symbol, trade_date
