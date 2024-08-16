
with order_product_quantity as (
    select 
        order_id,
        product_id,
        price,
        count(order_item_id) as product_quantity
    from {{ ref('stg_order_items') }}
    group by order_id,product_id, price
)

select * from order_product_quantity
