/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.
    Actions Performed:
        - Truncates Silver tables.
        - Inserts transformed and cleansed data from Bronze into Silver tables.

    Parameters:
        None.
        This stored procedure does not accept any parameters or return any values.

    Usage Example:
        EXEC Silver.load_silver;
===============================================================================
*/

Create or alter procedure silver.load_silver as 
Begin
	Declare @start_time Datetime, @end_time Datetime, @batch_start_time Datetime, @batch_end_time Datetime
	Begin Try
		Set @batch_start_time = GETDATE();
		Print '>> Truncating silver.crm_cust_info';
		Print '***********************************************************';
		Print 'Loading silver layer';
		Print '***********************************************************';
		Print '-----------------------------------------------------------';
		Print 'Loading CRM tables';
		Print '-----------------------------------------------------------';
		set @start_time = GETDATE();
		Print '>> Truncating silver.crm_cust_info'
		Truncate Table silver.crm_cust_info;
		Print '>> Inserting data into silver.crm_cust_info'
		Insert into silver.crm_cust_info(
			cst_id, 
			cst_key, 
			cst_firstname, 
			cst_lastname,
			cst_marital_status, 
			cst_gndr, 
			cst_create_date
		)
		select 
			cst_id, 
			cst_key, 
			trim(cst_firstname) as cst_firstname, 
			trim(cst_lastname) as cst_lastname,  
			case 
				when Upper(trim(cst_marital_status)) = 'S' then 'Single'
				when Upper(trim(cst_marital_status)) = 'M' then 'Married'
				else 'N/A' 
			end as cst_marital_status,
			case 
				when Upper(trim(cst_gndr)) = 'F' then 'Female'
				when Upper(trim(cst_gndr)) = 'M' then 'Male'
				else 'N/A' 
			end as cst_gndr,
			cst_create_date 
		from (
			select 
				*,
				ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as flag_last 
			from bronze.crm_cust_info 
			where cst_id is not null
		)t 
		where flag_last = 1 
		Set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';

		set @start_time = GETDATE();
		Print '>> Truncating silver.crm_prd_info'
		Truncate Table silver.crm_prd_info;
		Print '>> Inserting data into silver.crm_prd_info'
		Insert into silver.crm_prd_info(
			prd_id, 
			cat_id, 
			prd_key, 
			prd_nm, 
			prd_cost, 
			prd_line, 
			prd_start_dt, 
			prd_end_dt
		)
		select 
			prd_id, 
			replace(substring(prd_key, 1, 5), '-', '_') as cat_id,
			substring(prd_key, 7, len(prd_key)) as prd_key,
			prd_nm, 
			isnull(prd_cost, 0) as prd_cost, 
			case upper(trim(prd_line))
				when 'M' then 'Mountain'
				when 'R' then 'Road'
				when 'S' then 'Other Sales'
				when 'T' then 'Touring'
				else 'N/A'
			end as prd_line,
			cast(prd_start_dt as date) as prd_start_dt, 
			cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt) -1 as Date) as prd_end_dt
		from bronze.crm_prd_info
		Set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';

		set @start_time = GETDATE();
		Print '>> Truncating silver.crm_sales_details'
		Truncate Table silver.crm_sales_details;
		Print '>> Inserting data into silver.crm_sales_details'
		Insert into silver.crm_sales_details(
			sls_ord_num, 
			sls_prd_key, 
			sls_cust_id, 
			sls_order_dt, 
			sls_ship_dt, 
			sls_due_dt, 
			sls_sales, 
			sls_quantity, 
			sls_price
		)

		select 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			case 
				when sls_order_dt = 0  or len(sls_order_dt) != 8 then null
				else cast(cast(sls_order_dt as varchar) as date)
			end as sls_order_dt,
			case 
				when sls_ship_dt = 0  or len(sls_ship_dt) != 8 then null
				else cast(cast(sls_ship_dt as varchar) as date)
			end as sls_ship_dt,
			case 
				when sls_due_dt = 0  or len(sls_due_dt) != 8 then null
				else cast(cast(sls_due_dt as varchar) as date)
			end as sls_due_dt,
			case 
				when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price) then sls_quantity * abs(sls_price)
				else sls_sales
			end as sls_sales,
			sls_quantity,
			case 
				when sls_price is null or sls_price <= 0
				then sls_sales/nullif(sls_quantity,0)
				else sls_price
			end as sls_price
		from bronze.crm_sales_details
		Set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';

		Print '-----------------------------------------------------------';
		Print 'Loading ERP tables';
		Print '-----------------------------------------------------------';
		set @start_time = GETDATE();
		Print '>> Truncating silver.erp_CUST_AZ12'
		Truncate Table silver.erp_CUST_AZ12;
		Print '>> Inserting data into silver.erp_CUST_AZ12'
		Insert into silver.erp_CUST_AZ12(
			cid, 
			bdate, 
			gen
		)

		select
			case 
				when cid like 'NAS%' then substring(cid, 4, len(cid))
				else cid
			end as cid,
			case 
				when bdate > CURRENT_DATE then null
				else bdate
			end as bdate,
			case 
				when upper(trim(gen)) in ('F', 'Female') then 'Female'
				when upper(trim(gen)) in ('M', 'Male') then 'Male'
				else 'N/A'
			end as gen
		from bronze.erp_CUST_AZ12
		Set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';

		set @start_time = GETDATE();
		Print '>> Truncating silver.erp_LOC_A101'
		Truncate Table silver.erp_LOC_A101;
		Print '>> Inserting data into silver.erp_LOC_A101'
		Insert into silver.erp_LOC_A101(cid, CNTRY)

		select 
			replace(cid, '-', '') as cid,
			case 
				when trim(cntry) = 'DE' then 'Germany'
				when trim(cntry) in ('US', 'USA') then 'United States'
				when trim(cntry) = '' or cntry is null then 'N/A'
				else trim(cntry)
			end as Cntry 
		from bronze.erp_LOC_A101
		Set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';

		set @start_time = GETDATE();
		Print '>> Truncating silver.erp_PX_CAT_G1V2'
		Truncate Table silver.erp_PX_CAT_G1V2;
		Print '>> Inserting data into silver.erp_PX_CAT_G1V2'
		Insert into silver.erp_PX_CAT_G1V2(id, cat, subcat, maintenance)
		select
			id,
			cat,
			subcat,
			maintenance
		from bronze.erp_PX_CAT_G1V2
		Set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';
		Print '------------------------------------------------------------';
		set @batch_end_time = GETDATE();
		Print 'Silver layer has been loaded';
		Print '>> Load duration for entire silver layer: '+Cast(DateDiff(second, @batch_start_time, @batch_end_time) as NVARCHAR)+' seconds.';
		Print '===========================================================';
	End Try
	Begin Catch
		Print '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++';
		Print 'Error occured during loading silver layer';
		Print 'Error message: ' +error_message();
		Print 'Error message: ' +cast(error_number() as NVARCHAR);
		Print 'Error message: ' +cast(error_state() as NVARCHAR);
		Print '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++';
	End Catch
End
