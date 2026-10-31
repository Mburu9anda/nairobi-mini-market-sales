"""Synthetic dataset"""

import csv
import random
from datetime import date, timedelta
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = ROOT / "data" / "raw"
RANDOM_SEED = 7

STORES = [
    {"store_id": "S001", "store_name": "Sample CBD Mini-Mart", "county": "Nairobi City", "location": "Nairobi CBD"},
    {"store_id": "S002", "store_name": "Sample Ruiru Mini-Mart", "county": "Kiambu", "location": "Ruiru"},
]

PRODUCTS = [
    {"product_id": "P001", "product_name": "Maize flour 2kg", "category": "Staples", "unit_price_kes": 180},
    {"product_id": "P002", "product_name": "Milk 1L", "category": "Dairy", "unit_price_kes": 75},
    {"product_id": "P003", "product_name": "Bread loaf", "category": "Bakery", "unit_price_kes": 70},
    {"product_id": "P004", "product_name": "Sugar 1kg", "category": "Staples", "unit_price_kes": 170},
    {"product_id": "P005", "product_name": "Cooking oil 1L", "category": "Staples", "unit_price_kes": 320},
    {"product_id": "P006", "product_name": "Eggs tray", "category": "Fresh food", "unit_price_kes": 480},
    {"product_id": "P007", "product_name": "Rice 2kg", "category": "Staples", "unit_price_kes": 330},
    {"product_id": "P008", "product_name": "Tea leaves 250g", "category": "Beverages", "unit_price_kes": 150},
    {"product_id": "P009", "product_name": "Water 1.5L", "category": "Beverages", "unit_price_kes": 60},
    {"product_id": "P010", "product_name": "Soap bar", "category": "Household", "unit_price_kes": 95},
]


def write_csv(path, rows, fieldnames):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main():
    rng = random.Random(RANDOM_SEED)
    customers = [
        {"customer_id": f"C{i:03d}", "customer_type": "loyalty_member" if i % 3 else "regular"}
        for i in range(1, 101)
    ]

    write_csv(RAW_DIR / "stores.csv", STORES, list(STORES[0]))
    write_csv(RAW_DIR / "products.csv", PRODUCTS, list(PRODUCTS[0]))
    write_csv(RAW_DIR / "customers.csv", customers, list(customers[0]))

    product_weights = [18, 20, 18, 12, 8, 5, 6, 5, 5, 3]
    payment_methods = ["M-Pesa", "M-Pesa", "M-Pesa", "Cash", "Cash", "Card"]
    rows = []
    current = date(2025, 1, 1)
    end = date(2025, 12, 31)
    receipt_number = 1

    while current <= end:
        for store in STORES:
            # One or two sample receipts per branch per day keeps the dataset small.
            receipts_today = 1 + (rng.random() < 0.55)
            for _ in range(int(receipts_today)):
                transaction_id = f"T{receipt_number:05d}"
                receipt_number += 1
                customer_id = rng.choice(customers)["customer_id"] if rng.random() < 0.7 else ""
                payment_method = rng.choice(payment_methods)
                item_count = 1 + (rng.random() < 0.35)
                chosen_products = rng.choices(PRODUCTS, weights=product_weights, k=int(item_count))

                for product in chosen_products:
                    quantity = rng.choices([1, 2, 3, 4], weights=[65, 24, 8, 3], k=1)[0]
                    promotion_pct = rng.choices([0, 5, 10], weights=[82, 13, 5], k=1)[0]
                    rows.append({
                        "sale_date": current.isoformat(),
                        "transaction_id": transaction_id,
                        "store_id": store["store_id"],
                        "customer_id": customer_id,
                        "product_id": product["product_id"],
                        "quantity": quantity,
                        "unit_price_kes": product["unit_price_kes"],
                        "promotion_pct": promotion_pct,
                        "payment_method": payment_method,
                    })
        current += timedelta(days=1)

    write_csv(RAW_DIR / "transactions_2025.csv", rows, list(rows[0]))
    print(f"Created {len(rows):,} fictional transaction lines in {RAW_DIR}")
    print("Dates: 2025-01-01 to 2025-12-31 (1 year), 2 stores, 10 products, 100 customers")


if __name__ == "__main__":
    main()
    
