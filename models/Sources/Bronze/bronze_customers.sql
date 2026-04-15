{{ config(
    schema = "Bronze"
) }}

select * from 
{{ source('raw', 'CUSTOMER') }}