
    
    

select
    trade_date as unique_field,
    count(*) as n_records

from USER_DB_BLUEJAY.analytics.rsi
where trade_date is not null
group by trade_date
having count(*) > 1


