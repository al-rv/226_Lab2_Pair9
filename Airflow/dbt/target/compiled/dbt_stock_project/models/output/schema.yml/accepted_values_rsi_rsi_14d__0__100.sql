
    
    

with all_values as (

    select
        rsi_14d as value_field,
        count(*) as n_records

    from USER_DB_BLUEJAY.analytics.rsi
    group by rsi_14d

)

select *
from all_values
where value_field not in (
    '0','100'
)


