# 07 — SQL Used In My Project

🔴 MUST KNOW

Every query below is copied **exactly** from the real `.sql` files in `sql/` and was actually run against `data/processed/marketing_analytics.db` (built by `scripts/load_to_sqlite.py`). Full narrative-style walkthrough with more discussion: [docs/04_sql_learning.md](../04_sql_learning.md) — this file is the structured, interview-drill version covering **every query**.

**Reproduce yourself:**
```powershell
python scripts/load_to_sqlite.py
sqlite3 -header -column data/processed/marketing_analytics.db ".read sql/01_campaign_overview.sql"
```

---

## sql/01_campaign_overview.sql

**Business question:** Which campaigns performed best/worst, and what does our customer/campaign base look like overall?

### Query 1 — Overall scale
```sql
SELECT
    (SELECT COUNT(*) FROM dim_customers) AS total_customers,
    (SELECT COUNT(DISTINCT campaign_name) FROM fact_campaign_response) AS total_campaigns;
```
- **Breakdown:** Two independent scalar subqueries, each returning one number.
- **Result:** `total_customers=2212`, `total_campaigns=6`.
- **Interview Q:** *"Scalar subquery normal subquery se kaise alag hai?"* → Hamesha exactly ek row, ek column return karti hai — kisi expression ki jagah use ho sakti hai.

### Query 2 — Acceptance rate per campaign
```sql
SELECT
    campaign_name,
    SUM(accepted) AS customers_accepted,
    COUNT(*) AS customers_targeted,
    ROUND(100.0 * SUM(accepted) / COUNT(*), 2) AS acceptance_rate_pct
FROM fact_campaign_response
GROUP BY campaign_name
ORDER BY acceptance_rate_pct DESC;
```
- **Breakdown:** `GROUP BY` splits into 6 buckets; `SUM(accepted)` counts 1's; `COUNT(*)` counts total rows per bucket; `100.0 *` forces float division (SQLite truncates integer÷integer).
- **Result:** Cmp6 15.05% (best) → Cmp2 1.36% (worst).
- **Edge case:** Assumes all 2,212 customers were targeted by every campaign (true here — every row has a value for every campaign column).
- **Interview Q:** *"`100.0 *` kyun, sirf `100 *` kyun nahi?"* → Integer÷integer truncates decimals in SQLite; `100.0` forces float math.

### Query 3 — Best & worst campaign only
```sql
SELECT campaign_name, ROUND(100.0 * SUM(accepted) / COUNT(*), 2) AS acceptance_rate_pct
FROM fact_campaign_response GROUP BY campaign_name ORDER BY acceptance_rate_pct DESC LIMIT 1;
-- (and ASC LIMIT 1 for the worst)
```
- **Interview Q:** *"`LIMIT` vs `TOP`?"* → Same purpose, different engines (SQLite/MySQL/Postgres use `LIMIT`, SQL Server uses `TOP`).

---

## sql/02_channel_performance.sql

**Business question:** Which sales channel (Web/Catalog/Store) is doing the most work, and how efficient is each?

### Query 1 — Channel share %
```sql
SELECT
    channel,
    SUM(num_purchases) AS total_purchases,
    ROUND(100.0 * SUM(num_purchases) / (SELECT SUM(num_purchases) FROM fact_channel_purchases), 1) AS channel_share_pct
FROM fact_channel_purchases
GROUP BY channel
ORDER BY total_purchases DESC;
```
- **Breakdown:** The subquery in the denominator computes the grand total (no `GROUP BY`), so each channel's row can compute its own % of that whole.
- **Result:** Store 46.2% > Web 32.5% > Catalog 21.3%.
- **Alternative approach:** A window function `SUM(num_purchases) OVER ()` does the same thing in one pass — valid, more efficient on large data, but the subquery version is arguably more readable for a beginner.

### Query 2 — Avg purchases per customer & zero-purchase count
```sql
SELECT
    channel,
    ROUND(AVG(num_purchases), 2) AS avg_purchases_per_customer,
    SUM(CASE WHEN num_purchases = 0 THEN 1 ELSE 0 END) AS customers_with_zero_purchases
FROM fact_channel_purchases
GROUP BY channel
ORDER BY avg_purchases_per_customer DESC;
```
- **Result:** Catalog has by far the most zero-purchase customers (**575**, i.e., 26.0%) despite a "middling" average.
- **Interview Q:** *"`CASE WHEN` ko `SUM` ke andar kyun?"* → Conditional counting — "count rows matching X" without a separate query.

---

## sql/03_customer_analysis.sql

**Business question:** How many customers do we have, and which demographic segments respond better?

### Query 3 — Acceptance rate by Education (the JOIN query)
```sql
SELECT
    d.education,
    COUNT(DISTINCT d.customer_id) AS num_customers,
    SUM(f.accepted) AS total_accepts,
    ROUND(100.0 * SUM(f.accepted) / COUNT(*), 2) AS avg_acceptance_rate_pct
FROM dim_customers d
JOIN fact_campaign_response f ON d.customer_id = f.customer_id
GROUP BY d.education
ORDER BY avg_acceptance_rate_pct DESC;
```
- **Breakdown:** JOIN fans each customer out to 6 rows (one per campaign); `COUNT(DISTINCT d.customer_id)` recovers the true customer count, while the plain `COUNT(*)` in the denominator is intentionally the customer×campaign pair count (matching what `SUM(f.accepted)` is a fraction of).
- **Result:** PhD highest (9.17%), Basic lowest (2.47%).
- **Interview Q:** *"JOIN ke baad `COUNT(*)` kya represent karta hai?"* → Original row count nahi — combined (fanned-out) row count. Hamesha check karo kis grain par ho.

---

## sql/04_funnel_analysis.sql

**Business question:** Where does engagement drop off between visiting and purchasing?
**⚠️ Caveat repeated on purpose:** `num_web_visits_month` is a 1-month snapshot; purchases are 2-year cumulative — Query 1 is a **directional proxy**, not a precise conversion rate.

### Query 2 — Fully dropped-off customers
```sql
SELECT COUNT(*) AS customers_with_zero_purchases
FROM (
    SELECT customer_id, SUM(num_purchases) AS total_purchases
    FROM fact_channel_purchases
    GROUP BY customer_id
    HAVING SUM(num_purchases) = 0
);
```
- **Breakdown:** Inner query collapses to one row per customer with their all-channel total; `HAVING SUM(...) = 0` keeps only the fully-inactive ones; outer query just counts them.
- **Result:** **6 customers** (0.27%) — a tiny group.
- **Interview Q:** *"`WHERE` se ye kyun nahi ho sakta tha?"* → `WHERE` aggregate value (`SUM`) pe filter nahi kar sakta — wo `GROUP BY` se pehle chalta hai, jab tak sum calculate hi nahi hua hota.

### Query 3 — Funnel by income band
```sql
SELECT
    CASE
        WHEN d.income < 35000 THEN '1) Under 35k'
        WHEN d.income < 68000 THEN '2) 35k-68k'
        ELSE '3) 68k+'
    END AS income_band,
    COUNT(DISTINCT d.customer_id) AS num_customers,
    ROUND(AVG(d.num_web_visits_month), 2) AS avg_monthly_web_visits,
    ROUND(AVG(c.num_purchases), 2) AS avg_web_purchases_2yr
FROM dim_customers d
JOIN fact_channel_purchases c ON d.customer_id = c.customer_id AND c.channel = 'Web'
GROUP BY income_band
ORDER BY income_band;
```
- **Note the JOIN condition has 2 parts:** `ON d.customer_id = c.customer_id AND c.channel = 'Web'` — this filters to only the Web rows *as part of the join itself*, cleaner than joining everything and filtering after.
- **Result:** Under-35k: 7.00 visits / 2.00 purchases; 68k+: 2.96 visits / **5.33 purchases** — the "income paradox" (Insight 7 in [21_BUSINESS_INSIGHTS.md](21_BUSINESS_INSIGHTS.md)).

---

## sql/05_segment_analysis.sql

**Business question:** What simple, explainable (non-ML) segments can we build from demographics?

### Query 2 — Family-size segment
```sql
SELECT
    CASE WHEN total_children = 0 THEN 'No kids at home' ELSE 'Has kids at home' END AS family_segment,
    COUNT(*) AS num_customers,
    ROUND(AVG(total_spend), 0) AS avg_total_spend,
    ROUND(AVG(num_deals_purchases), 2) AS avg_deal_purchases
FROM dim_customers
GROUP BY family_segment;
```
- **Result:** No kids = 1,104 avg spend vs. Has kids = 409 — a **2.7x** difference, a stronger differentiator than income alone in this data.
- **Interview Q:** *"Segmentation ke liye ML clustering kyun nahi?"* → Business-explainable `CASE WHEN` buckets kaafi hain jab data simple/low-dimensional ho — stakeholders ko "why is this customer in this bucket" turant samajh aata hai.

---

## sql/06_conversion_analysis.sql

**Business question:** What share of customers convert at all, and who are the extremes?

### Query 2 — Serial responders
```sql
SELECT customer_id, SUM(accepted) AS campaigns_accepted
FROM fact_campaign_response
GROUP BY customer_id
HAVING SUM(accepted) >= 2
ORDER BY campaigns_accepted DESC
LIMIT 10;
```
- **Result:** Exactly **10 customers** accepted 5 campaigns (the max found — nobody accepted all 6).

### Query 3 — Conversion by Recency band
```sql
SELECT
    CASE
        WHEN d.recency < 25 THEN '1) 0-24 days (very recent)'
        WHEN d.recency < 50 THEN '2) 25-49 days'
        WHEN d.recency < 75 THEN '3) 50-74 days'
        ELSE '4) 75-99 days (least recent)'
    END AS recency_band,
    COUNT(DISTINCT d.customer_id) AS num_customers,
    ROUND(100.0 * SUM(f.accepted) / COUNT(*), 2) AS avg_acceptance_rate_pct
FROM dim_customers d
JOIN fact_campaign_response f ON d.customer_id = f.customer_id
GROUP BY recency_band
ORDER BY recency_band;
```
- **Result:** A clean, monotonic pattern — 9.52% → 7.55% → 6.88% → 5.93% as recency worsens. Directly validates why Recency is one-third of RFM.

---

## sql/07_revenue_analysis.sql

**Business question:** Which segments drive the most revenue, and do responders actually spend more?

### Query 3 — Responders vs. Non-Responders
```sql
SELECT
    CASE WHEN sub.campaigns_accepted > 0 THEN 'Responder (1+ campaigns)' ELSE 'Never Responded' END AS responder_group,
    COUNT(*) AS num_customers,
    ROUND(AVG(d.total_spend), 0) AS avg_total_spend
FROM dim_customers d
JOIN (
    SELECT customer_id, SUM(accepted) AS campaigns_accepted
    FROM fact_campaign_response GROUP BY customer_id
) sub ON d.customer_id = sub.customer_id
GROUP BY responder_group;
```
- **Result:** Responders avg spend = 997, Never-Responded = 461 — responders spend **more than double**.
- **Interview Q:** *"Iska matlab campaign ne unhe zyada spend karaya?"* → Nahi zaroori — reverse bhi possible hai (already-high-spenders zyada respond bhi karte hain). Correlation, not proven causation.

---

## sql/08_advanced_analysis.sql

**Business question:** Which campaign is truly most profitable, and who are the top-value customers?

### Query 1 — Full campaign profitability (2-step CTE)
```sql
WITH campaign_stats AS (
    SELECT campaign_name, COUNT(*) AS customers_targeted, SUM(accepted) AS customers_accepted
    FROM fact_campaign_response GROUP BY campaign_name
),
campaign_financials AS (
    SELECT campaign_name, customers_accepted,
           customers_targeted * 3 AS cost, customers_accepted * 11 AS revenue
    FROM campaign_stats
)
SELECT campaign_name, customers_accepted, cost, revenue,
       revenue - cost AS profit,
       ROUND(100.0 * (revenue - cost) / cost, 1) AS roi_pct,
       ROUND(1.0 * cost / customers_accepted, 2) AS cac
FROM campaign_financials
ORDER BY roi_pct DESC;
```
- **Breakdown:** First CTE = plain `GROUP BY` summary. Second CTE reads the first *as if it were a table* and adds cost/revenue math. Final `SELECT` reads the second and adds profit/ROI/CAC — a readable, named, step-by-step chain.
- **Result:** Matches the Phase 3 KPI table exactly (cross-check that Python and SQL agree) — Cmp6 best (-44.8% ROI), Cmp2 worst (-95.0%).

### Query 2 — Rank campaigns by ROI (window function)
```sql
WITH campaign_roi AS (
    SELECT campaign_name,
           ROUND(100.0 * (SUM(accepted) * 11 - COUNT(*) * 3) / (COUNT(*) * 3), 1) AS roi_pct
    FROM fact_campaign_response GROUP BY campaign_name
)
SELECT campaign_name, roi_pct, RANK() OVER (ORDER BY roi_pct DESC) AS roi_rank
FROM campaign_roi;
```
- **Interview Q:** *"`RANK()` vs `ROW_NUMBER()`?"* → Ties get the same rank (and the next rank number is skipped) with `RANK()`; `ROW_NUMBER()` always gives unique sequential numbers even for ties.

### Query 3 — Spend deciles (NTILE)
```sql
WITH ranked_customers AS (
    SELECT customer_id, total_spend, NTILE(10) OVER (ORDER BY total_spend DESC) AS spend_decile
    FROM dim_customers
)
SELECT spend_decile, COUNT(*) AS num_customers,
       MIN(total_spend) AS min_spend_in_decile, MAX(total_spend) AS max_spend_in_decile
FROM ranked_customers
GROUP BY spend_decile ORDER BY spend_decile;
```
- **Result:** Decile 1 (top 10%, ~221 customers) spends **1,536–2,525** — a real, data-driven VIP threshold.

---

## Quick-Reference: Every SQL Concept Used, and Where

| Concept | First used in |
|---|---|
| Scalar subquery | 01, Q1 |
| `GROUP BY` + aggregates | 01, Q2 |
| `ORDER BY` + `LIMIT` | 01, Q3 |
| Subquery-in-denominator (% of total) | 02, Q1 |
| `CASE WHEN` (conditional aggregate) | 02, Q2 |
| `JOIN` | 03, Q3 |
| `CASE WHEN` (bucketing) + multi-condition JOIN | 04, Q3 |
| `GROUP BY` + `HAVING` | 04, Q2 |
| `WITH` (CTE, chained) | 08, Q1 |
| `RANK() OVER (...)` | 08, Q2 |
| `NTILE(n) OVER (...)` | 08, Q3 |

## What I Should Remember

1. I can point to the exact file + query number behind any number I quote.
2. I deliberately did NOT use `LAG`/`LEAD`, recursive CTEs, or complex partitions — not needed here, and using them just to look advanced would be a red flag.
3. Every JOIN in this project is an INNER JOIN — because the data's shape didn't need LEFT/RIGHT/FULL, not because I don't know them ([05_DATA_MODEL_AND_DATABASE.md](05_DATA_MODEL_AND_DATABASE.md)).

---
*Next: [08_PYTHON_FROM_ZERO.md](08_PYTHON_FROM_ZERO.md)*
