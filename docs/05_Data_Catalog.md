# Enterprise Data Catalog: Gold Layer

## Table of Contents
1. [Introduction]
2. [gold.dim_customers]
3. [gold.dim_products]
4. [gold.fact_sales]

---

## 1. Introduction
This enterprise data catalog documents the core tables and views within the **Gold layer** of the data warehouse. The Gold layer contains cleaned, business-ready, dimensional and transactional data utilized for enterprise reporting, analytics, and data science initiatives.

---

## 2. gold.dim_customers

### Overview
The `gold.dim_customers` table is a core dimension table in the enterprise data warehouse (Gold layer). It contains cleaned, integrated, and business-ready customer demographic data 

### Table Purpose
This table serves as the primary source of truth for customer-centric analysis.
### Column Dictionary

| Column Name | Data Type | Purpose / Description | Example |
| :--- | :--- | :--- | :--- |
| **`customer_key`** | `INT` | Surrogate key generated for the each record in the dimension table. | `482` |
| **`customer_id`** | `NVARCHAR` | Unique numeric identifier or UUID for the customer. | `98231` |
| **`customer_number`** | `VARCHAR` | Human-readable account or reference number assigned to the customer. | `NUM-40592` |
| **`first_name`** | `NVARCHAR(50)` | The customer's given or first name. | `Jane` |
| **`last_name`** | `NVARCHAR(50)` | The customer's family or last name. | `Doe` |
| **`country`** | `NVARCHAR(50)` | The country of residence for the customer. | `United States` |
| **`marital_status`** | `NVARCHAR(50)` | The customer's marital status (e.g., Single, Married). | `Single` |
| **`gender`** | `NVARCHAR(50)` | The reported gender of the customer. | `Female`,  `Male`|
| **`birthdate`** | `DATE` | The date of birth of the customer, used for age calculations. | `1985-06-15` |
| **`create_date`** | `DATE` | The date when the customer record was first created in the system. | `2023-01-10` |

---

## 3. gold.dim_products

### Overview
The `gold.dim_products` table is a core dimension table located in the Gold layer of the data warehouse. It stores standardized, cleaned, and enriched product attribute data used for inventory, sales performance, and profitability analysis.

### Table Purpose
This table acts as the definitive reference for all products sold or managed by the business. 
### Column Dictionary

| Column Name | Data Type | Purpose / Description | Example |
| :--- | :--- | :--- | :--- |
| **`product_key`** | `INT` | Surrogate key generated for each record in the dimesnion table. | `5012` |
| **`product_id`** | `INT` | Unique source system identifier or UUID for the product. | `PROD-8832` |
| **`product_number`** | `NVARCHAR(50)` | Stock Keeping Unit (SKU) or part number. | `SKU-BL-9920` |
| **`product_name`** | `NVARCHAR(50)` | The commercial name of the product. | `Mountain-100 Black, 44` |
| **`category_id`** | `INT` | Unique identifier linking to the product category group. | `3` |
| **`category`** | `NVARCHAR(50)` | The primary or high-level classification of the product. | `Bikes` |
| **`subcategory`** | `NVARCHAR(50)` | A more granular sub-classification under the main category. | `Mountain Bikes` |
| **`maintenance`** | `NVARCHAR(50)` | Indicates maintenance requirements, schedule, or status for the product. | `Low` |
| **`product_cost`** | `INT` | The standard unit cost to produce or acquire the product. | `1250` |
| **`product_line`** | `NVARCHAR(50)` | The product line or series classification (e.g., Mountain, Road). | `M` |
| **`start_date`** | `DATE` | The date from which this product record or version became active. | `2021-01-01` |

---

## 4. gold.fact_sales

### Overview
The `gold.fact_sales` view is a core fact table in the Gold layer of the enterprise data warehouse. It captures transactional sales event data, connecting business operations to dimensional attributes such as customers (`customer_key`) and products (`product_key`).

### Table Purpose
This table serves as the primary analytical engine for revenue, sales volume, and order performance reporting. 

### Column Dictionary

| Column Name | Data Type | Purpose / Description | Example |
| :--- | :--- | :--- | :--- |
| **`order_number`** | `NVARCHAR(50)` | Unique transaction or order reference number. | `SO43659` |
| **`product_key`** | `INT` | Foreign key linking to the `gold.dim_products` dimension. | `5012` |
| **`customer_key`** | `INT` | Foreign key linking to the `gold.dim_customers` dimension. | `10482` |
| **`order_date`** | `DATE` | The date when the sales order was placed. | `2023-05-12` |
| **`shipping_date`** | `DATE` | The date when the order was fulfilled and shipped. | `2023-05-15` |
| **`due_date`** | `DATE` | The target date for payment or final delivery. | `2023-05-24` |
| **`sales_amount`** | `INT` | Total monetary value of the line item (Quantity $\times$ Price). | `3578.27` |
| **`quantity`** | `INT` | The number of product units ordered in the transaction. | `2` |
| **`price`** | `INT` | The unit selling price of the product at the time of sale. | `1789.14` |