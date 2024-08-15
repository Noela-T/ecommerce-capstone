with 

source as (
    select * from {{source('olist_source','olist_customers_dataset')}}
),

renamed as (
    select 
        customer_id as order_customer_id,
        customer_unique_id as customer_id,
        customer_state as state_code,
        customer_zip_code_prefix as zip_code_prefix
    from source
)

select * from renamed