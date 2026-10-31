-- Run this first in your PostgreSQL connection.
-- It creates a temporary landing table for the cleaned Milestone 2 CSV.
-- Re-running this script clears only this project's staging table.

CREATE SCHEMA IF NOT EXISTS mini_market;

CREATE TABLE IF NOT EXISTS mini_market.sales_staging (
    sale_date DATE,
    sale_month VARCHAR(7),
    transaction_id TEXT,
    store_id TEXT,
    store_name TEXT,
    county TEXT,
    population_2019 INTEGER,
    location TEXT,
    customer_id TEXT,
    customer_type TEXT,
    product_id TEXT,
    product_name TEXT,
    category TEXT,
    quantity INTEGER,
    unit_price_kes NUMERIC(12, 2),
    promotion_pct NUMERIC(5, 2),
    gross_sales_kes NUMERIC(12, 2),
    discount_kes NUMERIC(12, 2),
    net_sales_kes NUMERIC(12, 2),
    payment_method TEXT
);

TRUNCATE TABLE mini_market.sales_staging;
