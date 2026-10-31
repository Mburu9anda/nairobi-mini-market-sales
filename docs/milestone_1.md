# Milestone 1 - Problem Framing and Data Acquisition

## 1. The business problem

Small mini-markets around Nairobi need to decide what to restock. If they buy too much, money is tied up in slow-moving stock. If they buy too little, customers may find an item out of stock.

For this project, we will study two fictional branches: one in Nairobi CBD and one in Ruiru, Kiambu County. We will use one year of synthetic sales and a small public population table to answer practical questions. The data is invented for learning; it is not evidence about an actual shop.

## 2. Questions and success measures

| Business question | How we will measure it |
| --- | --- |
| Which products sell most? | Rank products by units sold and sales value in KES. |
| How do the two branches compare? | Compare monthly sales value and units sold by branch. |
| What should each branch consider restocking next month? | Later, we will compare a simple forecast with a basic recent-average baseline and report the forecast error. |


## 3. Data we will use

### Synthetic shop data

`src/generate_data.py` creates these files in `data/raw/`:

- `transactions_2025.csv`: one row per product on a receipt, with date, transaction ID, branch, customer ID, product, quantity, unit price, promotion and payment method.
- `stores.csv`:  branch names, counties and locations.
- `products.csv`:  grocery items, categories and prices in Kenyan shillings.
- `customers.csv`: customer IDs and customer type.

The `customer_id` is blank for some walk-in purchases. The generator includes M-Pesa, cash and card payments

### Public context data

`data/reference/knbs_county_population_2019.csv` contains the 2019 census populations for Nairobi City County (4,397,073) and Kiambu County (2,417,735). It can be joined to shop sales through `store_id` → `stores.csv` → `county`.

We chose this source because it is official Kenyan context and the county field makes the join easy to explain. County population is only background context: a county total is not a branch's customer count or trading area, so we will not claim that population caused a sales difference.

## 4. Source and terms record

| Data | Source and how obtained | Terms / attribution | Use and limitation |
| --- | --- | --- | --- |
| 2019 county population | Kenya National Bureau of Statistics (KNBS), *2019 Kenya Population and Housing Census, Volume I: Population by County and Sub-County*. The two county totals were transcribed into our small reference CSV from the KNBS publication. [KNBS census publication](https://repository.knbs.or.ke/entities/publication/2521aa6d-1c77-4929-b238-f2d4db65ceab). | The KNBS repository record lists Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). Credit KNBS and the 2019 census; for reuse of adapted material, follow the non-commercial and share-alike conditions. | Used only as county-level background. It is from 2019 and is not a current population estimate or a shop catchment measure. |
| Sales, stores, products and customers | Created locally by `src/generate_data.py` using invented values and a fixed seed. | Synthetic work created for this project; no third-party data terms apply. | Customer IDs are fictional and contain no personal information. |

## 5. How the data connects

The transaction row has a `store_id` and a `product_id`. The store lookup provides the county. We then match that county to the KNBS reference file. This is a simple key-based join:

`transactions.store_id` - `stores.store_id` - `stores.county` - `county_population_2019.county`

This lets us attach public context to a branch-level summary later. The transaction's `sale_date` will support monthly trends, and the product, quantity, price, promotion and payment fields support the business questions.

## 6. How it works

1. The generator makes fictional shops, products and customers.
2. It creates dated receipt lines across all days in 2025. Each line says what was bought, how many, the price, any discount and how it was paid.
3. Each row uses IDs to refer to a store, product and sometimes a customer.
4. The KNBS file adds county population context using the branch's county.