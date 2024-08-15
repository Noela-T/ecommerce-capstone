
with delivery_time_diff as (
    select 
        order_id,
        order_status,
        order_purchased_at,
        order_delivered_customer_at, 
        date_diff(order_delivered_customer_at, order_purchased_at, hour) as time_difference
    from {{ ref('stg_orders') }}
    where order_status = 'delivered'
)

select * from delivery_time_diff