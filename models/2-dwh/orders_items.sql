
with orders as (
    
    select * from {{ ref('orders') }}

),
line_items as (

select
    l_orderkey as order_key,
    l_partkey as part_key,
    l_suppkey as supplier_key,
    l_linenumber as order_line_number,
    l_quantity as quantity,
    l_extendedprice{{ money() }} as extended_price,
    l_discount{{ money() }} as discount_percentage,
    l_tax{{ money() }} as tax_rate,
    l_returnflag as return_status_code,
    l_linestatus as order_line_status_code,
    l_shipdate as ship_date,
    l_commitdate as commit_date,
    l_receiptdate as receipt_date,
    l_shipinstruct as ship_instructions_desc,
    l_shipmode as ship_mode_name,
    l_comment as order_line_comment
from
    {{ source('tpch', 'lineitem') }}


)
select 

    {{ dbt_utils.surrogate_key(['o.order_key', 'l.order_line_number']) }} as order_item_key,

    o.order_key,
    o.order_date,
    o.customer_key,
    o.order_status_code,
    
    l.part_key,
    l.supplier_key,
    l.return_status_code,
    l.order_line_number,
    l.order_line_status_code,
    l.ship_date,
    l.commit_date,
    l.receipt_date,
    l.ship_mode_name,

    l.quantity,
    
    -- extended_price is actually the line item total,
    -- so we back out the extended price per item
    (l.extended_price/nullif(l.quantity, 0)){{ money() }} as base_price,
    l.discount_percentage,
    (base_price * (1 - l.discount_percentage)){{ money() }} as discounted_price,

    l.extended_price as gross_item_sales_amount,
    (l.extended_price * (1 - l.discount_percentage)){{ money() }} as discounted_item_sales_amount,
    -- We model discounts as negative amounts
    (-1 * l.extended_price * l.discount_percentage){{ money() }} as item_discount_amount,
    l.tax_rate,
    ((gross_item_sales_amount + item_discount_amount) * l.tax_rate){{ money() }} as item_tax_amount,
    (
        gross_item_sales_amount + 
        item_discount_amount + 
        item_tax_amount
    ){{ money() }} as net_item_sales_amount

from
    orders o
    join
    line_items l
        on o.order_key = l.order_key
order by
    o.order_date