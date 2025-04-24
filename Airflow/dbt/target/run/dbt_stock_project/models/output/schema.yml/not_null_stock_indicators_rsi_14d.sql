select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select rsi_14d
from USER_DB_BLUEJAY.analytics.stock_indicators
where rsi_14d is null



      
    ) dbt_internal_test