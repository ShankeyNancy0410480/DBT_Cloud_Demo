{% macro build_obt(model_name) %}

{% set results = run_query("SELECT MODEL_NAME, TABLE_NAME, SCHEMA_NAME, ALIAS, JOIN_KEY, JOIN_TYPE, SELECT_COLUMNS
     FROM DBT_DEMO.METADATA.MODEL_METADATA
     WHERE MODEL_NAME = '" ~ model_name ~ "'"
) %}

{% set rows = results.rows %}
{% set colnames = results.column_names %}

{% set metadata = [] %}
{% for r in rows %}
    {% set row_dict = {} %}
    {% for c in colnames %}
        {% do row_dict.update({ c: r[colnames.index(c)] }) %}
    {% endfor %}
    {% do metadata.append(row_dict) %}
{% endfor %}

{% set base = metadata | selectattr("JOIN_TYPE", "equalto", "base") | list | first %}
{% set others = metadata | rejectattr("JOIN_TYPE", "equalto", "base") | list %}

WITH base_table AS (
    SELECT
        {{ base['SELECT_COLUMNS'] }}
    FROM DBT_DEMO.{{ base['SCHEMA_NAME'] }}.{{ base['TABLE_NAME'] }} {{ base['ALIAS'] }}
)

{% for t in others %}
, {{ t['ALIAS'] }} AS (
    SELECT
        {{ t['SELECT_COLUMNS'] }}
    FROM DBT_DEMO.{{ t['SCHEMA_NAME'] }}.{{ t['TABLE_NAME'] }} {{ t['ALIAS'] }}
)
{% endfor %}

SELECT
    *
FROM base_table b
{% for t in others %}
    {{ t['JOIN_TYPE'] | upper }} JOIN {{ t['ALIAS'] }} {{ t['ALIAS'] }}
        ON b.{{ t['JOIN_KEY'].split('_', 1)[1] }} = {{ t['ALIAS'] }}.{{ t['JOIN_KEY'] }}
{% endfor %}

{% endmacro %}
