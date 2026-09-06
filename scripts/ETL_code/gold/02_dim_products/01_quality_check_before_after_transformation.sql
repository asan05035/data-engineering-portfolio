SELECT 
	product_key,
	product_id,
	product_number,
	product_name,
	category_id,
	category,
	subcategory,
	maintenance,
	product_cost,
	product_line,
	start_date
FROM gold.dim_products

-- Checking duplicates in primary key

SELECT 
	product_id,
	COUNT(*)
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1