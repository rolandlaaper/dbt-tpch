

select
    o_orderkey as order_key, 
    o_custkey as customer_key,
    o_orderstatus as order_status_code,
    o_totalprice{{ money() }} as order_amount,
    o_orderdate as order_date,
    o_orderpriority as order_priority_code,
    o_clerk as order_clerk_name,
    o_shippriority as shipping_priority,
    o_comment as order_comment --blblabla
from
    {{ source('tpch', 'orders') }}


 where o_orderdate <=  {{ var('max_order_date') }}    