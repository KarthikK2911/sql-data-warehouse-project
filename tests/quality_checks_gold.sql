/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold Layer. These checks ensure:
        - Uniqueness of surrogate keys in dimension tables.
        - Referential integrity between fact and dimension tables.
        - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

select 
    customer_key,
    count(*) as duplicate_count
from gold.dim_customers
group by customer_key
having count(*) >1;

select 
    product_key,
    count(*) as duplicate_count
from gold.dim_products
group by product_key
having count(*) >1;

select distinct gender from gold.dim_customers

select * from gold.dim_products

select * from gold.fact_sales F
left join gold.dim_customers C
on C.customer_key = F.customer_key
left join gold.dim_products P
on P.product_key = F.product_key
where P.product_key is null or C.customer_key is null
