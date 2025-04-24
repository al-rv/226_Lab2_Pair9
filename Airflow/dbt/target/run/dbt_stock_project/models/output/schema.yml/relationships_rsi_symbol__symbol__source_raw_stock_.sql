select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with child as (
    select symbol as from_field
    from USER_DB_BLUEJAY.analytics.rsi
    where symbol is not null
),

parent as (
    select symbol as to_field
    from USER_DB_BLUEJAY.raw.STOCK
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



      
    ) dbt_internal_test