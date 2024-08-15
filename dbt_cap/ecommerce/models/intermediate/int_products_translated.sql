
with products_english as (
    select
        p.*,
        c.product_category_english
    from {{ ref('stg_products') }} as p
    inner join {{ ref('stg_categories') }} as c
    on p.product_category_portuguese = c.product_category_portuguese
)

select * from products_english