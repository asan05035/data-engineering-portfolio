CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN 

	PRINT '>> Truncating the table silver.crm_cust_info'
	TRUNCATE TABLE silver.crm_cust_info
	PRINT '>> Inserting the data into silver.crm_cust_info'
	INSERT INTO silver.crm_cust_info (cst_id
		  ,cst_key
		  ,cst_firstname
		  ,cst_lastname
		  ,cst_marital_status
		  ,cst_gndr
		  ,cst_create_date)
	SELECT 
		  cst_id
		 ,cst_key
		 ,TRIM(cst_firstname) AS cst_firstname
		 ,TRIM(cst_lastname) AS cst_lastname
		 ,CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				ELSE 'n/a'
			END AS cst_marital_status -- Normalize the marital status to readable format
		 ,CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				ELSE 'n/a'
			END AS cst_gndr -- Normalize the gender to readable format
		 ,cst_create_date
	FROM (  -- Subquery which applies row number to each row to identify duplicates
			SELECT 
				   cst_id
				  ,cst_key
				  ,cst_firstname
				  ,cst_lastname
				  ,cst_marital_status
				  ,cst_gndr
				  ,cst_create_date,
				  ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last 
			  FROM DataWarehouse.bronze.crm_cust_info) t
	WHERE flag_last = 1 AND cst_id IS NOT NULL



	PRINT '>> Truncating the table silver.crm_prd_info'
	TRUNCATE TABLE silver.crm_prd_info
	PRINT '>> Insertinf the data into silver.crm_prd_info'
	INSERT INTO silver.crm_prd_info
	(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	)
	SELECT
		  prd_id,
		  REPLACE(SUBSTRING(TRIM(prd_key), 1, 5),'-' ,'_' ) AS cat_id, -- Data standardidation & consistency
		  SUBSTRING(TRIM(prd_key), 7, LEN(prd_key)) AS prd_key,
		  prd_nm,
		  COALESCE(prd_cost, 0) AS prd_cost,  -- Handling  nulls for analytics
		  CASE UPPER(TRIM(prd_line))          -- Data standardisation * data consistency
			  WHEN 'M' THEN 'Mountain' 
			  WHEN 'R' THEN 'Road'
			  WHEN 'S' THEN 'Other Sales'
			  WHEN 'T' THEN 'Touring'
			  ELSE 'n/a'
		  END AS prd_line,
		  CAST(prd_start_dt AS DATE) AS prd_start_dt,
		  DATEADD(DAY, -1, CAST(LEAD(prd_start_dt, 1) OVER (PARTITION BY REPLACE(SUBSTRING(TRIM(prd_key), 1, 5),'-' ,'_' ), prd_key 
										ORDER BY prd_start_dt ASC) AS DATE)) AS prd_end_dt -- Handling invalid dates
	FROM DataWarehouse.bronze.crm_prd_info

	PRINT '>> Truncating the table silver.crm_sales_details'
	TRUNCATE TABLE silver.crm_sales_details
	PRINT '>> Inserting data into silver.crm_sales_details'
	INSERT INTO silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price)
	SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		-- Handling invalid dates
		CASE WHEN CAST(sls_order_dt AS INT) <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
			ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END as sls_order_dt,
		CASE WHEN CAST(sls_ship_dt AS INT) <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
			 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			 END as sls_ship_dt,
		CASE WHEN CAST(sls_due_dt AS INT) <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
			 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			 END as sls_due_dt,
		-- Data standarisation: using business rules 
		CASE 
			WHEN sls_sales IS NULL
				OR sls_sales <= 0 
				OR sls_sales != ABS(sls_quantity * sls_price) THEN ABS(sls_quantity * sls_price)
			ELSE sls_sales
		END AS sls_sales,
		CASE
			WHEN sls_quantity IS NULL THEN sls_sales / NULLIF(sls_price, 0)
			WHEN sls_quantity < 0 THEN ABS(sls_quantity)
			ELSE sls_quantity
		END AS sls_quantity,
		CASE
			WHEN sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
			WHEN sls_price < 0 THEN ABS(sls_price)
			ELSE sls_price
		END AS sls_price
	FROM bronze.crm_sales_details

	PRINT '>> Truncating the table silver.erp_cust_az12'
	TRUNCATE TABLE silver.erp_cust_az12
	PRINT '>> Inserting data into silver.erp_cust_az12'
	INSERT INTO silver.erp_cust_az12(cid, bdate, gen)
	SELECT 
		CASE 
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(TRIM(cid), 4, LEN(TRIM(cid)))
			ELSE cid
		END cid	,						-- Remover 'NAS' prefix if present
		CASE WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
		END bdate,						-- set future birthdate to null
		CASE 
			WHEN UPPER(TRIM(gen)) IN ('F', 'Female') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('M', 'Male') THEN 'Male'
			ELSE 'n/a'					-- Normalize gender values and handle unknown cases
		END AS gen
	FROM bronze.erp_cust_az12

	PRINT '>> Truncating the table silver.erp_loc_a101'
	TRUNCATE TABLE silver.erp_loc_a101
	PRINT '>> Inserting data into silver.erp_loc_a101'
	INSERT INTO silver.erp_loc_a101(cid, cntry)
	SELECT 
		REPLACE(cid, '-', '') AS cid, -- Cleaning data in cid for data integration
		CASE 
			WHEN TRIM(cntry) IN ('DE', 'Germany') THEN 'Germany'
			WHEN TRIM(cntry) IN ('USA, United States', 'US') THEN 'United States'
			WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
			ELSE TRIM(cntry)
		END AS cntry			-- Data standardisation and consistenscy
	FROM bronze.erp_loc_a101

	PRINT '>> Truncating the table silver.erp_px_cat_g1v2'
	TRUNCATE TABLE silver.erp_px_cat_g1v2
	PRINT '>> Inserting the data into silver.erp_px_cat_g1v2'
	INSERT INTO silver.erp_px_cat_g1v2(id, cat, subcat, maintenance)
	SELECT 
		id,
		cat,
		subcat,
		maintenance
	FROM bronze.erp_px_cat_g1v2

END