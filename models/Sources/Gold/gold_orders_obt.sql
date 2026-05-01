{{ config(
    schema = "gold",
    materialized = 'table'
) }}

{{ build_obt('gold_orders_obt') }}
