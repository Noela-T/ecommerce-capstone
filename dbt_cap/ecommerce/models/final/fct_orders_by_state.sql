 
with orders_joined_customers as (
    select 
        c.order_customer_id,
        o.order_id,
        o.order_status,
        c.state_code,
        o.order_purchased_at,
        o.order_delivered_customer_at, 
        date_diff(o.order_delivered_customer_at, o.order_purchased_at, hour) as time_difference,
        s.state as state_name 
    from {{ ref('stg_orders') }} o
    inner join {{ ref('stg_customers') }} c
        on o.order_customer_id = c.order_customer_id
    inner join {{ ref('states') }} s
        on s.uf = c.state_code
)

select * from orders_joined_customers