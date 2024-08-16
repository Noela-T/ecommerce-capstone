with 

source as (
    select * from {{source('olist_source','product_category_name_translation')}}
),

renamed as (
    select 
        product_category_name as product_category_portuguese,
        product_category_name_english as product_category_english
    from source
)

select * from renamed