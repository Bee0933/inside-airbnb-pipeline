with raw_listings as(
    select * from {{ source('airbnb', 'listings') }}
)

select
    id as listing_id,
    name as listing_name,
    listing_url,
    room_type,
    minimum_nights,
    host_id,
    price
from
    raw_listings

