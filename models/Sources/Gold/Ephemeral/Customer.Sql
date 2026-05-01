{{ config(materialized='ephemeral') }}

SELECT DISTINCT
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    PHONE,
    CURRENT_TIMESTAMP() AS RECORD_UPDATED_AT
FROM {{ source('gold', 'GOLD_ORDERS_OBT') }}
