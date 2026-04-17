{{ config(
    schema = "Bronze",
    materialized = 'table',
    materialized = 'incremental'
) }}

{% set Incremental_Column = 'UPDATED_AT' %}

select * from {{ source('raw', 'CUSTOMER') }}
{% if is_incremental() %}
where {{ Incremental_Column }} > (
    SELECT COALESCE(MAX(UPDATED_AT), '1900-01-01')
    FROM {{ this }}
)
{% endif %}
