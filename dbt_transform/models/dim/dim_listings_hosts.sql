{{
  config(
    materialized = 'table',
    )
}}

with 
l as(
      select 
            *
      from
            {{ ref("dim_listings_cleansed") }}
),
h as(
      select 
            *
      from
            {{ ref("dim_hosts_cleansed") }}
)

select 
      l.listing_id,
      l.listing_name, 
      l.room_type,
      l.minimum_nights,
      l.price,
      l.host_id,
      h.host_name,
      h.host_start_date,
      h.host_response_time,
      h.host_is_superhost,
      h.host_phone_verification,
      h.host_email_verification,
from l
left join h on (l.host_id = h.host_id)

