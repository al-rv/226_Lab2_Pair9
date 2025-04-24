select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select upper_bound
from USER_DB_BLUEJAY.analytics.actual_vs_forecast
where upper_bound is null



      
    ) dbt_internal_test