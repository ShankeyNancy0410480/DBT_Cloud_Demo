-- config(severity='error')

select email, count(*) as email_count
from {{ ref('bronze_customers') }}
where email is not null
group by email
having count(*) > 1
