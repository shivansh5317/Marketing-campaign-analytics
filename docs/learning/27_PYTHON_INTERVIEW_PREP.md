# 27 — Python / Pandas Interview Prep

🟡 GOOD TO KNOW

Focused strictly on DA-relevant Python/Pandas — not generic software-engineering interview content.

## DataFrame / Series

**Q: "DataFrame aur Series mein farak?"**
> DataFrame = poori 2D table (rows+columns). Series = ek single column (1D). `df["income"]` ek Series return karta hai.

**Q: "Ek DataFrame kaise create/load karoge?"**
> `pd.read_csv(path)` se file se, ya `pd.DataFrame({...})` se manually dictionary se.

## Filtering

**Q: "Pandas mein rows kaise filter karte ho?"**
> Boolean indexing: `df[df["income"] > 50000]`. Multiple conditions: `df[(df["income"] > 50000) & (df["age"] < 40)]` — note `&`/`|` (not `and`/`or`) for element-wise boolean logic, and parentheses around each condition are required.

**Project example:** `df = df[implied_age <= 90]` (dropping impossible ages).

## GroupBy

**Q: "groupby ke baad agar aggregate na lagayein toh kya milta hai?"**
> A `GroupBy` object — not a DataFrame yet. You must call `.sum()`, `.mean()`, `.agg(...)` etc. on it to get actual results.

**Project example:** `fact_campaign.groupby("campaign_name")["accepted"].agg(customers_accepted="sum", customers_targeted="count")`

## Merge

**Q: "merge ke 4 types (how=) kya hain?"**
> `"inner"` (default, only matching rows), `"left"` (all left rows), `"right"` (all right rows), `"outer"` (all rows from both). This project only needed `"inner"`.

**Q: "Merge ke baad rows kam/zyada ho sakti hain?"**
> Haan — agar keys unique na hon (one-to-many), rows multiply ho sakti hain (fan-out), bilkul SQL JOIN ki tarah.

## Missing Values

**Q: "Missing values detect/handle kaise karte ho?"**
> `.isna().sum()` se detect; `.dropna()` se remove, `.fillna(value)` se fill. Choice depends on % missing and field importance.

**Project example:** `df.dropna(subset=["Income"])` — only 1.07% missing, dropping was safe.

## Duplicates

**Q: "Duplicate rows kaise detect/remove karte ho?"**
> `.duplicated().sum()` to count, `.drop_duplicates()` to remove. For ID-level duplicate check: `df["ID"].duplicated().sum()`.

## Sorting

**Q: "Sort karne ka syntax?"**
> `df.sort_values("column", ascending=False)` — like SQL `ORDER BY`.

## Datetime

**Q: "Text column ko date mein kaise convert karte ho?"**
> `pd.to_datetime(df["col"], format="%Y-%m-%d")`. Then `.dt.year`, `.dt.days` (on a timedelta), etc. become usable.

**Project example:** `(ANALYSIS_REFERENCE_DATE - df["Dt_Customer"]).dt.days` → `customer_tenure_days`.

## Aggregation

**Q: "Ek saath multiple aggregations kaise karte ho ek groupby pe?"**
> `.agg(name1=("col1","sum"), name2=("col2","count"))` — named aggregation, clean result column names.

## Creating Columns

**Q: "Row-wise sum kaise karte ho multiple columns ka?"**
> `df[list_of_columns].sum(axis=1)` — `axis=1` means "sum across columns, for each row."

**Project example:** `df["TotalSpend"] = df[MNT_COLUMNS].sum(axis=1)`.

## Common Pandas Interview Traps

| Trap | Correct Understanding |
|---|---|
| `df.loc` vs `df.iloc` | `.loc` = by label; `.iloc` = by integer position |
| `and`/`or` vs `&`/`|` in filters | Must use `&`/`|` for element-wise Series logic, with parentheses |
| `axis=0` vs `axis=1` | 0 = down columns (per-column result); 1 = across rows (per-row result) |
| Does `groupby` return a DataFrame? | No — a GroupBy object, until an aggregation is applied |
| Does `merge` always keep the same row count? | No — depends on `how=` and key uniqueness (fan-out possible) |

## What I Should Remember

1. Every pandas concept here has a literal corresponding line in `scripts/clean_data.py`, `scripts/segment_customers.py`, or the Phase 7 notebook — point to the real code when asked.
2. `axis=1` and `&`/`|` vs `and`/`or` are the two most common beginner trip-ups — know them cold.

---
*Next: [28_POWER_BI_INTERVIEW_PREP.md](28_POWER_BI_INTERVIEW_PREP.md)*
