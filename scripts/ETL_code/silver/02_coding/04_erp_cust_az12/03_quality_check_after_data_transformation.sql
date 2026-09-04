-- QC Data integration
SELECT cid FROM silver.erp_cust_az12 WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)



-- QC Identify out of range date
SELECT  bdate FROM silver.erp_cust_az12 WHERE bdate > GETDATE()



-- QC: Data stardisation
SELECT 
	DISTINCT gen
FROM  silver.erp_cust_az12