select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select predicted_close
from USER_DB_BLUEJAY.analytics.actual_vs_forecast
where predicted_close is null



      
    ) dbt_internal_test