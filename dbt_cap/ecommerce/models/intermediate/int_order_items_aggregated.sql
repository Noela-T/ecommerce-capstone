
with 

order_product_quantity as (
    select order_id, product_id, count(order_item_id) as product_quantity, price
    from {{ ref('stg_order_items') }}
    group by order_id,product_id, price
)

select * from order_product_quantity
