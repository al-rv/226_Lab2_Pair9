-- models/input/stock_forecast.sql

SELECT
  symbol,
  CAST(date AS DATE) AS forecast_date,
  CAST(predicted_close AS FLOAT) AS predicted_close,
  CAST(lower_bound AS FLOAT) AS lower_bound,
  CAST(upper_bound AS FLOAT) AS upper_bound,
  CONCAT(symbol, '_', CAST(date AS DATE)) AS stock_id 
FROM USER_DB_BLUEJAY.raw.STOCK_FORECAST