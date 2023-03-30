{{
  config(
    materialized = 'table',
    )
}}


with src_reviews as(
      select *
            from 
                  {{ ref("src_reviews") }}
)

select 
      listing_id,
      reviewer_id,
      review_date,
      reviewer_name
from 
      src_reviews