/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schemas. It includes checks for:
        - Null or duplicate primary keys.
        - Unwanted spaces in string fields.
        - Data standardization and consistency.
        - Invalid date ranges and orders.
        - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

select cst_id, count(*) from silver.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

select cst_lastname from silver.crm_cust_info
where cst_lastname != trim(cst_lastname);

select distinct cst_marital_status from silver.crm_cust_info;

select * from silver.crm_cust_info

select prd_id, count(*) from silver.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null;

select prd_nm from silver.crm_prd_info
where prd_nm != trim(prd_nm);

select prd_cost from silver.crm_prd_info
where prd_cost<0 or prd_cost is null

select distinct prd_line from silver.crm_prd_info;

select * from silver.crm_prd_info
where prd_end_dt < prd_start_dt

select prd_id, prd_key, prd_nm, prd_start_dt, prd_end_dt, 
lead(prd_start_dt) over (partition by prd_key order by prd_start_dt) -1
as prd_end_dt_test
from bronze.crm_prd_info
where prd_key in ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')

select nullif(sls_due_dt,0) as sls_due_dt from bronze.crm_sales_details
where sls_due_dt <=0 or len(sls_due_dt) != 8 or 
sls_due_dt > 20500101 or sls_due_dt < 19000101 

select * from silver.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt

select distinct sls_sales,
sls_quantity,
sls_price
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price or sls_sales is null or 
sls_quantity is null or sls_price is null or sls_sales <= 0 or 
sls_quantity <= 0 or sls_price <= 0
order by sls_sales, sls_quantity, sls_price

select distinct bdate from silver.erp_CUST_AZ12 where bdate < '1926-01-01' 
or bdate > getdate()

select distinct gen from silver.erp_CUST_AZ12

select * from silver.erp_CUST_AZ12

select distinct cntry from silver.erp_LOC_A101
order by CNTRY

select * from silver.erp_LOC_A101

select * from bronze.erp_PX_CAT_G1V2
where maintenance != trim(maintenance)

select distinct maintenance from bronze.erp_PX_CAT_G1V2

select * from silver.erp_PX_CAT_G1V2
