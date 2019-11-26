{{
    config(
        materialized = 'table'
    )
}}
with customers as (

    select * from {{ ref('customers') }}

),

final as (
    select 
        c.customer_key,
        c.customer_name,
        c.customer_address,
        c.customer_phone_number,
        c.customer_account_balance,
        c.customer_market_segment_name
    from
        customers c

)
select 
    f.*,
    {{ dbt_housekeeping() }}
from
    final f
order by
    f.customer_key
