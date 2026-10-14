# 04 — Dataset Deep Dive

🔴 MUST KNOW

Source of truth: [docs/01_dataset_understanding.md](../01_dataset_understanding.md) and [docs/02_data_cleaning.md](../02_data_cleaning.md). This file re-presents it in the WHAT/WHY/HOW/BUSINESS-QUESTION template for interview readiness.

## 1. Dataset Identity

- **Name:** Customer Personality Analysis (a.k.a. "iFood Marketing Campaign" dataset)
- **Source:** Real iFood (Brazilian food-delivery company) Data Analyst hiring case, mirrored publicly on Kaggle, **CC0 Public Domain** license
- **Raw file:** `data/raw/ifood_marketing_campaign_raw.csv` — **2,240 rows × 29 columns**
- **After cleaning:** **2,212 rows** (28 dropped, 98.75% retained) — see [10_DATA_CLEANING.md](10_DATA_CLEANING.md)
- **Grain (what one row means):** one row = **one customer**

## 2. Categorical vs. Numerical Data (general concept, first)

### GENERAL CONCEPT

- **Numerical data:** measurable quantities — can do math on them (add, average). Two types: **continuous** (any value in a range, e.g., `Income`) and **discrete** (whole-number counts, e.g., `NumWebPurchases`).
- **Categorical data:** labels/groups — can't meaningfully average them. Two types: **nominal** (no natural order, e.g., `Marital_Status`) and **ordinal** (has a natural order, e.g., "Low/Medium/High" spend tier — our dataset has no pre-built ordinal column, but we *create* one, e.g., RFM scores 1-4).
- **Identifiers:** unique labels used only to distinguish rows, never averaged or grouped-by for insight (e.g., `customer_id`).
- **Dates:** need special handling (parsing to a real date type) before arithmetic works.

### MY PROJECT

| Type | Columns |
|---|---|
| Numerical (continuous) | `income`, `total_spend`, `mnt_wines`...`mnt_gold_prods` |
| Numerical (discrete/count) | `recency`, `total_purchases`, `num_web_visits_month`, `num_campaigns_accepted`, `kidhome`, `teenhome` |
| Categorical (nominal) | `education`, `marital_status`, `channel`, `campaign_name` |
| Categorical (ordinal, derived) | `R_score`/`F_score`/`M_score` (1-4), `segment` (has an implied best-to-worst order) |
| Identifier | `customer_id` |
| Date | `dt_customer` |
| Flag (0/1, technically numeric but used like categorical) | `complain`, `accepted` |

## 3. Full Data Dictionary — `dim_customers` (2,212 rows, one row per customer)

| Column | What Is It? | Why Important? | How Used? | Business Question It Helps Answer |
|---|---|---|---|---|
| `customer_id` | Unique customer identifier (Primary Key) | Every join/lookup depends on this being unique | Join key to both fact tables | "Which customer is this?" |
| `year_birth`, `age` | Birth year / derived age (as of 2014-12-31) | Demographic segmentation input | Age-band grouping (SQL `CASE WHEN`) | "Do older customers spend differently?" |
| `education` | Education level (5 categories) | Demographic segmentation | `GROUP BY education` | "Which education segment responds more?" |
| `marital_status` | Marital status (recoded to 6 clean categories) | Demographic segmentation | `GROUP BY marital_status` | "Does family status relate to spend?" |
| `income` | Yearly household income | Core segmentation/spend-driver variable | RFM-adjacent analysis, correlation with spend | "Do richer customers spend/behave differently?" |
| `kidhome`, `teenhome`, `total_children` | Children/teens at home | Family-size segmentation | `CASE WHEN total_children = 0` | "Does family size affect spend?" |
| `dt_customer`, `customer_tenure_days` | Enrollment date / derived days-as-customer | Loyalty-adjacent measure | Not deeply used yet, available for future work | "How long has this person been a customer?" |
| `recency` | Days since last purchase | **Recency** pillar of RFM | Quartile-scored in segmentation | "Who's recently active vs. going cold?" |
| `mnt_wines`...`mnt_gold_prods` (6 cols) | $ spent per product category (2 yrs) | Real revenue measure | Summed into `total_spend` | "What's our real revenue?" |
| `total_spend` (derived) | Sum of the 6 `mnt_*` columns | **Monetary** pillar of RFM; core revenue KPI | Quartile-scored, averaged by segment | "Who are our highest-value customers?" |
| `num_deals_purchases` | Purchases made using a discount | Discount-seeking behavior indicator | Funnel Stage 3 ("used a deal") | "How discount-driven is this customer base?" |
| `num_web_visits_month` | Website visits in the *last month* (snapshot) | Engagement proxy | Correlated against income (Insight 7) | "How often do people browse?" |
| `total_purchases` (derived) | `num_web + num_catalog + num_store` purchases | **Frequency** pillar of RFM | Quartile-scored in segmentation | "How often does this customer buy?" |
| `num_campaigns_accepted` (derived) | Count of the 6 campaigns accepted (0-5) | Engagement-depth / funnel Stage 4 | Segmentation validation, funnel | "How responsive is this customer to campaigns?" |
| `complain` | Complained in last 2 years (0/1) | Basic satisfaction proxy | Simple rate calculation | "Are customers unhappy?" |
| `R_score`, `F_score`, `M_score`, `rfm_score`, `segment` | RFM quartile scores + final segment label | **The segmentation output itself** | Everything in Phase 5/9 | "Which group is this customer in?" |

## 4. Full Data Dictionary — `fact_campaign_response` (13,272 rows, one row per customer × campaign)

| Column | What Is It? | Why Important? |
|---|---|---|
| `customer_id` | Foreign Key → `dim_customers.customer_id` | Links back to who the customer is |
| `campaign_name` | Which of the 6 campaigns (Cmp1-Cmp6) | Lets us `GROUP BY campaign_name` for comparison |
| `accepted` | 1 = accepted, 0 = did not | The core conversion signal |

**Why this shape (long/tidy, not wide):** the raw file had 6 separate columns (`AcceptedCmp1`...`Response`). Unpivoting into one `campaign_name` column with 6 rows per customer means "which campaign is best" is answered with **one** `GROUP BY`, not 6 near-identical queries.

## 5. Full Data Dictionary — `fact_channel_purchases` (6,636 rows, one row per customer × channel)

| Column | What Is It? | Why Important? |
|---|---|---|
| `customer_id` | Foreign Key → `dim_customers.customer_id` | Links back to who the customer is |
| `channel` | Web / Catalog / Store | Lets us `GROUP BY channel` for comparison |
| `num_purchases` | How many purchases through that channel (2 yrs) | Core channel-efficiency measure |

## 6. Missing Values, Duplicates, Data Quality (recap)

### GENERAL CONCEPT

- **Missing value:** a cell with no recorded data (`NaN`/`NULL`). Must be detected before any average/sum, because most tools silently exclude or error on them.
- **Duplicate:** two or more rows that are identical (or share the same identifier) when they shouldn't be.
- **Inconsistent category:** the "same" category spelled/labeled multiple different ways (e.g., "Alone" vs. "Single").

### MY PROJECT

| Issue | Found | Fixed how |
|---|---|---|
| Missing `Income` | 24 rows (1.07%) | Dropped (small %, avoids injecting an imputed assumption into a core segmentation field) |
| Duplicate rows/IDs | 0 | No action needed |
| Impossible `Year_Birth` | 3 rows (ages 114-121) | Dropped |
| Extreme `Income` outlier | 1 row (666,666 vs. next-highest 162,397) | Dropped |
| Inconsistent `Marital_Status` | 7 rows ("Alone"/"Absurd"/"YOLO") | Recoded to "Single"/"Other" |
| Text-typed date | `Dt_Customer` stored as text | Parsed to real datetime |

Full WHAT/WHY/HOW/WHY-this-approach reasoning: [10_DATA_CLEANING.md](10_DATA_CLEANING.md).

## 7. Relationships Diagram

```
dim_customers (1) ───< fact_campaign_response (many)   [one customer -> 6 campaign rows]
dim_customers (1) ───< fact_channel_purchases (many)    [one customer -> 3 channel rows]
```

Full explanation of Primary/Foreign Keys and JOIN types: [05_DATA_MODEL_AND_DATABASE.md](05_DATA_MODEL_AND_DATABASE.md).

## 8. INTERVIEW

**Q: "Aapke dataset mein kitne rows/columns hain, aur cleaning ke baad kitne bache?"**
> "Raw: 2,240 rows, 29 columns. Cleaning ke baad: 2,212 rows (1.25% dropped) — dim_customers 24 columns + derived RFM columns, split into 2 additional fact tables."

**Q: "Aapko missing values kaise mile, aur decide kaise kiya drop karna hai ya fill karna?"**
> "`Income` mein 24 missing values the (1.07%). Maine ek chhoti si bias-check bhi ki — missing-income customers ka response rate baaki sabse kaafi kam tha (4.17% vs 15.03%), lekin sample itna chhota tha ki confidently kuch keh nahi sakte. Chhota % hone ki wajah se, maine drop karna choose kiya — impute karta toh ek artificial assumption inject hoti is sensitive field mein."

**Q: "Aapke dataset ki sabse badi limitation kya hai?"**
> "Ye single-company, single-time-period data hai — koi cross-company generalization claim nahi kar sakte. Aur channel yahan sales-channel hai, ad-channel nahi — isliye CTR/Impressions jaisi metrics calculate nahi ho sakti."

## 9. What I Should Remember

1. Grain of `dim_customers` = one row per customer; grain of both fact tables = one row per (customer, event-type) pair.
2. Only ONE column (`Income`) had missing values — everything else was complete.
3. 4 distinct real data-quality issues were found and fixed, each with an explicit, defensible reason (not "just because").
4. `Z_CostContact`/`Z_Revenue` are the dataset's own stated assumption constants — not something we invented, but always labeled as an assumption when used.

---
*Next: [05_DATA_MODEL_AND_DATABASE.md](05_DATA_MODEL_AND_DATABASE.md)*
