# SQL Analysis

## Goal

Load the cleaned sales file into PostgreSQL and use SQL to answer the project questions. We will use DBeaver to connect to the Aiven PostgreSQL database. The scripts create tables only in the project schema named `mini_market`.

## Database design

- `sales_staging` is the landing table for the prepared CSV. We import the file here first.
- `stores`, `products`, and `customers` hold descriptions we can reuse.
- `sales` holds one row per cleaned receipt product line and links to those three lookup tables.

The analysis uses joins to add product and store names, and aggregations such as `SUM` and `COUNT`. A window function ranks products within each branch. Customer cohorts group identified customers by the month of their first observed purchase. RFM groups identified customers by how recently they bought, how often they bought, and how much they spent. The shared `WALK_IN` label is excluded from cohorts and RFM because it does not identify one person.

## Load the prepared CSV in DBeaver

First, run `notebooks/data_preparation.ipynb` so `data/processed/clean_sales_2025.csv` exists.

1. In DBeaver, select your Aiven PostgreSQL connection and open a SQL editor.
2. Open `sql/create_staging.sql` and run it as a script. It creates `mini_market.sales_staging` and clears that project's staging table ready for a new import.
3. In the Database Navigator, refresh the connection. Right-click `mini_market.sales_staging`, choose **Import Data**, select `data/processed/clean_sales_2025.csv`, and choose CSV. Confirm that the first row contains column names, the delimiter is a comma, and the encoding is UTF-8. Finish the import.
4. Open and run `sql/build_tables.sql` as a script. It creates and fills the three lookup tables and the sales table. Its final result grid shows the table row counts.
5. Open `sql/analysis_queries.sql`. Run one numbered query section at a time and read its result grid. The first query is a total-sales check; the later sections cover product and branch sales, monthly trends, product ranking, customer cohorts, and RFM segments.

In DBeaver, use **Execute SQL Script** to run the whole setup file. For the analysis file, highlight one query section and use **Execute SQL Statement** so the result is easy to find.

The staging script clears only `mini_market.sales_staging`. The build script refreshes only tables in `mini_market`; it does not drop other schemas or databases.

### Window ranking

`RANK() OVER (PARTITION BY store_id ORDER BY net_sales_kes DESC)` sorts products by net sales separately for each branch. The query returns the three highest-ranked products per branch.

### Customer cohorts

A cohort is a group of identified customers whose first observed purchase was in the same month. The results show how many from each group purchased again in later months. These are first purchases recorded in this one-year, not necessarily each person's first-ever purchase.

### RFM segments

- **Recency:** days since the customer's last purchase, measured to the last sale date in the dataset.
- **Frequency:** number of distinct receipts for the customer.
- **Monetary:** total net sales for the customer.

`NTILE(5)` puts each measure into five score groups. A higher recency score means a more recent purchase; higher frequency and monetary scores mean more receipts and more spending. The SQL then labels customers as Best customers, Loyal high spenders, Recent customers, Need attention, or Regular customers. This is a simple demonstration, not a business rule proven with a real shop.

## Expected result checks

Before running the SQL in Aiven, we can use these values from the current cleaned CSV as a check:

- Sales lines: **1,511**; distinct receipts: **1,134**; total net sales: **KES 375,259.50**.
- The database should contain **2 stores**, **10 products**, and **101 customer IDs** (100 identified IDs plus the shared `WALK_IN` label).
- Maize flour 2kg should be the top product overall: **387 units** and **KES 68,823.00** net sales.
- The RFM query should produce **100 identified customers** across its five segments. Walk-in sales are excluded.

These are reference checks calculated from the prepared CSV.I confirmed these values by running the SQL in my Aiven connection. Then I saved the results to `reports/sql_results.md` as the PostgreSQL results evidence.

## Conclusion

I loaded the cleaned sales file into PostgreSQL and split the data into a sales table and small lookup tables for products, stores, and customers. I used joins and totals to compare products and branches, a window function to rank products, cohorts to look at repeat buying, and RFM scores to group identified customers. I excluded walk-in sales from customer-level analysis because they do not identify individual people. The results match the prepared CSV and are saved in `reports/sql_results.md` as evidence of the PostgreSQL analysis.