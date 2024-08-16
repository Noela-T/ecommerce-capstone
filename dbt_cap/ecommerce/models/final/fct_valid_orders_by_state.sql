-- states with orders that were Invoiced, approved, processing, shipped or delivered

with valid_orders as (
    select
        state_name,
        count(order_customer_id) as number_of_orders
    from {{ ref('int_orders_by_state') }}
    where order_status ='delivered' and order_delivered_customer_at is not null
    group by 1
)

select * from valid_orders
order by number_of_orders desc