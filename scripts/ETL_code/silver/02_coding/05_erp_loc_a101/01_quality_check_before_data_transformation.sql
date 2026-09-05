USE DataWarehouse;
GO


-- Data integration
SELECT REPLACE(cid, '-', '') AS cid, cntry 
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN 
(SELECT cst_key FROM silver.crm_cust_info)


-- Data consistency in low cardinality columns
SELECT DISTINCT 
	cntry,
	CASE 
		WHEN TRIM(cntry) IN ('DE', 'Germany') THEN 'Germany'
		WHEN TRIM(cntry) IN ('USA, United States', 'US') THEN 'United States'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
	END AS Cntry
FROM bronze.erp_loc_a101