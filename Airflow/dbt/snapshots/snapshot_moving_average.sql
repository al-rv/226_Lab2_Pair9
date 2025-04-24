{% snapshot moving_averages_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='stock_id',
      strategy='check',
      check_cols=['close_price_7d_ma', 'close_price_14d_ma', 'close_price_30d_ma'],
    )
}}

SELECT *
FROM {{ ref('moving_averages') }}

{% endsnapshot %}