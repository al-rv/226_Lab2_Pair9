
  
    

        create or replace transient table USER_DB_BLUEJAY.analytics.volume_summary
         as
        (-- models/output/volume_summary.sql

SELECT
  symbol,
  CAST(date AS DATE) AS trade_date,
  
  -- 7-day rolling (weekly) volume sum
  SUM(CAST(volume AS INTEGER)) OVER (
    PARTITION BY symbol
    ORDER BY CAST(date AS DATE)
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS weekly_volume,

  -- Composite key for uniqueness
  CONCAT(symbol, '_', CAST(date AS DATE)) AS stock_id

FROM USER_DB_BLUEJAY.raw.STOCK
ORDER BY symbol, trade_date
        );
      
  