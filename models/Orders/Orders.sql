{{ config(
    materialized = 'view'
) }}

WITH source AS (
    -- Pull raw data from your source definition
    SELECT * 
    FROM DBT_DEMO.ROW_SCHEMA.ORDER
),

renamed AS (
    -- Standardize column names and cast types
    SELECT
        ORDER_ID              AS order_id,
        CUSTOMER_ID           AS customer_id,
        ORDER_DATE::date      AS order_date,
        ORDER_STATUS          AS order_status,
        ORDER_TOTAL::float    AS order_total,
        CURRENCY              AS currency,
        PAYMENT_METHOD        AS payment_method,
        SHIPPING_ADDRESS      AS shipping_address,
        BILLING_ADDRESS       AS billing_address,
        CREATED_AT            AS created_at,
        UPDATED_AT            AS updated_at
    FROM source
),

cleaned AS (
    -- Normalize values and add derived fields
    SELECT
        *,
        UPPER(order_status) AS order_status_clean,
        CASE 
            WHEN order_total < 100 THEN 'LOW'
            WHEN order_total < 300 THEN 'MEDIUM'
            ELSE 'HIGH'
        END AS order_value_segment
    FROM renamed
),

final AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        order_status_clean AS order_status,
        order_total,
        currency,
        payment_method,
        order_value_segment,
        shipping_address,
        billing_address,
        created_at,
        updated_at
    FROM cleaned
)

SELECT * FROM final
