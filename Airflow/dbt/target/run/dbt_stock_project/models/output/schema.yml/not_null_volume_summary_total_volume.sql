select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select total_volume
from USER_DB_BLUEJAY.analytics.volume_summary
where total_volume is null



      
    ) dbt_internal_test