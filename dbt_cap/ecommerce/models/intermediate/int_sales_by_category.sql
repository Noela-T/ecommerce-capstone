 
with joined as (
    select
        valid_orders.*,
        i.product_quantity, 
        i.price, 
        i.product_id, 
        p.product_category_portuguese,
        p.product_category_english
    from {{ ref('int_valid_orders') }} as valid_orders
    INNER JOIN {{ ref('int_order_items_aggregated') }} i ON valid_orders.order_id=i.order_id
    INNER JOIN {{ ref('int_products_translated') }} p ON i.product_id = p.product_id
)

select * from joined