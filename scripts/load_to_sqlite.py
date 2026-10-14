"""
Loads the processed star-schema CSVs into a local SQLite database so we can
run real SQL against them (sql/*.sql files, Phase 4).

Creates indexes on the join columns explicitly -- SQLite does NOT create
these automatically for plain CREATE TABLE + to_sql loads, and without them
JOINs silently fall back to a full nested-loop scan.

Run directly:  python scripts/load_to_sqlite.py
"""

import sqlite3

import pandas as pd

PROCESSED_DIR = "data/processed"
DB_PATH = "data/processed/marketing_analytics.db"


def main() -> None:
    dim_customers = pd.read_csv(f"{PROCESSED_DIR}/dim_customers.csv")
    fact_campaign_response = pd.read_csv(f"{PROCESSED_DIR}/fact_campaign_response.csv")
    fact_channel_purchases = pd.read_csv(f"{PROCESSED_DIR}/fact_channel_purchases.csv")

    conn = sqlite3.connect(DB_PATH)

    dim_customers.to_sql("dim_customers", conn, if_exists="replace", index=False)
    fact_campaign_response.to_sql("fact_campaign_response", conn, if_exists="replace", index=False)
    fact_channel_purchases.to_sql("fact_channel_purchases", conn, if_exists="replace", index=False)

    cur = conn.cursor()
    cur.execute("CREATE INDEX IF NOT EXISTS idx_dim_customers_id ON dim_customers(customer_id)")
    cur.execute("CREATE INDEX IF NOT EXISTS idx_fact_campaign_customer ON fact_campaign_response(customer_id)")
    cur.execute("CREATE INDEX IF NOT EXISTS idx_fact_campaign_name ON fact_campaign_response(campaign_name)")
    cur.execute("CREATE INDEX IF NOT EXISTS idx_fact_channel_customer ON fact_channel_purchases(customer_id)")
    cur.execute("CREATE INDEX IF NOT EXISTS idx_fact_channel_name ON fact_channel_purchases(channel)")
    conn.execute("ANALYZE")
    conn.commit()

    for table in ("dim_customers", "fact_campaign_response", "fact_channel_purchases"):
        count = cur.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
        print(f"{table}: {count} rows loaded")

    conn.close()
    print(f"SQLite database ready at {DB_PATH}")


if __name__ == "__main__":
    main()
