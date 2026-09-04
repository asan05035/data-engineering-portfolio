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
	s.sls_order_dt
FROM silver.crm_sales_details AS s
WHERE s.sls_order_dt IS NULL


-- QC_2: Check for invalid Date orders
SELECT 
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt
FROM silver.crm_sales_details
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
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL
OR sls_sales <= 0 OR sls_price <= 0 OR sls_quantity <= 0
ORDER BY 	sls_sales,sls_quantity,sls_price

