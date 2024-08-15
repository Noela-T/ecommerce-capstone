
select 
    order_id,
    order_status,
    order_purchased_at,
    order_delivered_customer_at, 
    order_delivered_customer_at - order_purchased_at as time_difference
from {{ ref('stg_orders') }}
where order_status = 'delivered'