-- macros/echo_customer_id.sql
{% macro echo_customer_id(CUSTOMER_ID, suffix) %}
    {{ CUSTOMER_ID }} || '{{ suffix }}'
{% endmacro %}

