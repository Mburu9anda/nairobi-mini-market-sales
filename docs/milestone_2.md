# Data Cleaning and Preparation

## Goal

Prepare the raw mini-market transactions for sales analysis in a way that can be repeated whenever the raw files are refreshed. The notebook reads the files in raw data, adds store, product, customer, and writes new outputs. It does not edit the raw files.

## Simple process

1. Read the transaction CSV as text so the notebook controls the type conversions.
2. Convert the sale date to a date and quantity, unit price, and promotion to numbers.
3. Treat a blank customer ID as a walk-in sale. Remove a row only if a required sale detail is missing or invalid.
4. Combine repeated items with the same product and sale details on one receipt by adding their quantities. This keeps the full number of items sold. Different products or discount rates stay separate.
5. Remove impossible or extreme values using clear limits: quantity must be 1-100, unit price must be greater than KES 0 and no more than KES 100,000, and promotion must be 0-100%.
6. Add store, product, customer, and county population descriptions, then calculate month, gross sales, discount, and net sales.
7. Save the prepared data and a before/after quality report.

## How to run it

From the project folder, install the requirements once, then start Jupyter:


In the browser tab that opens, open `notebooks/data_preparation.ipynb` and choose **Run All**. The notebook explains each step before the code that performs it.

The notebook creates:

- `data/processed/clean_sales_2025.csv` - one prepared row per valid transaction product line.
- `reports/quality_report.csv` - the row counts and affected-value counts at each cleaning step.

The raw CSVs in raw data remain unchanged, so the notebook can be safely run again.

## How to read the checks

`rows_before` and `rows_after` show how many transaction rows remain at each step. `rows_removed` shows rows dropped for missing required details or impossible values. `rows_combined` shows repeated receipt items that were combined by adding their quantities. `values_fixed_or_flagged` counts values filled or rows flagged by that step. A zero outlier count means the check ran and found no impossible values; it is better to keep valid sales than to invent problems.

The blank customer IDs are intentional in this dataset: they represent customers who did not provide an ID. The pipeline labels these rows `WALK_IN` rather than treating them as broken records.

## Results

The notebook was run against the current raw files. It prepared 1,511 rows from 1,548 raw rows. It filled 498 blank customer IDs as walk-ins, removed no rows for missing required details or out-of-range values, and combined 37 repeated receipt items. Total units stayed at 2,242 before and after combining. The exact counts are also saved in `reports/quality_report.csv`.

| Step | Rows before | Rows after | Rows removed | Rows combined | What the step did |
| --- | ---: | ---: | ---: | ---: | --- |
| Raw input | 1,548 | 1,548 | 0 | 0 | Loaded transaction rows without changing raw data. |
| Type conversion | 1,548 | 1,548 | 0 | 0 | Parsed 6,192 date and numeric values. |
| Missing values | 1,548 | 1,548 | 0 | 0 | Labeled 498 walk-in customer IDs; no required details were missing. |
| Repeated receipt items | 1,548 | 1,511 | 0 | 37 | Combined matching items and added their quantities. |
| Outlier and range checks | 1,511 | 1,511 | 0 | 0 | No rows were outside the documented business limits. |

## How we will check the result

Choose **Run All** and confirm that the final cell completes, creates both output files, and displays the quality report. Then open `data/processed/clean_sales_2025.csv` and confirm that dates are readable, sales amounts are non-negative, `sale_month` is filled, walk-in customers are labeled, and branch/product names are present. Choose Run All again: it should produce the same row counts and overwrite only the two generated outputs.

## Conclusion

I built a pandas notebook. It parses dates and numbers, labels unidentified customers as walk-ins, combines repeated receipt items without losing units, checks for impossible values, and creates monthly and net-sales fields. The report shows what each check changed. I kept the original data untouched so the preparation can be repeated."
