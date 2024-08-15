with 

source as (
    select * from {{source('olist_source','olist_orders_dataset')}}
),

renamed as (
    select 
        order_id,
        customer_id as order_customer_id,
        order_status,
        order_purchase_timestamp as order_purchased_at,
        order_delivered_customer_date as order_delivered_customer_at
    from source
)

select * from renamed