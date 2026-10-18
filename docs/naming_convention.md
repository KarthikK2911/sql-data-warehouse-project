# Naming Conventions

This document defines the naming standards used throughout the data warehouse project.

## General Principles

- Use `snake_case`.
- Use lowercase letters.
- Separate words with underscores (`_`).
- Use English names.
- Avoid SQL reserved words.

## Table Naming Conventions

### Bronze Layer

Use the source system followed by the original entity name.

**Pattern:**

`<source_system>_<entity>`

Examples:

- `crm_cust_info`
- `crm_prd_info`
- `crm_sales_details`
- `erp_cust_az12`
- `erp_loc_a101`
- `erp_px_cat_g1v2`

### Silver Layer

Keep the same source-oriented naming convention used in the Bronze layer.

**Pattern:**

`<source_system>_<entity>`

Example:

`crm_cust_info`

### Gold Layer

Use meaningful business names beginning with a category prefix.

**Pattern:**

`<category>_<entity>`

Examples:

- `dim_customers`
- `dim_products`
- `fact_sales`

### Gold Category Prefixes

| Prefix | Meaning | Example |
|---|---|---|
| `dim_` | Dimension table | `dim_customers` |
| `fact_` | Fact table | `fact_sales` |
| `agg_` | Aggregated table | `agg_sales_monthly` |

## Column Naming Conventions

### Surrogate Keys

Dimension surrogate keys should end with `_key`.

**Pattern:**

`<entity>_key`

Examples:

- `customer_key`
- `product_key`

### Technical Columns

Warehouse-generated metadata columns should start with `dwh_`.

**Pattern:**

`dwh_<column_name>`

Example:

`dwh_create_date`

## Stored Procedures

Procedures used to load warehouse layers should follow:

`load_<layer>`

Examples:

- `load_bronze`
- `load_silver`
