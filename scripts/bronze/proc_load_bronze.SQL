/*
=====================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=====================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;

=====================================================================
*/

Create or Alter Procedure bronze.load_bronze as
Begin
	Declare @start_time datetime, @end_time datetime, @start_time1 datetime,
	@end_time1 datetime;
	Begin Try
		set @start_time1 = GETDATE();
		Print '***************************************************************';
		Print 'Loading bronze layer';
		Print '***************************************************************';

		Print '---------------------------------------------------------------';
		Print 'Loading CRM Tables';
		Print '---------------------------------------------------------------';
		set @start_time = GETDATE();
		Print '>> Truncating Table: bronze.crm_cust_info';
		Truncate Table bronze.crm_cust_info;
		Print '>> Inserting data into table: bronze.crm_cust_info';
		Bulk insert bronze.crm_cust_info
		from 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with(
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';
		Print '===========================================================';

		set @start_time = GETDATE();
		Print '>> Truncating Table: bronze.crm_prd_info';
		Truncate Table bronze.crm_prd_info;
		Print '>> Inserting data into table: bronze.crm_prd_info';
		Bulk insert bronze.crm_prd_info
		from 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';
		Print '===========================================================';

		set @start_time = GETDATE();
		Print '>> Truncating Table: bronze.crm_sales_details';
		Truncate Table bronze.crm_sales_details;
		Print '>> Inserting data into table: bronze.crm_sales_details';
		Bulk insert bronze.crm_sales_details
		from 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';
		Print '===========================================================';

		Print '---------------------------------------------------------------';
		Print 'Loading ERP Tables';
		Print '---------------------------------------------------------------';
		set @start_time = GETDATE();
		Print '>> Truncating Table: bronze.erp_CUST_AZ12';
		Truncate Table bronze.erp_CUST_AZ12;
		Print '>> Inserting data into table: bronze.erp_CUST_AZ12';
		Bulk insert bronze.erp_CUST_AZ12
		from 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';
		Print '===========================================================';

		set @start_time = GETDATE();
		Print '>> Truncating Table: bronze.erp_LOC_A101';
		Truncate Table bronze.erp_LOC_A101;
		Print '>> Inserting data into table: bronze.erp_LOC_A101';
		Bulk insert bronze.erp_LOC_A101
		from 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with(
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';
		Print '===========================================================';

		set @start_time = GETDATE();
		Print '>> Truncating Table: bronze.erp_PX_CAT_G1V2';
		Truncate Table bronze.erp_PX_CAT_G1V2;
		Print '>> Inserting data into table: bronze.erp_PX_CAT_G1V2';
		Bulk insert bronze.erp_PX_CAT_G1V2
		from 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
			Firstrow = 2,
			Fieldterminator = ',',
			Tablock
		);
		set @end_time = GETDATE();
		Print '>> Load duration: '+Cast(DateDiff(second, @start_time, @end_time) as NVARCHAR)+' seconds.';
		Print '===========================================================';
		set @end_time1 = GETDATE();
		Print '>> Load duration for entire bronze layer: '+Cast(DateDiff(second, @start_time1, @end_time1) as NVARCHAR)+' seconds.';
		Print '===========================================================';
	End Try
	Begin Catch
		Print '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++';
		Print 'Error occured during loading bronze layer';
		Print 'Error message: ' +error_message();
		Print 'Error message: ' +cast(error_number() as NVARCHAR);
		Print 'Error message: ' +cast(error_state() as NVARCHAR);
		Print '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++';
	End Catch
End
