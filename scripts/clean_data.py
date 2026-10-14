"""
Data cleaning script for the iFood Marketing Campaign dataset.

Reads the raw CSV, fixes the data-quality issues documented in
docs/01_dataset_understanding.md and docs/02_data_cleaning.md, derives a
few analysis-ready fields, and splits the result into a simple star schema:

    dim_customers.csv           - one row per customer (dimension)
    fact_campaign_response.csv  - one row per (customer, campaign) (fact)
    fact_channel_purchases.csv  - one row per (customer, channel) (fact)

Run directly:  python scripts/clean_data.py
"""

import pandas as pd

RAW_PATH = "data/raw/ifood_marketing_campaign_raw.csv"
PROCESSED_DIR = "data/processed"

# The dataset has no explicit "as of" date, so we treat the last enrollment
# date in the data (2014-06-29) as roughly "today" and round up to end of
# 2014. This is a stated assumption, used only for Age and Tenure math.
ANALYSIS_REFERENCE_DATE = pd.Timestamp("2014-12-31")

MNT_COLUMNS = [
    "MntWines", "MntFruits", "MntMeatProducts",
    "MntFishProducts", "MntSweetProducts", "MntGoldProds",
]
CAMPAIGN_COLUMNS = {
    "AcceptedCmp1": "Cmp1",
    "AcceptedCmp2": "Cmp2",
    "AcceptedCmp3": "Cmp3",
    "AcceptedCmp4": "Cmp4",
    "AcceptedCmp5": "Cmp5",
    "Response": "Cmp6",  # Cmp6 = the most recent campaign in the dataset
}
CHANNEL_COLUMNS = {
    "NumWebPurchases": "Web",
    "NumCatalogPurchases": "Catalog",
    "NumStorePurchases": "Store",
}


def load_raw_data(path: str = RAW_PATH) -> pd.DataFrame:
    return pd.read_csv(path)


def clean_customers(df: pd.DataFrame) -> pd.DataFrame:
    """Fix the data-quality issues found in Phase 1. See docs/02_data_cleaning.md
    for the WHAT/WHY/HOW/WHY-this-approach reasoning behind each step."""
    df = df.copy()

    # 1) Impossible ages (Year_Birth of 1893/1899/1900 -> age 114-121) -> drop.
    implied_age = 2014 - df["Year_Birth"]
    df = df[implied_age <= 90]

    # 2) Missing Income (24 rows) -> drop rather than impute.
    df = df.dropna(subset=["Income"])

    # 3) Extreme Income outlier (666,666 vs next-highest 162,397) -> drop.
    df = df[df["Income"] != 666666]

    # 4) Inconsistent Marital_Status labels -> recode into valid categories.
    df["Marital_Status"] = df["Marital_Status"].replace({
        "Alone": "Single",
        "Absurd": "Other",
        "YOLO": "Other",
    })

    # 5) Dt_Customer was read as plain text -> parse to a real date.
    df["Dt_Customer"] = pd.to_datetime(df["Dt_Customer"], format="%Y-%m-%d")

    return df.reset_index(drop=True)


def derive_features(df: pd.DataFrame) -> pd.DataFrame:
    """Add analysis-ready columns without changing any raw values."""
    df = df.copy()
    df["Age"] = ANALYSIS_REFERENCE_DATE.year - df["Year_Birth"]
    df["Total_Children"] = df["Kidhome"] + df["Teenhome"]
    df["Customer_Tenure_Days"] = (ANALYSIS_REFERENCE_DATE - df["Dt_Customer"]).dt.days
    df["TotalSpend"] = df[MNT_COLUMNS].sum(axis=1)
    df["TotalPurchases"] = (
        df["NumWebPurchases"] + df["NumCatalogPurchases"] + df["NumStorePurchases"]
    )
    df["NumCampaignsAccepted"] = df[list(CAMPAIGN_COLUMNS.keys())].sum(axis=1)
    return df


def build_dim_customers(df: pd.DataFrame) -> pd.DataFrame:
    rename_map = {
        "ID": "customer_id",
        "Year_Birth": "year_birth",
        "Age": "age",
        "Education": "education",
        "Marital_Status": "marital_status",
        "Income": "income",
        "Kidhome": "kidhome",
        "Teenhome": "teenhome",
        "Total_Children": "total_children",
        "Dt_Customer": "dt_customer",
        "Customer_Tenure_Days": "customer_tenure_days",
        "Recency": "recency",
        "MntWines": "mnt_wines",
        "MntFruits": "mnt_fruits",
        "MntMeatProducts": "mnt_meat_products",
        "MntFishProducts": "mnt_fish_products",
        "MntSweetProducts": "mnt_sweet_products",
        "MntGoldProds": "mnt_gold_prods",
        "TotalSpend": "total_spend",
        "NumDealsPurchases": "num_deals_purchases",
        "NumWebVisitsMonth": "num_web_visits_month",
        "TotalPurchases": "total_purchases",
        "NumCampaignsAccepted": "num_campaigns_accepted",
        "Complain": "complain",
    }
    return df[list(rename_map.keys())].rename(columns=rename_map)


def build_fact_campaign_response(df: pd.DataFrame) -> pd.DataFrame:
    """Unpivot the 6 wide AcceptedCmp*/Response columns into a long/tidy
    fact table: one row per (customer, campaign)."""
    wide = df[["ID"] + list(CAMPAIGN_COLUMNS.keys())].rename(columns={"ID": "customer_id"})
    long = wide.melt(
        id_vars="customer_id",
        var_name="campaign_column",
        value_name="accepted",
    )
    long["campaign_name"] = long["campaign_column"].map(CAMPAIGN_COLUMNS)
    return long[["customer_id", "campaign_name", "accepted"]]


def build_fact_channel_purchases(df: pd.DataFrame) -> pd.DataFrame:
    """Unpivot the 3 purchase-channel columns into a long/tidy fact table:
    one row per (customer, channel)."""
    wide = df[["ID"] + list(CHANNEL_COLUMNS.keys())].rename(columns={"ID": "customer_id"})
    long = wide.melt(
        id_vars="customer_id",
        var_name="channel_column",
        value_name="num_purchases",
    )
    long["channel"] = long["channel_column"].map(CHANNEL_COLUMNS)
    return long[["customer_id", "channel", "num_purchases"]]


def main() -> None:
    raw = load_raw_data()
    print(f"Raw shape: {raw.shape}")

    cleaned = clean_customers(raw)
    print(f"Shape after cleaning: {cleaned.shape} "
          f"({len(raw) - len(cleaned)} rows dropped)")

    enriched = derive_features(cleaned)

    dim_customers = build_dim_customers(enriched)
    fact_campaign_response = build_fact_campaign_response(enriched)
    fact_channel_purchases = build_fact_channel_purchases(enriched)

    dim_customers.to_csv(f"{PROCESSED_DIR}/dim_customers.csv", index=False)
    fact_campaign_response.to_csv(f"{PROCESSED_DIR}/fact_campaign_response.csv", index=False)
    fact_channel_purchases.to_csv(f"{PROCESSED_DIR}/fact_channel_purchases.csv", index=False)

    print(f"dim_customers.csv           -> {dim_customers.shape}")
    print(f"fact_campaign_response.csv  -> {fact_campaign_response.shape}")
    print(f"fact_channel_purchases.csv  -> {fact_channel_purchases.shape}")


if __name__ == "__main__":
    main()
