with 

source as (
    select * from {{source('olist_source','olist_order_items_dataset')}}
),

renamed as (
    select 
        order_id,
        order_item_id,
        product_id,
        price
    from source
)

select * from renamed