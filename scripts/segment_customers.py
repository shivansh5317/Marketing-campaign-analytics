"""
RFM-style customer segmentation (no ML/clustering) for the iFood Marketing
Campaign dataset. Reads dim_customers.csv, scores each customer on
Recency / Frequency / Monetary using quartiles, and assigns one of 4
explainable segments. Adds the new columns back into dim_customers.csv.

See docs/05_customer_segmentation.md for the full reasoning.

Run directly:  python scripts/segment_customers.py
"""

import pandas as pd

DIM_CUSTOMERS_PATH = "data/processed/dim_customers.csv"


def score_rfm(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()

    # Recency: LOWER is better (more recently active), so quartile labels are reversed.
    df["R_score"] = pd.qcut(df["recency"], 4, labels=[4, 3, 2, 1]).astype(int)

    # Frequency: HIGHER is better. rank(method="first") breaks ties so qcut can
    # always split into 4 equal-sized groups even with many repeated values.
    df["F_score"] = pd.qcut(df["total_purchases"].rank(method="first"), 4, labels=[1, 2, 3, 4]).astype(int)

    # Monetary: HIGHER is better.
    df["M_score"] = pd.qcut(df["total_spend"], 4, labels=[1, 2, 3, 4]).astype(int)

    df["rfm_score"] = df["R_score"] + df["F_score"] + df["M_score"]
    return df


def assign_segment(rfm_score: int) -> str:
    if rfm_score >= 10:
        return "Champions"
    if rfm_score >= 7:
        return "Loyal Customers"
    if rfm_score >= 5:
        return "At Risk"
    return "Lost / Hibernating"


def main() -> None:
    df = pd.read_csv(DIM_CUSTOMERS_PATH)
    df = score_rfm(df)
    df["segment"] = df["rfm_score"].apply(assign_segment)

    df.to_csv(DIM_CUSTOMERS_PATH, index=False)

    print("Segment sizes:")
    print(df["segment"].value_counts())
    print()
    print("Avg Recency / Frequency / Monetary per segment:")
    print(df.groupby("segment")[["recency", "total_purchases", "total_spend"]].mean().round(1))


if __name__ == "__main__":
    main()
