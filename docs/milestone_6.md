# Weekly Demand Forecast

## Goal

We forecast weekly unit sales for each product at the two sample branches. The purpose is to compare simple methods with a trained model, not to create an automatic order recommendation. The data is synthetic.

## Methods compared

- **Last-week baseline:** use the previous week’s sales as the next-week forecast.
- **Four-week average baseline:** average the previous four weeks. This is another baseline, not a trained model.
- **Learned model:** use one linear regression trained from past weekly sales. Its inputs are the previous four weeks, their average, week of year, branch and product. NumPy calculates the weights from the training data. Predictions below zero are set to zero.

The first 42 of 53 weeks are history. After the four weeks needed for lag features, the model trains on 760 product-branch-week rows. We compare all three methods on the same final 11 weeks (20 October to 29 December 2025). We do not shuffle weeks. Each forecast uses completed earlier weeks only.

## Validation results

| Forecast | MAE (units) | WAPE | Bias (units) |
| --- | ---: | ---: | ---: |
| Last-week baseline | 2.20 | 104.5% | 0.15 |
| Four-week average baseline | 1.73 | 82.0% | 0.12 |
| Learned linear regression | 1.54 | 72.9% | 0.09 |

The regression beat the four-week average on these weeks. Its MAE was about 11% lower, and WAPE was 9.1 percentage points lower. WAPE is still high, so the model is not ready to guide real stock orders.

## What the model gets wrong

It still misses sudden demand spikes. For example, the Ruiru branch sold 10 units of maize flour 2kg in the weeks starting 3 November and 22 December, while the regression predicted about 3.75 and 3.54 units. In the final validation week, actual sales across all product-branch pairs were 20 units while the model predicted about 43.5. It was too slow to respond when demand fell.

## How to run and check it

1. Run `notebooks/data_preparation.ipynb` first.
2. Open `notebooks/demand_forecast.ipynb` and choose **Run All**.
3. Check the evaluation table in the notebook and `reports/evaluation.md`. All three methods should be scored on the same 11 weeks.

The notebook saves `reports/validation_predictions.csv`, `reports/evaluation.md`, and `reports/next_week_forecast.csv`. The last file includes a historical forecast for the week starting 5 January 2026, immediately after the 2025 data. That date has passed; it is an example of the process, not a current stock recommendation.

## Recommendation

For an actual Nairobi shop, collect real point-of-sale and stockout data over a longer period, then compare forecasts against what the shop sold. Do not use this synthetic example to place orders.
