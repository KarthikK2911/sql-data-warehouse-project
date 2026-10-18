/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

If OBJECT_ID('gold.dim_customers', 'V') is not null
	Drop view gold.dim_customers;
Go
Create view gold.dim_customers as
select 
	row_number() over (order by cst_id) as customer_key,
	CI.cst_id as customer_id,
	CI.cst_key as customer_number,
	CI.cst_firstname as first_name,
	CI.cst_lastname as last_name,
	LA.cntry as country,
	CI.cst_marital_status marital_status,
	case 
		when CI.cst_gndr != 'N/A' then CI.cst_gndr
		else Coalesce(CA.gen, 'N/A')
	end as gender,
	CA.bdate as birthdate,
	CI.cst_create_date as create_date		
from silver.crm_cust_info as CI
left join silver.erp_CUST_AZ12 as CA
on CI.cst_key = CA.CID
left join silver.erp_LOC_A101 as LA
on CI.cst_key = LA.CID
Go

If OBJECT_ID('gold.dim_products', 'V') is not null
	Drop view gold.dim_products;
Go
Create view gold.dim_products as
select
	ROW_NUMBER() over (order by PN.prd_start_dt, PN.prd_key) as product_key,
	PN.prd_id as product_id,
	PN.prd_key as product_number,
	PN.prd_nm as product_name,
	PN.cat_id as category_id,
	PC.cat as category,
	PC.subcat as subcategory,
	PC.maintenance,
	PN.prd_cost as cost,
	PN.prd_line as product_line,
	PN.prd_start_dt	as start_date
from silver.crm_prd_info PN
left join silver.erp_PX_CAT_G1V2 PC
on PN.cat_id = PC.id
where pn.prd_end_dt is null
Go

If OBJECT_ID('gold.fact_sales', 'V') is not null
	Drop view gold.fact_sales;
Go
Create view gold.fact_sales as 
select
	SD.sls_ord_num as order_number,
	PR.product_key,
	CU.customer_key,
	SD.sls_order_dt as order_date,
	SD.sls_ship_dt as shipping_date,
	SD.sls_due_dt as due_date,
	SD.sls_sales as sales_amount,
	SD.sls_quantity as quantity,
	SD.sls_price as price
from silver.crm_sales_details SD
left join gold.dim_products PR
on SD.sls_prd_key = PR.product_number
left join gold.dim_customers CU
on SD.sls_cust_id = CU.customer_id
Go
