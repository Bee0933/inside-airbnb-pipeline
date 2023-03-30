with raw_reviews as(
    select * from {{ source('airbnb', 'reviews') }}
)

select
    listing_id,
    reviewer_id,
    date as review_date,
    reviewer_name
from
    raw_reviews