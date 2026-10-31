# Statistical Analysis

## Goal

We are adding two simple statistical checks to the project:

1. Are average gross receipt values different for receipts with a promotion and without one?
2. Are average net receipt values different for receipts paid with M-Pesa and cash?

The unit of analysis is a **receipt**, not a product line. The notebook adds each receipt's product lines together before comparing groups.

## How the tests work

For each question, the notebook states:

- The **null hypothesis**: the two groups have the same average receipt value.
- The **alternative hypothesis**: the group averages are different.

It uses Welch's two-sample t-test, which compares averages without assuming the groups have the same variance. It reports the observed difference in average value, a 95% confidence interval, and a p-value. A p-value below 0.05 is treated as evidence of a difference in this sample. If the confidence interval includes zero, the data is also consistent with no average difference. The test method and confidence interval are provided by SciPy's `ttest_ind` result.

For the promotion question, we compare **gross** receipt sales before discounts. That way the discount itself does not automatically lower the outcome. A receipt counts as promoted if at least one item on it had a promotion. For the payment question, we compare **net** sales, the amount after discounts, and leave card payments out so the comparison has just two groups.

## How to run it

1. Run all cells in `notebooks/data_preparation.ipynb` first.
2. Open `notebooks/statistical_analysis.ipynb` and choose **Run All**.
3. Read the group summary tables, test outputs, and conclusions. The last code cell saves them to `reports/results.md`.

## Assumptions we check

- The notebook makes one observation per receipt and checks that receipt IDs are unique.
- The summary tables show each group's size, mean, median, standard deviation, quartiles, and maximum. This helps us see skew and large receipts.
- All four groups in the current dataset have more than 30 receipts. Welch's test does not require equal group variances.
- Receipts from the same customer can appear more than once. The tests treat receipts as independent, so repeated customer IDs are a limitation.

## Reference group averages

These descriptive averages are calculated from the current prepared CSV. The notebook calculates the p-values and confidence intervals when run.

| Comparison | Receipts | Average value |
| --- | ---: | ---: |
| With a promotion, gross receipt | 277 | KES 373.14 |
| Without a promotion, gross receipt | 857 | KES 322.54 |
| M-Pesa, net receipt | 558 | KES 337.75 |
| Cash, net receipt | 397 | KES 333.55 |

## Expected test results and conclusions

These reference results are calculated from the current cleaned file using Welch's test. Running the notebook will reproduce the p-values and confidence intervals and save them as a results report.

| Question | Difference in averages | 95% confidence interval | p-value |
| --- | ---: | ---: | ---: |
| Promoted minus non-promoted gross receipt | KES 50.60 | KES 10.75 to KES 90.45 | 0.0129 |
| M-Pesa minus cash net receipt | KES 4.20 | KES -35.20 to KES 43.60 | 0.8345 |

- **Promotion:** Promoted receipts had a higher average gross value in this sample, and the interval does not include zero. The difference is statistically significant at the 5% level.
- **Payment method:** M-Pesa receipts had a slightly higher average net value, but the interval includes zero and the p-value is above 0.05. We did not find clear evidence of a difference. This does not prove the averages are exactly equal.

## Conclusion

I compared average receipt values for promotions and payment methods. I used Welch's t-test and a 95% confidence interval, checked group sizes and value distributions, and kept the results at receipt level.
