select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select
    stock_id as unique_field,
    count(*) as n_records

from USER_DB_BLUEJAY.analytics.moving_averages
where stock_id is not null
group by stock_id
having count(*) > 1



      
    ) dbt_internal_test