select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      -- tests/rsi_14d_range_test.sql
SELECT *
FROM USER_DB_BLUEJAY.analytics.rsi
WHERE rsi_14d <= 0 OR rsi_14d >= 100
      
    ) dbt_internal_test