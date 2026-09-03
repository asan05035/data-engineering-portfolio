INSERT INTO silver.crm_prd_info
(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
SELECT TOP (1000) 
      prd_id,
      --prd_key,
      REPLACE(SUBSTRING(TRIM(prd_key), 1, 5),'-' ,'_' ) AS cat_id,
      SUBSTRING(TRIM(prd_key), 7, LEN(prd_key)) AS prd_key,
      prd_nm,
      COALESCE(prd_cost, 0) AS prd_cost,
      CASE UPPER(TRIM(prd_line))
          WHEN 'M' THEN 'Mountain' 
          WHEN 'R' THEN 'Road'
          WHEN 'S' THEN 'Other Sales'
          WHEN 'T' THEN 'Touring'
          ELSE 'n/a'
      END AS prd_line,
      CAST(prd_start_dt AS DATE) AS prd_start_dt,
      --prd_end_dt
      CAST(LEAD(prd_start_dt, 1) OVER (PARTITION BY REPLACE(SUBSTRING(TRIM(prd_key), 1, 5),'-' ,'_' ), prd_key 
                                    ORDER BY prd_start_dt ASC) - 1 AS DATE) AS prd_end_dt
FROM DataWarehouse.bronze.crm_prd_info

