/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

If OBJECT_ID ('silver.crm_cust_info', 'U') is not null
	Drop Table silver.crm_cust_info;
Go

Create Table silver.crm_cust_info(
	cst_id int,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR (50),
	cst_lastname NVARCHAR (50),
	cst_marital_status NVARCHAR (50),
	cst_gndr NVARCHAR (50),
	cst_create_date date,
	dwh_create_date datetime2 default GetDate()
);
Go

If OBJECT_ID ('silver.crm_prd_info', 'U') is not null
	Drop Table silver.crm_prd_info;
Go
Create Table silver.crm_prd_info(
	prd_id int,
	cat_id NVARCHAR (50),
	prd_key NVARCHAR (50),
	prd_nm NVARCHAR (50),
	prd_cost int,
	prd_line NVARCHAR (50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default GetDate()
);
Go

If OBJECT_ID ('silver.crm_sales_details', 'U') is not null
	Drop Table silver.crm_sales_details;
Go
Create Table silver.crm_sales_details(
	sls_ord_num NVARCHAR (50),
	sls_prd_key NVARCHAR (50),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int,
	dwh_create_date datetime2 default GetDate()
);
Go

If OBJECT_ID ('silver.erp_CUST_AZ12', 'U') is not null
	Drop Table silver.erp_CUST_AZ12;
Go
Create Table silver.erp_CUST_AZ12(
	CID NVARCHAR(50),
	BDATE date,
	GEN NVARCHAR(50),
	dwh_create_date datetime2 default GetDate()
);
Go

If OBJECT_ID ('silver.erp_LOC_A101', 'U') is not null
	Drop Table silver.erp_LOC_A101;
Go
Create Table silver.erp_LOC_A101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50),
	dwh_create_date datetime2 default GetDate()
);
Go

If OBJECT_ID ('silver.erp_PX_CAT_G1V2', 'U') is not null
	Drop Table silver.erp_PX_CAT_G1V2;
Go
Create Table silver.erp_PX_CAT_G1V2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50),
	dwh_create_date datetime2 default GetDate()
);
Go
