select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with  __dbt__cte__stock as (
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
), child as (
    select stock_id as from_field
    from USER_DB_BLUEJAY.analytics.moving_averages
    where stock_id is not null
),

parent as (
    select stock_id as to_field
    from __dbt__cte__stock
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



      
    ) dbt_internal_test