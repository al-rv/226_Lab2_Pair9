
  
    

        create or replace transient table USER_DB_BLUEJAY.analytics.actual_vs_forecast
         as
        (WITH actual AS (
  SELECT
    symbol,
    CAST(date AS DATE) AS trade_date,
    CAST(actual AS FLOAT) AS actual_close
  FROM USER_DB_BLUEJAY.raw.FINAL_DATA
  WHERE actual IS NOT NULL
),

forecast AS (
  SELECT
    symbol,
    CAST(date AS DATE) AS forecast_date,
    CAST(forecast AS FLOAT) AS predicted_close,
    CAST(lower_bound AS FLOAT) AS lower_bound,
    CAST(upper_bound AS FLOAT) AS upper_bound
  FROM USER_DB_BLUEJAY.raw.FINAL_DATA
  WHERE forecast IS NOT NULL
)

SELECT
  f.symbol,
  f.forecast_date,
  f.predicted_close,
  f.lower_bound,
  f.upper_bound,
  a.actual_close,
  
  -- Composite primary key
  CONCAT(f.symbol, '_', f.forecast_date) AS forecast_id

FROM forecast f
LEFT JOIN actual a
  ON f.symbol = a.symbol
 AND f.forecast_date = a.trade_date

ORDER BY f.symbol, f.forecast_date
        );
      
  