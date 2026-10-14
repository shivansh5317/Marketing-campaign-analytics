# 36 — Glossary (A-Z)

🟡 GOOD TO KNOW — a quick-lookup reference for every term used across this study book.

Format: **Term → Simple Hinglish Meaning → Small Example → Project Relevance.**

## A

| Term | Meaning | Example | Project Relevance |
|---|---|---|---|
| **Acceptance Rate** | Kitne % targeted logo ne offer accept kiya | 7/100 accept = 7% | Core campaign KPI; Cmp6=15.05% best |
| **Acquisition** | Naya customer haasil karna | First-time buyer | Dataset doesn't distinguish new-vs-existing customers |
| **Aggregate Function** | Rows ko ek summary number mein convert karna | `SUM`, `AVG`, `COUNT` | Used in nearly every SQL query |
| **At Risk (segment)** | RFM segment — fairly recent, low frequency/spend | 560 customers, 25.3% of base | [17_CUSTOMER_SEGMENTATION.md](17_CUSTOMER_SEGMENTATION.md) |
| **Audience** | Jin logo ko target kiya ja raha hai | "25-35 age group" | Assumed = all 2,212 customers per campaign |

## B-C

| Term | Meaning | Example | Project Relevance |
|---|---|---|---|
| **Bar Chart** | Categories compare karne ka chart | Education counts | Used for campaign/channel/segment comparisons |
| **Boxplot** | Spread + outliers dikhane wala chart (min/Q1/median/Q3/max) | Spend by segment | Shows Champions have wide spread, Lost tightly clustered |
| **CAC** | Customer Acquisition Cost — ek responder "lane" ka avg cost | Cost/Accepted | Cmp6=19.93 (cheapest), Cmp2=221.20 |
| **Calculated Column** | Power BI: per-row fixed value, not dynamic | Age Band via SWITCH | Planned for Power BI build spec |
| **Campaign** | Ek specific marketing effort | "Diwali Sale" | 6 real campaigns in our data (Cmp1-6) |
| **CASE WHEN** | SQL ka if/else | Bucketing age into bands | Used for income/age/recency bands |
| **Categorical Data** | Label/group data, no averaging | Education, Marital Status | 4 categorical columns in `dim_customers` |
| **Champions (segment)** | RFM segment — best, recent+frequent+high-spend | 534 customers, 24.1% of base, 49.1% of revenue | Headline segmentation finding |
| **Channel** | Medium through which company reaches/transacts | Email, Social — but ours = Web/Catalog/Store (sales channel) | Reframed explicitly in this project |
| **Complaint Rate** | % customers jinhone complain kiya | 0.9% here | Low, but possible "silent churn" caveat |
| **Conversion / Conversion Rate** | Desired action complete hona / uska % | Purchase, offer-accept | = our Campaign Acceptance Rate |
| **Correlation** | Do numbers saath kitna badalte hain (-1 to +1) | income↔spend = +0.79 | Never treated as causation |
| **CTE (Common Table Expression)** | Named, chainable query step (`WITH`) | `WITH x AS (...)` | Used for campaign profitability calc |
| **CTR (Click-Through Rate)** | Clicks/Impressions × 100 | 500/10,000=5% | ❌ Not available in this project |

## D-F

| Term | Meaning | Example | Project Relevance |
|---|---|---|---|
| **DAX** | Power BI's formula language | `DIVIDE(a,b,0)` | Used in the Power BI build spec |
| **Data Cleaning** | Fixing errors/inconsistencies in raw data | Dropping impossible ages | 5 real issues fixed, 2,240→2,212 rows |
| **Data Model** | Tables + relationships | Star schema | `dim_customers` + 2 fact tables |
| **Dataset** | A complete collection of related data | `ifood_marketing_campaign_raw.csv` | 2,240 rows × 29 columns raw |
| **Dimension** | Column used to group/filter by | Education, Campaign Name | Used in every `GROUP BY` |
| **DISTINCT** | Removes duplicate values | `SELECT DISTINCT city` | `COUNT(DISTINCT campaign_name)` |
| **Engagement** | How actively a customer interacts | Visits, purchases | Measured via visits/purchases/responses |
| **Engagement Proxy** | A directional-only metric due to mismatched time windows | Visits (monthly) vs. purchases (2yr) | Explicitly NOT called a conversion rate |
| **Fact Table** | Records events/measurements, many rows | `fact_campaign_response` | 13,272 rows |
| **Foreign Key** | Column pointing to another table's Primary Key | `customer_id` in fact tables | Links facts back to `dim_customers` |
| **Frequency (RFM)** | How often a customer purchases | `total_purchases` | RFM's "F" pillar |
| **Funnel** | Sequential stages with drop-off at each | Impression→Click→Purchase | Ours: Total→Purchase→Deal→Campaign-accept |

## G-K

| Term | Meaning | Example | Project Relevance |
|---|---|---|---|
| **GROUP BY** | Buckets rows by a column's value for aggregation | `GROUP BY campaign_name` | Core of nearly every SQL analysis |
| **HAVING** | Filters on an aggregated value, after grouping | `HAVING SUM(x)=0` | Finds fully-inactive customers |
| **Histogram** | Shows a numeric column's distribution/shape | Income distribution | 6 built in the Phase 7 notebook |
| **Impression** | An ad being shown once | — | ❌ Not available in this project |
| **Insight** | A meaningful observation from data | "72.7% never responded" | 11 documented in Chapter 21 |
| **IQR** | Interquartile Range = Q3 - Q1 | Income IQR = 33,253.5 | Outlier-resistant spread measure |
| **JOIN** | Combines rows from 2 tables via a shared key | `JOIN ... ON a.id=b.id` | Always INNER JOIN in this project |
| **KPI** | A metric important enough to track regularly | Acceptance Rate | Campaign/channel/segment KPIs throughout |

## L-O

| Term | Meaning | Example | Project Relevance |
|---|---|---|---|
| **Lead** | A potential customer who hasn't purchased yet | Form-fill, no purchase | Not directly tracked in this dataset |
| **LIMIT** | Restrict result to top-N rows | `LIMIT 10` | Top-10-spenders query |
| **Lost / Hibernating (segment)** | RFM segment — long-inactive, low value | 269 customers, 12.2% of base | Lowest-priority segment for heavy spend |
| **Loyal Customers (segment)** | RFM segment — solid, moderately engaged | 849 customers, 38.4% of base (largest) | Upsell-to-Champion candidates |
| **Mean** | Average (sum/count) | [2,4,6]→4 | `total_spend` mean = 607.3 |
| **Measure** | Numeric column aggregated (SUM/AVG) | Total Spend | Used throughout KPI calculations |
| **Median** | Middle value when sorted | [2,4,6,8]→5 | `total_spend` median = 397 |
| **Merge** | Pandas' JOIN | `df1.merge(df2, on="key")` | Attaching segment onto campaign rows |
| **Metric** | A number quantifying business performance | Conversion Rate | General term for all KPIs |
| **Missing Value** | A cell with no recorded data | `Income` = NaN | 24 rows (1.07%), dropped |
| **Mode** | Most frequent value | Education mode = Graduation | Used for categorical summaries |
| **Monetary (RFM)** | How much a customer has spent | `total_spend` | RFM's "M" pillar |
| **NTILE(n)** | Splits rows into n equal-sized buckets | `NTILE(10)` | VIP spend-decile identification |
| **Normalization** | Splitting data to reduce redundancy | Wide table → star schema | Done in Phase 2 |
| **Observation vs. Interpretation vs. Causation** | Fact vs. hedged explanation vs. proven cause | See [13_FUNNEL_ANALYSIS.md](13_FUNNEL_ANALYSIS.md) | The project's most-repeated discipline |
| **Outlier** | A value far from the rest of the data | Income=666,666 | 2 types: error (removed) vs. genuine (kept) |

## P-R

| Term | Meaning | Example | Project Relevance |
|---|---|---|---|
| **Pandas** | Python's data-table library | `pd.read_csv(...)` | Used for all cleaning/EDA |
| **Percentile** | Value below which X% of data falls | 90th percentile | General concept behind quartiles |
| **Pie Chart** | Share-of-whole chart, best for few categories | Segment revenue share | Used only for the 4-segment case |
| **Population** | The full group being studied | All 2,212 customers | We have the full population, not a sample |
| **Power BI** | Microsoft BI/dashboard tool | — | Build spec ready, not yet physically built |
| **Primary Key** | Uniquely identifies each row | `customer_id` | Verified 0 duplicates |
| **Profit** | Revenue minus Cost | 77-300=-223 | Always paired with Revenue, never alone |
| **Prospect** | A potential customer | — | Not directly tracked in this dataset |
| **Quartile** | Splits data into 4 equal-sized groups (25/50/75%) | Q1, Median, Q3 | Literal mechanism behind RFM scoring |
| **RANK()** | Window function — ranks rows without collapsing them | `RANK() OVER (ORDER BY x DESC)` | Campaign ROI ranking |
| **Recency** | Days since last purchase | `recency` column | RFM's "R" pillar, reversed scoring |
| **Recommendation** | Suggested action based on an insight | "Prioritize Champions" | 7 hedged recommendations in Chapter 22 |
| **Relationship (database)** | How two tables connect via PK-FK | `dim_customers`→`fact_*` | One-to-many, both fact tables |
| **Retention** | Keeping existing customers active | Loyalty programs | Only loosely proxied (Recency/Tenure) |
| **Revenue** | Total money coming in | `total_spend` = 1,343,277 | Two different "revenue" concepts — don't confuse product revenue with campaign Z_Revenue |
| **RFM** | Recency/Frequency/Monetary segmentation | Champions, Loyal, At Risk, Lost | This project's actual segmentation method |
| **ROAS** | Revenue/Cost ratio (cost not subtracted) | 0.8x | Background concept, not separately calculated |
| **ROI** | (Revenue-Cost)/Cost × 100 | Cmp6=-44.8% | Core campaign efficiency metric |

## S-Z

| Term | Meaning | Example | Project Relevance |
|---|---|---|---|
| **Sample** | A subset of a population | Survey respondents | Not applicable — we have the full population |
| **Scatter Plot** | Shows relationship between 2 numeric variables | Income vs. Spend | Colored by segment in the notebook |
| **Segment / Segmentation** | Grouping customers by shared traits | RFM segments | 4 segments, rule-based, no ML |
| **Series (pandas)** | A single column (1D) | `df["income"]` | Every DataFrame column is technically a Series |
| **SQL** | Structured Query Language, for relational data | `SELECT...FROM...WHERE` | 8 `.sql` files, SELECT through window functions |
| **Standard Deviation** | Spread of data, same units as original | `total_spend` std=602.5 | High relative to mean → motivates segmentation |
| **Star Schema** | 1 dimension + fact table(s) design | `dim_customers`+2 facts | Built in Phase 2 via unpivoting |
| **Subquery** | A query inside a query | `(SELECT COUNT(*)...)` | Used for % of total, derived tables |
| **Total Spend** | Sum of 6 product-spend columns | `total_spend` | Our Monetary/Revenue measure |
| **Variance** | Average squared deviation from the mean | σ² | Rarely reported directly — std dev preferred |
| **Visit** | A website visit | `num_web_visits_month` | Monthly snapshot — different window than purchases |
| **WHERE** | Row-level filter, before grouping | `WHERE age>18` | Basic filtering throughout |
| **Window Function** | Aggregate-like calc that keeps every row | `RANK()`, `NTILE()` | Used in `sql/08_advanced_analysis.sql` |
| **Z_CostContact / Z_Revenue** | Dataset's own assumption constants (3 and 11) | Used for Cost/Revenue formulas | Always labeled as an assumption, never fact |

## What I Should Remember

1. This glossary is a lookup tool, not a teaching chapter — for depth, follow the project-relevance pointer to the full chapter.
2. Terms marked "❌ Not available" (CTR, Impression, Prospect, Lead, Acquisition in the new-vs-existing sense) should never be accidentally claimed as part of this project.
3. If a term feels unfamiliar here, that's a signal to revisit its full chapter before an interview.

---

This completes the full study book — [00_START_HERE.md](00_START_HERE.md) has the recommended study order if you're returning to this later.
