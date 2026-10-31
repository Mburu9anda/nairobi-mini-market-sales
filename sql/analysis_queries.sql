-- Milestone 4: run each query section in DBeaver and review its result grid.
-- All money values are in Kenyan shillings (KES).

-- 1. Overall check: should show 1,511 product lines, 1,134 receipts,
-- and KES 375,259.50 net sales for the current cleaned file.
SELECT
    COUNT(*) AS product_lines,
    COUNT(DISTINCT transaction_id) AS receipts,
    ROUND(SUM(net_sales_kes), 2) AS total_net_sales_kes
FROM mini_market.sales;

-- 2. Which products perform best in each branch?
-- This query joins the sales, product, and store tables, then aggregates.
SELECT
    st.county,
    st.store_name,
    p.category,
    p.product_name,
    SUM(s.quantity) AS units_sold,
    ROUND(SUM(s.net_sales_kes), 2) AS net_sales_kes
FROM mini_market.sales AS s
JOIN mini_market.products AS p ON p.product_id = s.product_id
JOIN mini_market.stores AS st ON st.store_id = s.store_id
GROUP BY st.county, st.store_name, p.category, p.product_name
ORDER BY st.store_name, net_sales_kes DESC;

-- 3. How did sales change by month in each branch?
SELECT
    DATE_TRUNC('month', s.sale_date)::DATE AS month_start,
    st.store_name,
    ROUND(SUM(s.net_sales_kes), 2) AS net_sales_kes
FROM mini_market.sales AS s
JOIN mini_market.stores AS st ON st.store_id = s.store_id
GROUP BY month_start, st.store_name
ORDER BY month_start, st.store_name;

-- 4. What are the top three products in each branch?
-- RANK is a window function: it ranks products separately for each branch.
WITH product_totals AS (
    SELECT
        s.store_id,
        st.store_name,
        p.product_name,
        SUM(s.quantity) AS units_sold,
        ROUND(SUM(s.net_sales_kes), 2) AS net_sales_kes
    FROM mini_market.sales AS s
    JOIN mini_market.stores AS st ON st.store_id = s.store_id
    JOIN mini_market.products AS p ON p.product_id = s.product_id
    GROUP BY s.store_id, st.store_name, p.product_name
), ranked_products AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY store_id ORDER BY net_sales_kes DESC) AS sales_rank
    FROM product_totals
)
SELECT store_name, product_name, units_sold, net_sales_kes, sales_rank
FROM ranked_products
WHERE sales_rank <= 3
ORDER BY store_name, sales_rank;

-- 5. When did identified customers first appear, and how many returned?
-- A cohort is the month of a customer's first recorded purchase in this dataset.
-- WALK_IN is a shared label, not an individual person, so it is excluded.
WITH customer_months AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', sale_date)::DATE AS activity_month
    FROM mini_market.sales
    WHERE customer_id <> 'WALK_IN'
), first_purchase AS (
    SELECT customer_id, MIN(activity_month) AS cohort_month
    FROM customer_months
    GROUP BY customer_id
), cohort_activity AS (
    SELECT
        fp.cohort_month,
        cm.activity_month,
        cm.customer_id,
        (
            (EXTRACT(YEAR FROM cm.activity_month) - EXTRACT(YEAR FROM fp.cohort_month)) * 12
            + EXTRACT(MONTH FROM cm.activity_month) - EXTRACT(MONTH FROM fp.cohort_month)
        )::INTEGER AS months_since_first_purchase
    FROM customer_months AS cm
    JOIN first_purchase AS fp ON fp.customer_id = cm.customer_id
), cohort_sizes AS (
    SELECT cohort_month, COUNT(*) AS customers_at_start
    FROM first_purchase
    GROUP BY cohort_month
)
SELECT
    ca.cohort_month,
    ca.months_since_first_purchase,
    cs.customers_at_start,
    COUNT(DISTINCT ca.customer_id) AS active_customers,
    ROUND(100.0 * COUNT(DISTINCT ca.customer_id) / cs.customers_at_start, 1) AS retained_pct
FROM cohort_activity AS ca
JOIN cohort_sizes AS cs ON cs.cohort_month = ca.cohort_month
GROUP BY ca.cohort_month, ca.months_since_first_purchase, cs.customers_at_start
ORDER BY ca.cohort_month, ca.months_since_first_purchase;

-- 6. Which identified customers are valuable or need attention?
-- Recency = days since last purchase; frequency = distinct receipts;
-- monetary = total sales. The 1-to-5 scores use NTILE, a window function.
WITH rfm_base AS (
    SELECT
        customer_id,
        (SELECT MAX(sale_date) FROM mini_market.sales) - MAX(sale_date) AS recency_days,
        COUNT(DISTINCT transaction_id) AS frequency,
        ROUND(SUM(net_sales_kes), 2) AS monetary_kes
    FROM mini_market.sales
    WHERE customer_id <> 'WALK_IN'
    GROUP BY customer_id
), rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC, customer_id) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency, customer_id) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_kes, customer_id) AS monetary_score
    FROM rfm_base
), rfm_segments AS (
    SELECT
        *,
        CASE
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Best customers'
            WHEN frequency_score >= 4 AND monetary_score >= 4 THEN 'Loyal high spenders'
            WHEN recency_score = 5 THEN 'Recent customers'
            WHEN recency_score <= 2 THEN 'Need attention'
            ELSE 'Regular customers'
        END AS rfm_segment
    FROM rfm_scores
)
SELECT
    rfm_segment,
    COUNT(*) AS customers,
    ROUND(AVG(monetary_kes), 2) AS average_customer_sales_kes
FROM rfm_segments
GROUP BY rfm_segment
ORDER BY customers DESC, rfm_segment;
