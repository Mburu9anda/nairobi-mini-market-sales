# Nairobi Mini-Market Sales Project

## Project question

How can a small shop near Nairobi use its past sales to decide which everyday products to restock?

We will use a clearly labeled synthetic dataset for two example branches: Nairobi CBD and Ruiru (Kiambu County). It covers 1 January to 31 December 2025. No real shop or customer records are used.

## What this project will answer

1. Which products bring in the most sales and units?
2. How do sales differ between the two branches and across months?
3. Which products might need more stock next month?

The first two questions describe past sales. The third will be a simple forecast later in the project. The KNBS county population values are background context; they do not tell us how many people shop at either branch.

## Milestone 1 files

- `docs/milestone_1.md` - the problem, questions, success measures, data plan, and the source.
- `data/raw/` - synthetic transactions that we have generated for our two branches, product and customers.
- `data/reference/knbs_county_population_2019.csv` - public KNBS population context for Nairobi City and Kiambu counties.
- `src/generate_data.py` - recreates the synthetic raw files which I have generated with a fixed random seed(42).
