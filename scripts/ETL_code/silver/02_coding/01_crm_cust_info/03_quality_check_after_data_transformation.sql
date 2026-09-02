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
