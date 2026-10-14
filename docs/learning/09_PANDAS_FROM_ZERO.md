# 09 — Pandas From Zero

🔴 MUST KNOW

Pandas Python ki sabse important Data Analyst library hai — is poore project ka data-cleaning aur EDA isi pe based hai. Har function: **What / Syntax / Tiny Example / Project Usage / Interview Question.**

## 1. DataFrame & Series

- **DataFrame:** A 2D table (rows + columns) — pandas' core object, like an Excel sheet in code.
- **Series:** A single column (1D) — every column of a DataFrame is technically a Series.
- **Project usage:** `dim_customers`, `fact_campaign`, `fact_channel` are all DataFrames; `dim_customers["income"]` is a Series.

## 2. Loading Data

| Function | What | Project usage |
|---|---|---|
| `pd.read_csv(path)` | Loads a CSV into a DataFrame | `pd.read_csv("../data/processed/dim_customers.csv")` |

## 3. First Look

| Function | What it shows | Project usage |
|---|---|---|
| `.head(n)` | First n rows (default 5) | Quick visual check after loading |
| `.tail(n)` | Last n rows | Rarely needed here, but useful for sorted data |
| `.shape` | (rows, columns) tuple | Verified `(2212, 29)` for `dim_customers` |
| `.columns` | List of column names | Sanity-checking column names before referencing them |
| `.info()` | Column names, dtypes, non-null counts, memory | Confirmed 0 missing values remain post-cleaning, all dtypes correct |
| `.describe()` | count/mean/std/min/25%/50%/75%/max for numeric columns | Got real quartiles used throughout [18_STATISTICS_FROM_ZERO.md](18_STATISTICS_FROM_ZERO.md) |

**Interview Q:** *"`.info()` aur `.describe()` mein farak?"* → `.info()` structure batata hai (types, nulls, memory); `.describe()` numeric summary statistics batata hai (mean, spread, quartiles). Dono complementary hain, ek dusre ko replace nahi karte.

## 4. Selecting Data — `.loc` vs. `.iloc`

- **`.loc[row_label, column_label]`** — label-based selection (by name).
- **`.iloc[row_position, column_position]`** — position-based selection (by integer index, like array indexing).
- **Tiny example:** `df.loc[0, "income"]` (row labeled 0, column named "income") vs. `df.iloc[0, 5]` (first row, 6th column, whatever it's named).
- **Common mistake:** Using `.iloc` when column order might change (fragile) instead of `.loc` with the actual column name (robust).
- **Interview Q:** *"`.loc` aur `.iloc` mein kab konsa use karoge?"* → Column/row **naam** se refer karna ho toh `.loc`; **position** (integer index) se ho toh `.iloc`. `.loc` generally safer/more readable hai.

## 5. Filtering Rows

- **Syntax:** `df[df["column"] condition]`
- **Example (from this project's logic, `scripts/clean_data.py`):**
```python
implied_age = 2014 - df["Year_Birth"]
df = df[implied_age <= 90]          # keep only plausible ages

df = df[df["Income"] != 666666]      # drop the specific outlier row
```
- **Interview Q:** *"Pandas filtering SQL `WHERE` se kaise related hai?"* → Conceptually identical — dono "keep only rows matching a condition." Pandas mein condition ek boolean Series banata hai (`True`/`False` per row), jo phir DataFrame ko index karta hai.

## 6. Sorting

- **Syntax:** `df.sort_values("column", ascending=False)`
- **Project usage (notebook):** `.sort_values("acceptance_rate_pct", ascending=False)` when ranking campaigns — SQL's `ORDER BY` equivalent.

## 7. Missing Values

| Function | What | Project usage |
|---|---|---|
| `.isna()` / `.isnull()` | Boolean mask of missing cells | Used to detect the 24 missing `Income` rows in Phase 1 |
| `.dropna(subset=["col"])` | Removes rows with missing values in specified column(s) | `df.dropna(subset=["Income"])` in `scripts/clean_data.py` — drops the 24 rows rather than imputing |
| `.fillna(value)` | Replaces missing values with a specified value | **Not used in this project** — we chose to drop, not fill, given the small % missing (see [10_DATA_CLEANING.md](10_DATA_CLEANING.md) for why) |

**Interview Q:** *"Aapne `fillna` kyun use nahi kiya?"* → Missing `Income` sirf 1.07% data thi — itna chhota % ki drop karna safe tha, aur impute karna (jaise median se fill) is sensitive segmentation field mein ek artificial assumption inject karta.

## 8. Duplicates

| Function | What | Project usage |
|---|---|---|
| `.duplicated()` | Boolean mask — True for repeat rows | `df['ID'].duplicated().sum()` → confirmed 0 duplicate customer IDs (Phase 1) |
| `.drop_duplicates()` | Removes duplicate rows | **Not needed** — genuinely 0 duplicates found |

## 9. Value Counts & GroupBy

| Function | What | Project usage |
|---|---|---|
| `.value_counts()` | Count of each unique value in a column | `dim_customers["segment"].value_counts()` — real segment sizes |
| `.groupby("col")` | Splits rows into buckets by a column's value (pandas' `GROUP BY`) | `fact_campaign.groupby("campaign_name")["accepted"].agg(...)` |
| `.agg(name=("col","func"))` | Named aggregation — multiple summary stats in one call | `.agg(customers_accepted="sum", customers_targeted="count")` |
| `.assign(new_col=lambda d: ...)` | Adds a computed column in a chain, without a separate assignment line | `.assign(acceptance_rate_pct=lambda d: 100 * d["customers_accepted"] / d["customers_targeted"])` |

**Interview Q:** *"Pandas `groupby` SQL `GROUP BY` se conceptually same hai?"* → Haan — dono "split into groups by a key, then aggregate within each group." Pandas mein aage Python processing continue kar sakte ho (charts, further merge), SQL mein result seedha ek result-set hota hai.

## 10. Merge (pandas' JOIN)

- **Syntax:** `df1.merge(df2, on="key_column")`
- **Project usage:** `fact_campaign.merge(dim_customers[["customer_id", "segment", "total_spend"]], on="customer_id")` — attaches each customer's segment onto every campaign-response row so segment-level acceptance rate can be computed.
- **Types (`how=` parameter):** `"inner"` (default, matches SQL INNER JOIN), `"left"`, `"right"`, `"outer"` (matches SQL FULL) — this project only needed the default inner merge, same reasoning as the SQL JOIN discussion in [05_DATA_MODEL_AND_DATABASE.md](05_DATA_MODEL_AND_DATABASE.md).
- **Interview Q:** *"Merge mein `on=` na likhein toh?"* → Pandas apne aap common-named columns pe merge karne ki koshish karega — explicit `on=` hamesha safer/clearer hai.

## 11. Datetime Operations

- **Syntax:** `pd.to_datetime(df["column"], format="%Y-%m-%d")`
- **Project usage:** `scripts/clean_data.py`: `df["Dt_Customer"] = pd.to_datetime(df["Dt_Customer"], format="%Y-%m-%d")` — converts a text-typed date into a real datetime, unlocking date arithmetic like `(ANALYSIS_REFERENCE_DATE - df["Dt_Customer"]).dt.days` (used to derive `customer_tenure_days`).
- **Common mistake:** Trying to do date math (subtraction, comparisons) on a column that's still `object`/text type — it either errors or silently does wrong string-comparison logic.

## 12. Creating Calculated Columns

- **Syntax:** `df["new_col"] = <expression using existing columns>`
- **Project usage (from `scripts/clean_data.py`):**
```python
df["Age"] = ANALYSIS_REFERENCE_DATE.year - df["Year_Birth"]
df["Total_Children"] = df["Kidhome"] + df["Teenhome"]
df["TotalSpend"] = df[MNT_COLUMNS].sum(axis=1)          # axis=1 = sum ACROSS columns, per row
df["TotalPurchases"] = df["NumWebPurchases"] + df["NumCatalogPurchases"] + df["NumStorePurchases"]
df["NumCampaignsAccepted"] = df[list(CAMPAIGN_COLUMNS.keys())].sum(axis=1)
```
- **Interview Q:** *"`axis=1` kya karta hai `.sum()` mein?"* → `axis=1` = row-wise sum (across columns, one result per row); `axis=0` (default) = column-wise sum (down rows, one result per column). Getting this backwards is a very common beginner mistake.

## 13. `pd.melt()` — Wide to Long (Unpivot)

- **What:** Converts several "wide" columns into two columns: a label column + a value column, with more rows.
- **Project usage:**
```python
long = wide.melt(id_vars="customer_id", var_name="campaign_column", value_name="accepted")
```
Turned 6 wide `AcceptedCmp*`/`Response` columns into a single long `fact_campaign_response` table (13,272 rows). Full reasoning: [10_DATA_CLEANING.md](10_DATA_CLEANING.md) Section 3.

## 14. `pd.qcut()` — Quantile-based Binning

- **What:** Splits a numeric column into N equal-sized groups (by count, not by value range) — used directly for RFM scoring.
- **Project usage (from `scripts/segment_customers.py`):**
```python
df["R_score"] = pd.qcut(df["recency"], 4, labels=[4, 3, 2, 1]).astype(int)   # reversed: low recency = best
df["M_score"] = pd.qcut(df["total_spend"], 4, labels=[1, 2, 3, 4]).astype(int)
```
- **Common mistake (a real gotcha we handled):** `pd.qcut` can fail with "Bin edges must be unique" if too many rows share the exact same value. For `total_purchases`, we used `.rank(method="first")` before `qcut` specifically to break ties so 4 equal-sized bins are always possible.

## 15. Pandas Function Cheat Sheet

| Function | One-line purpose |
|---|---|
| `read_csv` | Load a CSV |
| `head`/`tail` | Peek at rows |
| `shape`/`columns`/`dtypes` | Structure check |
| `info`/`describe` | Summary of structure / numeric stats |
| `.loc`/`.iloc` | Select by label / by position |
| Boolean filtering (`df[cond]`) | Row filter (like SQL `WHERE`) |
| `sort_values` | Sort (like SQL `ORDER BY`) |
| `isna`/`dropna`/`fillna` | Detect / remove / fill missing values |
| `duplicated`/`drop_duplicates` | Detect / remove duplicate rows |
| `value_counts` | Count of each category |
| `groupby` + `agg` | Aggregate by category (like SQL `GROUP BY`) |
| `assign` | Add a computed column in a chain |
| `merge` | Join two DataFrames (like SQL `JOIN`) |
| `to_datetime` | Parse text into a real date type |
| `melt` | Wide → long (unpivot) |
| `qcut` | Quantile-based binning |

## 16. What I Should Remember

1. Almost every pandas concept here has a direct SQL equivalent — that's not a coincidence, it's the same relational-thinking, different syntax.
2. `melt` and `qcut` are the two "advanced-looking" functions actually used — and both map to a concrete real need (unpivoting for the star schema, quartile-scoring for RFM), not used for show.
3. We chose `.dropna()` over `.fillna()` deliberately (small %, avoids injecting assumptions) — always be ready to justify this kind of choice, not just describe the syntax.

---
*Next: [10_DATA_CLEANING.md](10_DATA_CLEANING.md)*
