SELECT TOP (1000) [prd_id]
      ,[prd_key]
      ,[prd_nm]
      ,[prd_cost]
      ,[prd_line]
      ,[prd_start_dt]
      ,[prd_end_dt]
  FROM [DataWarehouse].[bronze].[crm_prd_info]

  /*
  ============================================
  Quality check 1: Check for duplicates or null in primary key
  Expectation: No result

  to-do: Ensure only one record per entity 
  =================================================
  */
  SELECT prd_id, COUNT(*)
  FROM bronze.crm_prd_info
  GROUP BY prd_id
  HAVING COUNT(*) > 1 OR prd_id IS NULL


  /*
  =================================================
  Quality check 2: No unwanted spcaes in string column to mantain consistency
  expectation: No result

  to-do: use rowlevel functions(string function)
  =================================================
  */

  SELECT prd_key
  FROM bronze.crm_prd_info
  WHERE prd_key != TRIM(prd_key)    -- NOT prd_key = TRIM(prd_key)


  SELECT prd_nm
  FROM bronze.crm_prd_info
  WHERE prd_nm != TRIM(prd_nm) 

  /*
  =============================================
  Quality check 3: Data normalization 
  Expectation: User-friendly description

  to-do: Mappping coded data into user friednly data using case..when
  ==============================================
  */


SELECT DISTINCT prd_line FROM bronze.crm_prd_info


/*
=============================================
Quality check 4: Check for null or negative numbers 
Expectation: No result
=============================================
*/


SELECT prd_cost FROM bronze.crm_prd_info WHERE prd_cost < 0 OR prd_cost


/*
==============================================
Quality check 6: Check for invalid date orders
===============================================
*/
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt


SELECT prd_start_dt,
    LEAD(prd_start_dt, 1) OVER (PARTITION BY prd_id, prd_key ORDER BY prd_start_dt ASC) prd_end_dt
FROM bronze.crm_prd_info
 