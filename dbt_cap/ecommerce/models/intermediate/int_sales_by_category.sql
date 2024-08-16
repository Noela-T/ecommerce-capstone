 
with joined as (
    select
        o.order_id,
        o.order_status,
        i.product_quantity, 
        i.price, 
        i.product_id, 
        p.product_category_portuguese,
        p.product_category_english
    from {{ ref('stg_orders') }} o
    INNER JOIN {{ ref('int_order_items_aggregated') }} i ON o.order_id=i.order_id
    INNER JOIN {{ ref('int_products_translated') }} p ON i.product_id = p.product_id

    where o.order_status ='delivered' and o.order_delivered_customer_at is not null
)

select * from joined