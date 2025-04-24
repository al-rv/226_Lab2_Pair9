select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select symbol
from USER_DB_BLUEJAY.analytics.actual_vs_forecast
where symbol is null



      
    ) dbt_internal_test