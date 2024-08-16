
with product_category as (
    select 
        product_category_portuguese,
        product_category_english,
        sum(product_quantity*price) as product_total_sales
    from {{ ref('int_sales_by_category') }}
    group by product_category_portuguese, product_category_english
)

select * from product_category
order by product_total_sales desc
