select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with __dbt__cte__stock as (
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
) select
    stock_id as unique_field,
    count(*) as n_records

from __dbt__cte__stock
where stock_id is not null
group by stock_id
having count(*) > 1



      
    ) dbt_internal_test