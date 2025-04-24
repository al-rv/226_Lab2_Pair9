{% snapshot stock_data_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='stock_id',
      strategy='check',
      check_cols=['close', 'volume', 'daily_change'],
    )
}}

SELECT *
FROM {{ ref('stock_indicators') }}

{% endsnapshot %}