/*
=======================================================================
DDL Script: Create Bronze Tables
=======================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
=======================================================================
*/

If OBJECT_ID ('bronze.crm_cust_info', 'U') is not null
	Drop Table bronze.crm_cust_info;
Create Table bronze.crm_cust_info(
	cst_id int,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR (50),
	cst_lastname NVARCHAR (50),
	cst_marital_status NVARCHAR (50),
	cst_gndr NVARCHAR (50),
	cst_create_date date
);

If OBJECT_ID ('bronze.crm_prd_info', 'U') is not null
	Drop Table bronze.crm_prd_info;
Create Table bronze.crm_prd_info(
	prd_id int,
	prd_key NVARCHAR (50),
	prd_nm NVARCHAR (50),
	prd_cost int,
	prd_line NVARCHAR (50),
	prd_start_dt datetime,
	prd_end_dt datetime
);

If OBJECT_ID ('bronze.crm_sales_details', 'U') is not null
	Drop Table bronze.crm_sales_details;
Create Table bronze.crm_sales_details(
	sls_ord_num NVARCHAR (50),
	sls_prd_key NVARCHAR (50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);

If OBJECT_ID ('bronze.erp_CUST_AZ12', 'U') is not null
	Drop Table bronze.erp_CUST_AZ12;
Create Table bronze.erp_CUST_AZ12(
	CID NVARCHAR(50),
	BDATE date,
	GEN NVARCHAR(50)
);

If OBJECT_ID ('bronze.erp_LOC_A101', 'U') is not null
	Drop Table bronze.erp_LOC_A101;
Create Table bronze.erp_LOC_A101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50)
);

If OBJECT_ID ('bronze.erp_PX_CAT_G1V2', 'U') is not null
	Drop Table bronze.erp_PX_CAT_G1V2;
Create Table bronze.erp_PX_CAT_G1V2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50)
);
