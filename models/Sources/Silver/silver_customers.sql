{{ config(
    schema = "Silver",
    materialized = 'incremental',
    unique_key = 'CUSTOMER_ID'
) }}

{% set incremental_column = 'UPDATED_AT' %}

with bronze as (
    select
        CUSTOMER_ID,
        FIRST_NAME,
        LAST_NAME,
        EMAIL,
        PHONE,
        UPDATED_AT
    from {{ ref('bronze_customers') }}
)

select
    CUSTOMER_ID,
    UPPER(CAST(FIRST_NAME AS STRING)) as FIRST_NAME,
    INITCAP(LAST_NAME) as LAST_NAME,
    LOWER(EMAIL) as EMAIL,
    PHONE,
    UPDATED_AT

from bronze

{% if is_incremental() %}
where UPDATED_AT > (
    select coalesce(max(UPDATED_AT), '1900-01-01')
    from {{ this }}
)
{% endif %}
