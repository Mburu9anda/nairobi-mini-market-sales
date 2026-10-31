-- Run after importing clean_sales_2025.csv into mini_market.sales_staging.
-- Lookup tables hold descriptions; sales holds one row per product line.

CREATE SCHEMA IF NOT EXISTS mini_market;

CREATE TABLE IF NOT EXISTS mini_market.stores (
    store_id TEXT PRIMARY KEY,
    store_name TEXT NOT NULL,
    county TEXT NOT NULL,
    population_2019 INTEGER,
    location TEXT
);

CREATE TABLE IF NOT EXISTS mini_market.products (
    product_id TEXT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS mini_market.customers (
    customer_id TEXT PRIMARY KEY,
    customer_type TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS mini_market.sales (
    sale_line_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sale_date DATE NOT NULL,
    transaction_id TEXT NOT NULL,
    store_id TEXT NOT NULL REFERENCES mini_market.stores(store_id),
    customer_id TEXT NOT NULL REFERENCES mini_market.customers(customer_id),
    product_id TEXT NOT NULL REFERENCES mini_market.products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price_kes NUMERIC(12, 2) NOT NULL CHECK (unit_price_kes > 0),
    promotion_pct NUMERIC(5, 2) NOT NULL CHECK (promotion_pct BETWEEN 0 AND 100),
    gross_sales_kes NUMERIC(12, 2) NOT NULL,
    discount_kes NUMERIC(12, 2) NOT NULL,
    net_sales_kes NUMERIC(12, 2) NOT NULL,
    payment_method TEXT NOT NULL
);

-- Clear old project rows in child-to-parent order so the script can be rerun.
DELETE FROM mini_market.sales;
DELETE FROM mini_market.customers;
DELETE FROM mini_market.products;
DELETE FROM mini_market.stores;

INSERT INTO mini_market.stores (store_id, store_name, county, population_2019, location)
SELECT DISTINCT store_id, store_name, county, population_2019, location
FROM mini_market.sales_staging;

INSERT INTO mini_market.products (product_id, product_name, category)
SELECT DISTINCT product_id, product_name, category
FROM mini_market.sales_staging;

INSERT INTO mini_market.customers (customer_id, customer_type)
SELECT DISTINCT customer_id, customer_type
FROM mini_market.sales_staging;

INSERT INTO mini_market.sales (
    sale_date, transaction_id, store_id, customer_id, product_id,
    quantity, unit_price_kes, promotion_pct, gross_sales_kes,
    discount_kes, net_sales_kes, payment_method
)
SELECT
    sale_date, transaction_id, store_id, customer_id, product_id,
    quantity, unit_price_kes, promotion_pct, gross_sales_kes,
    discount_kes, net_sales_kes, payment_method
FROM mini_market.sales_staging;

-- These counts confirm that the CSV was loaded into the four analysis tables.
SELECT 'sales' AS table_name, COUNT(*) AS row_count FROM mini_market.sales
UNION ALL
SELECT 'stores', COUNT(*) FROM mini_market.stores
UNION ALL
SELECT 'products', COUNT(*) FROM mini_market.products
UNION ALL
SELECT 'customers', COUNT(*) FROM mini_market.customers
ORDER BY table_name;
