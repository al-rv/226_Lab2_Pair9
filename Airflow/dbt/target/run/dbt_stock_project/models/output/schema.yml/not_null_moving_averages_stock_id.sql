select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select stock_id
from USER_DB_BLUEJAY.analytics.moving_averages
where stock_id is null



      
    ) dbt_internal_test