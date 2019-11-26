-- Deze test valideerd de orderwaarde van een order
-- select * from "DEMO"."DATAMART"."FCT_ORDERS"  where order_key  = 2212167;

with data as (
select 
	* 
from 
	{{ ref('fct_orders') }}
where 
	order_key  = 2212167

),

validation as (
select *
from 
	data
where 
	GROSS_ITEM_SALES_AMOUNT != '367260.8500'
)

select * from validation