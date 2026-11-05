# Power BI Dashboard and Storytelling

## Goal

Power BI report for a mini-market manager. It should answer:

1. How much did the two sample branches sell, and how many units and receipts were recorded?
2. Which months and products had higher sales?
3. How did sales differ by branch and customer type?
4. What did the forecast predict, and how accurate was it on the held-out weeks?

## How the data joins work

For this dashboard, we will use `data/processed/clean_sales_2025.csv`. It already has the store, product, county, and customer-type descriptions to each sales row.

## Imported the sales CSV

1. Open Power BI Desktop and select **Home → Get data → Text/CSV**.
2. Choose `data/processed/clean_sales_2025.csv`, then select **Transform Data**.
3. In Power Query, rename the query/table to `Sales`.
4. Confirm the data types: `sale_date` is Date; `quantity` is Whole Number; and `net_sales_kes`, `gross_sales_kes`, and `discount_kes` are Decimal Number.
5. Select **Close & Apply**.

## Added the forecast files

Use **Home → Get data → Text/CSV** again for each file:

1. Imported `reports/validation_predictions.csv` and renamed the table to `ForecastValidation`. 
2. Imported `reports/next_week_forecast.csv` and renamed the table to `ForecastSample`. 

## Created a few measures

In Power BI, select the `Sales` table, choose **New measure**, and create these measures one by one:

```DAX
Net Sales (KES) = SUM(Sales[net_sales_kes])

Units Sold = SUM(Sales[quantity])

Receipts = DISTINCTCOUNT(Sales[transaction_id])

Average Receipt (KES) = DIVIDE([Net Sales (KES)], [Receipts])
Discounts (KES) = SUM(Sales[discount_kes])
```

Measures recalculate when the manager changes a slicer.
For the forecast comparison, create measures from `ForecastValidation`:

```DAX
Actual Units (Validation) = SUM(ForecastValidation[units_sold])

Four-Week Forecast Units = SUM(ForecastValidation[four_week_average_forecast])

Baseline Units = SUM(ForecastValidation[baseline_forecast])

Forecast MAE (Units) = AVERAGE(ForecastValidation[average_absolute_error])

Forecast WAPE = DIVIDE(SUM(ForecastValidation[average_absolute_error]), SUM(ForecastValidation[units_sold]))
```

Format `Forecast WAPE` as Percentage. Format the money measures as currency with two decimals.

KPI cards:

- Net sales: **KES 375,259.50**
- Units sold: **2,242**
- Receipts: **1,134**
- Average receipt: **KES 330.92**
- Maize flour 2kg: **KES 68,823.00** net sales


## Saved the milestone evidence

Save the Power BI file as `reports/nairobi_mini_market_dashboard.pbix`. Saved screenshots  of the finished reports pages are as follows; `reports/Sales_dashboard.png`, `reports/Next_week_forecast_dashboard.png`, and `reports/Forecast_performance_dashboard.png`.

## Forecast model update

The saved Power BI forecast page compares the last-week baseline with the four-week average. The learned linear regression was added later and is evaluated in `notebooks/demand_forecast.ipynb` and `reports/evaluation.md`; it is not yet shown as a third forecast on the Power BI page.
