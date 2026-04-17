{{ config(
    schema = "Bronze"
) }}
{% set cols = ['ORDER_ID', 'CUSTOMER_ID', 'ORDER_DATE', 'ORDER_STATUS' , 'ORDER_TOTAL'] %}

select
  {% for col in cols %}
    {{ col }}{% if not loop.last %}, {% endif %}
  {% endfor %}  
from {{ source('raw', 'ORDERS') }}
