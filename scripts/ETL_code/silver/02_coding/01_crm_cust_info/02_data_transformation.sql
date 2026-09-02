INSERT INTO silver.crm_cust_info (cst_id
      ,cst_key
      ,cst_firstname
      ,cst_lastname
      ,cst_marital_status
      ,cst_gndr
      ,cst_create_date)
SELECT 
      cst_id
     ,cst_key
     ,TRIM(cst_firstname) AS cst_firstname
     ,TRIM(cst_lastname) AS cst_lastname
     ,CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            ELSE 'n/a'
        END AS cst_marital_status -- Normalize the marital status to readable format
     ,CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            ELSE 'n/a'
        END AS cst_gndr -- Normalize the gender to readable format
     ,cst_create_date
FROM (  -- Subquery which applies row number to each row to identify duplicates
        SELECT 
               cst_id
              ,cst_key
              ,cst_firstname
              ,cst_lastname
              ,cst_marital_status
              ,cst_gndr
              ,cst_create_date,
              ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last 
          FROM DataWarehouse.bronze.crm_cust_info) t
WHERE flag_last = 1 AND cst_id IS NOT NULL
