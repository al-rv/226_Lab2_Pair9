select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select trade_date
from USER_DB_BLUEJAY.analytics.stock_indicators
where trade_date is null



      
    ) dbt_internal_test