/*
==============================
Analyze: Explore the data in Bronze layers
==============================
Script:
	This script purpose is used to explore and analyze data in each tabble in bronze schema
	- Document and visualize how the tables are related
	- Identify historization
	- Columns used to join tables
	- Extra information can be gained

-----------------------------------------------------
*/



-- Table: crm_cust_info
-- Soucre: crm  -> bronze 
SELECT TOP (1000) *
FROM [DataWarehouse].[bronze].[crm_cust_info]


-- Table: crm_prd_info
-- source: crm -> bronze
SELECT TOP (1000) *
FROM [DataWarehouse].[bronze].[crm_prd_info]

-- Table: crm_sales_details
-- source: crm -> bronze
SELECT TOP (1000) *
FROM [DataWarehouse].[bronze].[crm_sales_details]


-- Table: erp_cust_az12
-- source: erp -> bronze
SELECT TOP (1000) *
FROM [DataWarehouse].[bronze].[erp_cust_az12]

-- Table: erp_loc_a101
-- source: erp -> bronze
SELECT TOP (1000) *
FROM [DataWarehouse].[bronze].[erp_loc_a101]

-- Table: erp_px_cat_g1v2
-- source: erp -> bronze
SELECT TOP (1000) *
FROM [DataWarehouse].[bronze].[erp_px_cat_g1v2]





