SELECT 
	cid,
	bdate,
	gen
FROM bronze.erp_cust_az12

/*=================================
Quality check_1 : data normalization
Mapping coded value to user friendly values
===================================
*/
SELECT DISTINCT gen FROM bronze.erp_cust_az12


SELECT 
	DISTINCT 
	CASE 
		WHEN UPPER(TRIM(gen)) = 'F' OR UPPER(TRIM(gen)) = 'FEMALE' THEN 'Female'
		WHEN UPPER(TRIM(gen)) = 'M' OR UPPER(TRIM(gen)) = 'MALE' THEN 'Male'
		ELSE NULL
	END AS gen
FROM bronze.erp_cust_az12



SELECT cid 
FROM bronze.erp_cust_az12
WHERE cid LIKE '%AW0001%'



SELECT cst_key FROM silver.crm_cust_info;

/*================================
Quality check_2: Invalid Birth date
				 Idenitfy out of date range
==============================
*/
-- Old date & future data
SELECT * FROM bronze.erp_cust_az12 WHERE bdate < '1920-01-01' OR bdate > GETDATE()
