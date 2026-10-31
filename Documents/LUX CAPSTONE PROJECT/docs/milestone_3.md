# EDA notebook

## Goal

We are using the cleaned sales file to look for useful patterns in the shops. The notebook is `notebooks/eda.ipynb`. It makes charts and tables, then writes five short findings.

The questions are:

1. What does a typical receipt value look like?
2. Which months and weekdays had higher sales in this sample?
3. How did the two branches and their counties compare?
4. Which products and categories brought in the most sales?
5. How did sales differ by customer type?

## How to run it

1. Open the project in VS Code.
2. Run all cells in `notebooks/data_preparation.ipynb` first. This creates `data/processed/clean_sales_2025.csv`.
3. Open `notebooks/eda.ipynb` and select **Run All**.

The EDA notebook reads the prepared file and checks that the product, month, branch, county and customer-type totals each add up to the same total sales. It saves the findings to `reports/findings.txt`.

## Five findings from the current sample

1. **Product:** Maize flour 2kg had the highest net sales: **KES 68,823.00** from **387 units**.
2. **Time:** December was the strongest month (**KES 37,034.75**) and February was the weakest (**KES 26,069.25**). Average daily sales were highest on Wednesday (**KES 1,135.96**) and lowest on Sunday (**KES 906.38**).
3. **Branch and county:** Sample CBD Mini-Mart in Nairobi City County recorded **KES 192,003.50**, about **4.8%** more than Sample Ruiru Mini-Mart in Kiambu County (**KES 183,256.00**). There is only one sample branch per county, so we cannot tell whether the difference comes from the branch or the county.
4. **Customer type:** Loyalty-member receipts had the largest sales total (**KES 164,075.25**, or about **43.7%** of net sales). Walk-in / not identified means a purchase had no customer ID; it is not a count of individual people.
5. **Receipt values:** The median receipt was **KES 246.25** and the average was **KES 330.92**. The average being higher shows that some larger receipts pull it upward.

## The charts

- The histogram shows how many receipts fall into different sales-value ranges. The dashed line marks the median receipt.
- The monthly line chart compares the two branches over the year. It shows when sales were higher or lower in this sample.
- The weekday chart compares average sales per observed date for each weekday.
- The product and customer-type charts rank sales totals. Their tables also show units or receipt counts so we can compare more than one measure.

## Conclusion

I used pandas to group the cleaned sales into receipts, months, weekdays, branches, products, and customer types. I used charts to make the patterns easier to see and checked that each summary adds back to the same total sales. The data is generated and covers one year, so the findings describe this sample only.
