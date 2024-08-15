

with valid_orders as (
    SELECT 
        order_id,
        order_status
    from {{ ref('stg_orders') }}
    where order_status in ('invoiced','approved','processing','shipped','delivered')
)

select * from valid_orders