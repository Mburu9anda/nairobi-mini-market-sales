# Demand Forecast Evaluation

This forecast uses synthetic weekly sales data. It is a learning example, not an order recommendation for a real shop.

## Forecast setup

Training/history: 42 earlier weeks (760 product-branch-week rows used for training after lag features). Validation: 11 later weeks, from 20 Oct 2025 to 29 Dec 2025.
Each method predicts one week ahead. The validation week that has finished is available as past data for the next prediction.
The learned model is one linear regression using four sales lags, the average of those lags, a repeating week-of-year pattern, and branch/product indicators. Negative predictions are set to zero.

## Validation metrics on the same 11 weeks

| Forecast | MAE (units) | WAPE | Bias (units) |
| --- | ---: | ---: | ---: |
| Last-week baseline | 2.20 | 104.5% | 0.15 |
| Four-week average baseline | 1.73 | 82.0% | 0.12 |
| Learned linear regression | 1.54 | 72.9% | 0.09 |

## Conclusion

The trained linear regression beat the four-week average on the same validation weeks. MAE fell from 1.73 to 1.54 units (11.0% lower). WAPE fell from 82.0% to 72.9%. However, the remaining error is still high for restocking.
WAPE of the learned model is still high: on these validation rows, the total absolute error is about 72.9% of actual units sold. Use the result to compare methods, not to set real shop orders.

## What the learned model gets wrong

The largest misses include sudden demand spikes. For example, the Ruiru branch sold 10 units of maize flour 2kg in the weeks starting 3 November and 22 December, while the regression predicted about 3.75 and 3.54 units. In the final validation week, total actual sales were 20 units versus 43.5 predicted units, so the model also stayed too high after demand fell.

Largest individual product-branch-week misses:

```text
week_start             store_name    product_name  units_sold  linear_regression_forecast miss_direction  linear_regression_forecast_absolute_error
2025-12-22 Sample Ruiru Mini-Mart Maize flour 2kg          10                        3.54 under-forecast                                       6.46
2025-11-03 Sample Ruiru Mini-Mart Maize flour 2kg          10                        3.75 under-forecast                                       6.25
2025-10-27 Sample Ruiru Mini-Mart        Rice 2kg           7                        1.33 under-forecast                                       5.67
2025-12-22   Sample CBD Mini-Mart       Sugar 1kg           8                        2.64 under-forecast                                       5.36
2025-12-08   Sample CBD Mini-Mart        Rice 2kg           6                        1.17 under-forecast                                       4.83
```

## Historical post-sample forecast

The saved example is for the week starting 05 Jan 2026, immediately after the 2025 sample. It is historical now. The CSV includes both baselines and the learned regression forecast.
A real restocking model should be checked against actual point-of-sale and stockout data over more history before anyone uses it for orders.
