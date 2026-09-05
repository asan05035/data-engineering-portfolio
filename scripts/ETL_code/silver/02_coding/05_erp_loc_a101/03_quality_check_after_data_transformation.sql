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