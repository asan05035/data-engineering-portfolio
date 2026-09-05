WITH base_query AS (
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
		END as sls_order_dt,
	CASE WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		 END as sls_ship_dt,
	CASE WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		 END as sls_due_dt,
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
FROM bronze.crm_sales_details )

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
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM base_query
