# Weekly Demand Forecast

## Goal

We forecast weekly unit sales for each product at each of the two sample branches. The purpose is to see whether a small forecasting method can improve on a basic guess.

## The two forecasts

- **Baseline:** next week's demand will equal last week's demand.
- **Forecast model:** next week's demand will equal the average of the previous four weeks.

## How the time split works

Sales product lines are added together into weekly units for each product and branch. Weeks with no sales are filled with zero so quiet weeks remain in the analysis. The cleaned data creates **53 calendar weeks**, including partial weeks at the start and end of 2025.

The notebook keeps the first **42 weeks** as history and uses the final **11 weeks** (20 October to 29 December 2025) as validation. It does not shuffle the data. For each validation week, both forecasts use earlier actual weeks only. After a validation week has passed, its actual sales can be used to forecast the following week. This is a one-week-ahead process.

## How we measure performance

- **MAE (mean absolute error):** average number of units missed per product, branch, and week. Lower is better.
- **WAPE (weighted absolute percentage error):** total absolute error divided by total units actually sold. Lower is better. We use WAPE rather than MAPE because some weeks have zero sales.
- **Bias:** average forecast minus actual units. A positive value means slight over-forecasting; a negative value means under-forecasting.

## Current validation results

| Forecast | MAE (units) | WAPE | Bias (units) |
| --- | ---: | ---: | ---: |
| Last-week baseline | 2.20 | 104.5% | 0.15 |
| Previous four-week average | 1.73 | 82.0% | 0.12 |

The four-week average has lower error than the baseline in these 11 validation weeks. Its MAE is about **21.5% lower**, but its WAPE is still **82.0%**, so the forecast can still be far from actual weekly sales.

## What the model gets wrong

The largest misses in the validation period include weeks when Sample Ruiru Mini-Mart sold 10 units of maize flour 2kg after recent weeks were quieter; the four-week average predicted 3 units. It also predicted some bread sales in weeks when none were recorded. The average smooths demand, so it reacts slowly to sudden spikes and may over-forecast a quiet week.

The full list is in `reports/evaluation.md`. Every validation prediction is saved in `reports/validation_predictions.csv`. The notebook also saves an out-of-sample projection for the week immediately after the 2025 data period in `reports/next_week_forecast.csv`.

## How to run and check it

1. Run all cells in `notebooks/data_preparation.ipynb` first.
2. Open `notebooks/demand_forecast.ipynb` and choose **Run All**.
3. It reports 53 weeks, 42 history weeks, 11 validation weeks, and that the four-week average has lower MAE and WAPE than the baseline on the current data.

The notebook code was run against the current cleaned file. It produced 1,060 weekly rows (20 product-branch combinations across 53 weeks) and saved the evaluation, validation predictions, and post-sample projection. The projection is for the week starting 5 January 2026, immediately after 2025.

## Conclusion

I forecast weekly units for each product and branch. I compared the previous week's sales with a four-week moving average, using the earlier weeks as history and holding out the final 11 weeks for validation. The average improved MAE from 2.20 to 1.73 units, but WAPE remained high at 82%, and it missed sudden demand spikes. The data is synthetic, so I present this as a method demonstration.
