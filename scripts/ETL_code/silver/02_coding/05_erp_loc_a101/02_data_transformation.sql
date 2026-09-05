WITH base_query AS 
(SELECT 
	REPLACE(cid, '-', '') AS cid, -- Cleaning data in cid for data integration
	CASE 
		WHEN TRIM(cntry) IN ('DE', 'Germany') THEN 'Germany'
		WHEN TRIM(cntry) IN ('USA, United States', 'US') THEN 'United States'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry			-- Data standardisation and consistenscy
FROM bronze.erp_loc_a101)

INSERT INTO silver.erp_loc_a101(cid, cntry)
SELECT 
	cid, 
	cntry
FROM base_query
