
with raw_hosts as(
    select * from {{ source('airbnb', 'listings') }}
)

select
    host_id,
    name as host_name,
    host_since as host_start_date,
    host_is_superhost,
    host_response_time,
    host_verifications_phone as host_phone_verification,
    host_verifications_email as host_email_verification
from
    raw_hosts