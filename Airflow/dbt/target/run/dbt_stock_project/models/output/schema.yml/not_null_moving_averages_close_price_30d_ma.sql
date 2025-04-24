select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select close_price_30d_ma
from USER_DB_BLUEJAY.analytics.moving_averages
where close_price_30d_ma is null



      
    ) dbt_internal_test