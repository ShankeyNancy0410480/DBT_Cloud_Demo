{{ config(
    schema = "Silver",
    materialized = "incremental",
    unique_key = "ORDER_ID",
    incremental_strategy = "merge",
    on_schema_change = "sync_all_columns"
) }}

{% set incremental_column = "UPDATED_AT" %}

with bronze as (

    select
        ORDER_ID,
        CUSTOMER_ID,
        ORDER_DATE,
        ORDER_STATUS,
        ORDER_TOTAL,
        UPDATED_AT,
        UPDATED_CUSTOMER_ID
    from {{ ref('bronze_orders') }}

)

select
    ORDER_ID,
    CUSTOMER_ID,
    {{ format_order_date('ORDER_DATE') }} as ORDER_DATE,
    coalesce({{ clean_order_status('ORDER_STATUS') }}, ORDER_STATUS) as ORDER_STATUS,
    ORDER_TOTAL,
    UPDATED_AT,
    UPDATED_CUSTOMER_ID

from bronze

{% if is_incremental() %}
where UPDATED_AT > (
    select coalesce(max(UPDATED_AT), '1900-01-01'::timestamp)
    from {{ this }}
)
{% endif %}
