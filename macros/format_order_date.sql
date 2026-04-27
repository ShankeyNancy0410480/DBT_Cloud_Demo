{% macro format_order_date(date_column) %}
    to_varchar({{ date_column }}, 'DD MON YYYY')
{% endmacro %}
