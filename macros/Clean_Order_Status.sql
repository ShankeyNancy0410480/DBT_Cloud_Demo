{% macro clean_order_status(status_column) %}
    case 
        when {{ status_column }} is null then null
        when lower(trim({{ status_column }})) in ('pending', 'p') then 'Pend'
        when lower(trim({{ status_column }})) in ('completed', 's') then 'Comp'
        when lower(trim({{ status_column }})) in ('cancelled', 'c', 'canceled') then 'Can'
        else initcap(trim({{ status_column }}))
    end
{% endmacro %}