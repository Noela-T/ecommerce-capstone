
with all_orders as (
    select
        state_name,
        count(order_customer_id) as number_of_orders
    from {{ ref('int_orders_by_state') }}
    group by 1
)

select * from all_orders
order by number_of_orders desc