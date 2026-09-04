/*
===============================================
Quality check : 
			- Invalid date
			- Invalid order date
			- Buiness rules: sales = price * quantity
===============================================
*/


-- QC_1: Check for invalid date
SELECT 
	NULLIF(s.sls_order_dt, 0),
	s.sls_order_dt
FROM bronze.crm_sales_details AS s
WHERE s.sls_order_dt <= 0 
OR LEN(s.sls_order_dt) != 8
OR s.sls_order_dt > 20500101
OR s.sls_order_dt < 19000101


SELECT 
	s.sls_ship_dt
FROM bronze.crm_sales_details AS s
WHERE s.sls_ship_dt <= 0
OR LEN(s.sls_ship_dt) != 8
OR s.sls_ship_dt > 20500101
OR s.sls_ship_dt < 19000101


SELECT 
	s.sls_due_dt
FROM bronze.crm_sales_details AS s
WHERE s.sls_due_dt <= 0
OR LEN(s.sls_due_dt) != 8
OR s.sls_due_dt > 20500101
OR s.sls_due_dt < 19000101


-- QC_2: Check for invalid Date orders
SELECT 
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt
FROM (SELECT 
	CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
		END as sls_order_dt,
	CASE WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		 END as sls_ship_dt,
	CASE WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		 END as sls_due_dt
FROM bronze.crm_sales_details AS s) t
WHERE sls_order_dt > sls_ship_dt
OR sls_order_dt > sls_due_dt

-- QC_3: Business rules
	-- Check for data consistency: between sales, quantity and price
	-- Sales = price * quantity
	-- values must not be negative, null or zero

-- Baara's approach
SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL
OR sls_sales <= 0 OR sls_price <= 0 OR sls_quantity <= 0
ORDER BY 	sls_sales,sls_quantity,sls_price

-- Solution
SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price,
	CASE
		WHEN sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
		WHEN sls_price < 0 THEN ABS(sls_price)
		ELSE sls_price
	END AS new_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL
OR sls_sales <= 0 OR sls_price <= 0 OR sls_quantity <= 0
ORDER BY sls_price

SELECT DISTINCT
	sls_sales,
	CASE 
		WHEN sls_sales IS NULL
			OR sls_sales <= 0 
			OR sls_sales != ABS(sls_quantity * sls_price) THEN ABS(sls_quantity * sls_price)
		ELSE sls_sales
	END AS new_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL
OR sls_sales <= 0 OR sls_price <= 0 OR sls_quantity <= 0
ORDER BY 	sls_sales,sls_quantity,sls_price




