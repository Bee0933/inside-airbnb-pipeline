{{
  config(
    materialized = 'view',
    )
}}

with src_listings as(
      select * 
            from {{ ref("src_listings") }}
)


select
      listing_id,
      listing_name,
      room_type,
      case
            when minimum_nights = 0 then 1
            else minimum_nights
      end as minimum_nights,
      host_id,
      price
from
      src_listings