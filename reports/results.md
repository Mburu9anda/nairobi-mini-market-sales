# Statistical Analysis Results

These tests use synthetic receipt data for 2025. Differences describe this sample and do not prove cause and effect.

## Assumptions checked

Each observation is one receipt and each receipt appears once. The group summaries show group sizes, means, medians, spreads, and extremes. The smallest promotion/payment group sizes are 277 and 397; both exceed 30: True. Welch t-tests allow unequal group variances. Some customer IDs appear on multiple receipts, so independence across receipts is not guaranteed. The generated data and non-random promotion assignment mean these are exploratory associations, not causal estimates.

## Test 1: promotion and gross receipt value

Receipts with promotion: 277; mean KES 373.14.
Receipts without promotion: 857; mean KES 322.54.
Mean difference (with minus without): KES 50.60.
95% confidence interval: KES 10.75 to KES 90.45.
Welch t-test p-value: 0.01293.
Conclusion: Promoted receipts had a higher average gross value by KES 50.60. The difference is statistically significant in this sample, but it does not show that the promotion caused the higher value.

## Test 2: M-Pesa and cash net receipt value

M-Pesa receipts: 558; mean KES 337.75.
Cash receipts: 397; mean KES 333.55.
Mean difference (M-Pesa minus cash): KES 4.20.
95% confidence interval: KES -35.20 to KES 43.60.
Welch t-test p-value: 0.8345.
Conclusion: The data does not provide clear evidence of a difference in average net receipt value. The observed difference is KES 4.20; the 95% interval includes no difference.
