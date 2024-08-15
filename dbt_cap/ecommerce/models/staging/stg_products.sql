with 

source as (
    select * from {{source('olist_source','olist_products_dataset')}}
),

renamed as (
    select 
        product_id,
        product_category_name as product_category_portuguese
    from source
)

select * from renamed