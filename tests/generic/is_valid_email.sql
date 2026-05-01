{% test is_valid_email(model, column_name) %}

with data as (
    select {{ column_name }} as email
    from {{ model }}
),
invalid as (
    select email
    from data
    where email is not null
      and not regexp_like(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
)

select * from invalid

{% endtest %}
