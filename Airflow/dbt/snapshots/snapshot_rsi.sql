{% snapshot rsi_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='stock_id',
      strategy='check',
      check_cols=['close', 'rsi_14d'],
    )
}}

SELECT *
FROM {{ ref('rsi') }}

{% endsnapshot %}