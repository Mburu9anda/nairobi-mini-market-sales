# SQL result checks

| SQL check | Expected result |
| --- | ---: |
| Clean sales lines loaded | 1,511 |
| Distinct receipts | 1,134 |
| Total net sales | KES 375,259.50 |
| Store records | 2 |
| Product records | 10 |
| Customer IDs including `WALK_IN` | 101 |
| Identified customer IDs for cohort/RFM analysis | 100 |

## Product leaders

| Product | Units sold | Net sales (KES) |
| --- | ---: | ---: |
| Maize flour 2kg | 387 | 68,823.00 |
| Eggs tray | 136 | 64,728.00 |
| Cooking oil 1L | 195 | 61,472.00 |

## RFM segment counts

| Segment | Customers |
| --- | ---: |
| Need attention | 31 |
| Regular customers | 26 |
| Best customers | 15 |
| Loyal high spenders | 15 |
| Recent customers | 13 |

## Cohort check

The January 2025 first-observed cohort contains **45 identified customers**. In the next calendar month, **23** made another purchase (**51.1%**). The cohort is based only on first purchases seen in this one-year dataset.

After checking the result grids in DBeaver, update this file if any values differ. Add exported CSV result files here if you want to keep the full query outputs.
