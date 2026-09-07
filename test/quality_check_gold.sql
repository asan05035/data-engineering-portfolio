/*
===============================================
Quality checks
==============================================
Script Purpose
    - These script are used to check the quality in gold layer
    - Dulpiactes and uniqueness in Primary key
    - Foreign key integrity
    - Data standarisation and consistency

Usage Notes:
    -  Run these check if any discrepancies found during check resolve it

*/



-- =========================
-- Checking 'gold.dim_customers'
-- =========================

-- Check for any duplicates 
SELECT	
	customer_id,
	COUNT(*)
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1

-- Data standaridation and consistency
SELECT	
	DISTINCT gender
FROM gold.dim_customers


-- ==================================
-- Checking 'gold.dim_products'
-- ==================================

-- Checking duplicates in primary key

SELECT 
	product_id,
	COUNT(*)
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1


-- ===============================
-- Checking 'gold.fact_sales'
-- ===============================

-- Check Foreign key integrity (Dimensions)
-- Check if all dimensions can be joined fact table sucessfully

SELECT 
    order_number,
	product_key,
	customer_key,
    order_date,
    shipping_date,
    due_date,
    sales_amount,
    quantity,
    price
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
WHERE c.customer_key IS NULL 
OR p.product_key IS NULL