# Demand Forecast Evaluation

This forecast uses synthetic weekly sales data. It is a learning example, not an order recommendation for a real shop.

## Forecast setup

Training/history: 42 earlier weeks. Validation: 11 later weeks, from 20 Oct 2025 to 29 Dec 2025.
The baseline uses the previous week. The model uses the average of the previous four weeks. Both use past actual sales only for each one-week-ahead forecast.

## Validation metrics

| Forecast | MAE (units) | WAPE | Bias (units) |
| --- | ---: | ---: | ---: |
| Last-week baseline | 2.20 | 104.5% | 0.15 |
| Four-week average model | 1.73 | 82.0% | 0.12 |

## Conclusion

The four-week average performed better than the last-week baseline on the validation weeks. It missed by 1.73 units per product-branch-week on average, compared with 2.20 for the baseline.

## Next-week forecast

The four-week average forecast for the week starting 05 Jan 2026 was created using all available history.
The product-by-branch values are saved in reports/next_week_forecast.csv.

## Largest model misses

```text
week_start             store_name    product_name  units_sold  four_week_average_forecast miss_direction  average_absolute_error
2025-12-22 Sample Ruiru Mini-Mart Maize flour 2kg          10                        3.00 under-forecast                    7.00
2025-11-03 Sample Ruiru Mini-Mart Maize flour 2kg          10                        3.25 under-forecast                    6.75
2025-10-27 Sample Ruiru Mini-Mart        Rice 2kg           7                        1.25 under-forecast                    5.75
2025-12-15 Sample Ruiru Mini-Mart      Bread loaf           0                        5.25  over-forecast                    5.25
2025-10-27 Sample Ruiru Mini-Mart      Bread loaf           7                        1.75 under-forecast                    5.25
```

The model smooths demand, so it can miss sudden spikes and can forecast sales in a week that turns out quiet. The validation covers only the final part of one synthetic year, so performance may differ in another year or a real store.
