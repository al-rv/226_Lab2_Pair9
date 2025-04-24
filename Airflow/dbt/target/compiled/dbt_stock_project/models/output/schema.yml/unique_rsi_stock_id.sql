
    
    

select
    stock_id as unique_field,
    count(*) as n_records

from USER_DB_BLUEJAY.analytics.rsi
where stock_id is not null
group by stock_id
having count(*) > 1


