{{ config(
    schema = "Bronze",
    materialized = 'table'
) }}

{% set cols = ['ORDER_ID', 'CUSTOMER_ID', 'ORDER_DATE', 'ORDER_STATUS', 'ORDER_TOTAL','UPDATED_AT'] %}

select
  {% for col in cols %}
    {{ col }}{% if not loop.last %}, {% endif %}
  {% endfor %}

  {% if 'CUSTOMER_ID' in cols %}
    , {{ echo_customer_id('CUSTOMER_ID', '_BronzCustomerOrder') }} as updated_customer_id
  {% endif %}

from {{ source('raw', 'ORDERS') }}
