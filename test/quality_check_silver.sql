/*
===============================================
Quality checks
==============================================
Script Purpose
    - These script are used to check the quality in silver layer
    - Dulpiactes and uniqueness in Primary key
    - 
    - Data standarisation and consistency

Usage Notes:
    -  Run these check if any discrepancies found during check resolve it

*/

-- ====================================================
-- Checking 'silver.crm_cust_info'
-- =====================================================
/* 
==============================================================
-- Quality Check 1: Identify duplicates and NUlls in Primary key
-- Expectation: No result

-- To-do : Ensure the only one record per entity by identify and 
			pick the one you want using window functions
==============================================================
*/
SELECT cst_id,
	COUNT(*) AS no_of_times
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

/*
==========================================================================
-- Quality check 2: Unwanted spaces in string values to ensure consistency
-- Expectation: No result

-- To-do: Using TRIM() function t remove the leading and triling spaces
===========================================================================
*/


SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

/*
=====================================================================
-- Quality check 3: Data normalisation and standardisation
-- Expectation: User friendly values in low cardinality columns(low distinct values)

-- To-do: Mapping the coded value to user friendly values
=====================================================================
*/

-- Identify the unique values in customer gender column
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

-- Idenitfy the unique values in marital status column
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

-- ====================================================
-- Checking 'silver.crm_prd_info'
-- =====================================================

  /*
  ============================================
  Quality check 1: Check for duplicates or null in primary key
  Expectation: No result

  to-do: Ensure only one record per entity 
  =================================================
  */
  SELECT prd_id, COUNT(*)
  FROM silver.crm_prd_info
  GROUP BY prd_id
  HAVING COUNT(*) > 1 OR prd_id IS NULL

  
  /*
  =============================================
  Quality check 3: Data normalization 
  Expectation: User-friendly description

  to-do: Mappping coded data into user friednly data using case..when
  ==============================================
  */


SELECT DISTINCT prd_line FROM silver.crm_prd_info

/*
=============================================
Quality check 4: Check for null or negative numbers 
Expectation: No result
=============================================
*/


SELECT prd_cost FROM silver.crm_prd_info WHERE prd_cost < 0 OR prd_cost IS NULL



/*
==============================================
Quality check 6: Check for invalid date orders
===============================================
*/
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt




-- ====================================================
-- Checking 'silver.crm_sales_details'
-- =====================================================


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



-- ====================================================
-- Checking 'silver.erp_cust_az12'
-- =====================================================

-- QC Data integration
SELECT cid FROM silver.erp_cust_az12 WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)

-- QC Identify out of range date
SELECT  bdate FROM silver.erp_cust_az12 WHERE bdate > GETDATE()

-- QC: Data stardisation
SELECT 
	DISTINCT gen
FROM  silver.erp_cust_az12


-- ====================================================
-- Checking 'silver.erp_loc_a101'
-- =====================================================
SELECT 
	cid,
	cntry
FROM silver.erp_loc_a101


-- Data integration
SELECT 
	cid,
	cntry
FROM silver.erp_loc_a101
WHERE cid NOT IN (SELECT c.cst_key FROM silver.crm_cust_info AS c)


-- Data standarisation and consistency
SELECT 
	DISTINCT cntry
FROM silver.erp_loc_a101



-- ====================================================
-- Checking 'silver.erp_cat_g1v2'
-- =====================================================

-- Check for unwanted spaces
SELECT 
	id,
	cat,
	subcat,
	maintenance
FROM bronze.erp_px_cat_g1v2
WHERE cat ! = TRIM(cat)
OR subcat != TRIM(subcat)
OR maintenance != TRIM(maintenance)


-- Data standardisation & consistency
SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2


SELECT *
FROM silver.erp_px_cat_g1v2

