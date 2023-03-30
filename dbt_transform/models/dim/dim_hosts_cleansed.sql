{{
  config(
    materialized = 'view',
    )
}}

with src_hosts as (
      select *
            from {{ ref("src_hosts") }}
)

select
      host_id,
      nvl(
            host_name,
            'anonymous'
      ) as host_name,
      host_start_date,
      case
            when host_response_time = 'within an hour' then 'early'
            when host_response_time = 'within a few hours' then 'late'
            else host_response_time
      end as host_response_time,
      host_is_superhost,
      host_phone_verification,
      host_email_verification
from 
      src_hosts