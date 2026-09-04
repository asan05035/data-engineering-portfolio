WITH base_query AS (
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
FROM bronze.erp_cust_az12)

INSERT INTO silver.erp_cust_az12(cid, bdate, gen)
SELECT 
	cid,
	bdate,
	gen
FROM base_query
