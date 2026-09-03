SELECT *
FROM silver.crm_prd_info


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