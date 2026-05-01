{{ config(
    materialized = 'table',
    schema = 'GOLD'
) }}

SELECT
    ORDER_ID,          -- Primary key of the fact
    CUSTOMER_ID,       -- Foreign key to DIM_CUSTOMER
    ORDER_DATE,        -- Event timestamp
    ORDER_STATUS,      -- Status of the order
    ORDER_TOTAL        -- Measure (numeric)
FROM {{ source('gold', 'GOLD_ORDERS_OBT') }}
