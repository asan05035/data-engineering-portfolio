# Naming Conventions

This document defines the naming conventions followed across this project, covering databases, schemas, tables, columns, and stored procedures. Consistent naming makes the data model easier to navigate, maintain, and understand across teams.

---

## 1. General Principles

- Use **snake_case** for all names (lowercase words separated by underscores) — e.g. `customer_name`, `order_date`.
- Avoid using reserved words or object type names as column or table names.
  - ❌ `column`, `table`
  - ✅ `column_name`, `table_name`
- Names should be descriptive and business-friendly, avoiding unnecessary abbreviations.

---

## 2. Table Naming Conventions

### Bronze Layer
Raw, ingested data. Tables should indicate **where** the data comes from and **what** it represents.

```
<source_system>_<entity>
```

| Component | Description |
|---|---|
| `source_system` | Name of the source system the data originates from |
| `entity` | Name of the entity/table as represented in the source |

**Example:** `crm_customers`, `erp_sales_orders`

---

### Silver Layer
Cleaned and standardized data. Follows the same structure as the Bronze layer.

```
<source_system>_<entity>
```

| Component | Description |
|---|---|
| `source_system` | Name of the source system the data originates from |
| `entity` | Name of the entity/table, aligned with the source structure |

**Example:** `crm_customers`, `erp_sales_orders`

---

### Gold Layer
Business-ready, consumption-layer data. Tables are named according to their **role** and **business domain**.

```
<category>_<entity>
```

| Component | Description |
|---|---|
| `category` | Describes the role of the table (e.g. `fact`, `dim`, `agg`) |
| `entity` | Descriptive name aligned with the business domain |

**Common categories:**
- `fact_` — Fact tables (e.g. `fact_sales`)
- `dim_` — Dimension tables (e.g. `dim_customer`)
- `agg_` — Aggregated tables (e.g. `agg_monthly_revenue`)

**Example:** `fact_sales`, `dim_customer`, `agg_monthly_revenue`

---

## 3. Column Naming Conventions

### Surrogate Keys
Any column that serves as a **primary key** must end with the suffix `_key`.

**Example:** `customer_key`, `product_key`

### Technical Columns
Any column used for **technical/metadata purposes** (not business data) must start with the prefix `dwh_`.

**Example:** `dwh_load_date`, `dwh_source_system`, `dwh_batch_id`

---

## 4. Stored Procedure Naming Conventions

Stored procedures used to **load data** must follow the pattern:

```
load_<purpose>
```

| Component | Description |
|---|---|
| `purpose` | The specific purpose or target the procedure serves |

**Example:** `load_bronze_crm_customers`, `load_silver_sales_orders`

---

## 5. Quick Reference Summary

| Object Type | Convention | Example |
|---|---|---|
| Bronze table | `<source_system>_<entity>` | `crm_customers` |
| Silver table | `<source_system>_<entity>` | `erp_sales_orders` |
| Gold table | `<category>_<entity>` | `fact_sales` |
| Surrogate key column | `<column_name>_key` | `customer_key` |
| Technical column | `dwh_<column_name>` | `dwh_load_date` |
| Load stored procedure | `load_<purpose>` | `load_bronze_crm_customers` |
