{{
    config(
        materialized = 'table'
    )
}}
with orders_items as (
    
    select * from {{ ref('orders_items') }}

),

final as (
    select 

        o.order_item_key,
        o.order_key,
        o.order_date,
        o.customer_key,
        o.order_status_code,
        
        o.part_key,
        o.supplier_key,
        o.return_status_code,
        o.order_line_number,
        o.order_line_status_code,
        o.ship_date,
        o.commit_date,
        o.receipt_date,
        o.ship_mode_name,
        o.base_price,
        o.discount_percentage,
        o.discounted_price,
        o.tax_rate,
        
        1 as order_item_count,
        o.quantity,

        o.gross_item_sales_amount,
        o.discounted_item_sales_amount,
        o.item_discount_amount,
        o.item_tax_amount,
        o.net_item_sales_amount

    from
        orders_items o

)
select 
    f.*,
    {{ dbt_housekeeping() }}
from
    final f

-- Laadt alleen de laatste 3 dagen aan data in een dev omgeving
{% if target.name == 'xxx' %}
where order_date >= dateadd('day', -3, current_date)
{% endif %}

order by
    f.order_date