# 04 — SQL Learning & Analysis

Har query is file mein **actually SQLite ke against run karke verify ki gayi hai** — jo "Expected Output" niche dikh raha hai wo real output hai, koi guess nahi. Database ban chuka hai [scripts/load_to_sqlite.py](../scripts/load_to_sqlite.py) se, jo humare 3 processed CSVs (Phase 2) ko `data/processed/marketing_analytics.db` mein load karta hai, aur `customer_id`/`campaign_name`/`channel` pe explicit indexes banata hai (bina index ke, SQLite joins slow full-table-scan kar sakte hain — is se hum bachte hain).

**Reproduce karne ke liye:**
```powershell
python scripts/load_to_sqlite.py
sqlite3 -header -column data/processed/marketing_analytics.db ".read sql/01_campaign_overview.sql"
```

**Star schema recap** (poori detail [01_dataset_understanding.md](01_dataset_understanding.md) mein):
```
dim_customers (2,212 rows)              -- WHO: one row per customer
fact_campaign_response (13,272 rows)    -- WHAT HAPPENED: one row per (customer, campaign)
fact_channel_purchases (6,636 rows)     -- WHAT HAPPENED: one row per (customer, channel)
```

---

## sql/01_campaign_overview.sql

### Query 1 — Overall scale

- **Business question:** Hamare paas total kitne customers aur campaigns hain?
- **Why SQL:** Ye ek simple `COUNT` hai — SQL is tarah ke aggregation ke liye bilkul designed hai, bina poora data Excel/Python mein load kiye.
- **SQL concept used:** `SELECT`, scalar subquery (query ke andar query, jo ek single value return karti hai)
```sql
SELECT
    (SELECT COUNT(*) FROM dim_customers) AS total_customers,
    (SELECT COUNT(DISTINCT campaign_name) FROM fact_campaign_response) AS total_campaigns;
```
- **Line-by-line:** Do independent scalar subqueries — pehli `dim_customers` table mein total rows count karti hai, dusri `fact_campaign_response` mein `DISTINCT` (unique) campaign names count karti hai. `AS` se hum result column ko naam dete hain.
- **Expected output:** `total_customers = 2212`, `total_campaigns = 6`
- **Interpretation:** Baseline scale confirm hui — matches Phase 1/2 ke findings.
- **Interview Q:** *"Scalar subquery normal subquery se kaise alag hai?"* → Scalar subquery hamesha exactly ek row, ek column return karti hai — isliye use kisi bhi expression ki jagah (jaise `SELECT` list mein) daal sakte ho.

### Query 2 — Acceptance rate per campaign

- **Business question:** Konsi campaign sabse zyada/kam accept hui?
- **Why SQL:** `GROUP BY` exactly is liye bana hai — "har category ke liye ek summary row do."
- **SQL concept used:** `GROUP BY`, aggregate functions (`SUM`, `COUNT`), `ROUND`, `ORDER BY`
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
- **Line-by-line:** `GROUP BY campaign_name` sabse pehle saari rows ko 6 buckets (ek per campaign) mein baant deta hai. Har bucket ke andar, `SUM(accepted)` batata hai kitne 1's the (accept), `COUNT(*)` batata hai us bucket mein total kitni rows thi (= kitne customers target hue). `100.0 *` isliye likha hai taaki integer division na ho (SQLite mein `100 * x / y` agar sab integer hon toh galat truncated result de sakta hai). `ORDER BY ... DESC` best-performing campaign ko top pe laata hai.
- **Expected output:**

| campaign_name | customers_accepted | customers_targeted | acceptance_rate_pct |
|---|---|---|---|
| Cmp6 | 333 | 2212 | 15.05 |
| Cmp4 | 164 | 2212 | 7.41 |
| Cmp3 | 163 | 2212 | 7.37 |
| Cmp5 | 161 | 2212 | 7.28 |
| Cmp1 | 142 | 2212 | 6.42 |
| Cmp2 | 30 | 2212 | 1.36 |

- **Interpretation:** Cmp6 (the most recent campaign) ne baaki sab se dogune se zyada acceptance rate paayi. Cmp2 sabse kam successful rahi — sirf 1.36%.
- **Interview Q:** *"`100.0 *` kyun likha, sirf `100 *` kyun nahi?"* → SQLite (aur kai SQL engines) mein agar dono operands integer hon toh division bhi integer ho sakti hai (decimals cut jaate hain) — `100.0` explicitly float banata hai taaki decimals safe rahen.

### Query 3 — Best & worst campaign only

- **Business question:** Sirf top aur bottom campaign chahiye, poori list nahi.
- **Why SQL:** `LIMIT` exactly "top N rows only" ke liye hai.
- **SQL concept used:** `ORDER BY` + `LIMIT`
- **Expected output:** Best = Cmp6 (15.05%), Worst = Cmp2 (1.36%)
- **Interpretation:** Same as Query 2, sirf filtered view.
- **Interview Q:** *"`LIMIT` aur `TOP` mein kya farak hai?"* → `LIMIT` MySQL/SQLite/Postgres mein use hota hai, `TOP` SQL Server mein — same purpose, syntax alag.

---

## sql/02_channel_performance.sql

### Query 1 — Channel share %

- **Business question:** Sales mein sabse zyada contribution konse channel (Web/Catalog/Store) ka hai?
- **Why SQL:** Percentage-of-total ek classic `GROUP BY` + subquery pattern hai.
- **SQL concept used:** `GROUP BY`, aggregate (`SUM`), subquery in denominator
```sql
SELECT
    channel,
    SUM(num_purchases) AS total_purchases,
    ROUND(100.0 * SUM(num_purchases) / (SELECT SUM(num_purchases) FROM fact_channel_purchases), 1) AS channel_share_pct
FROM fact_channel_purchases
GROUP BY channel
ORDER BY total_purchases DESC;
```
- **Line-by-line:** Outer query channel-wise total purchases nikalti hai. Andar wali `(SELECT SUM(num_purchases) FROM fact_channel_purchases)` **poore table ka grand total** nikalti hai (bina `GROUP BY` ke) — isse har channel ka % share calculate hota hai.
- **Expected output:** Store 12,844 (46.2%) · Web 9,043 (32.5%) · Catalog 5,911 (21.3%)
- **Interpretation:** Physical Store abhi bhi sabse bada channel hai, lekin Web kaafi close second hai.
- **Interview Q:** *"Percentage-of-total nikalne ke do tareeke SQL mein kya hain?"* → (1) Subquery denominator mein (jaisa yahan), (2) Window function `SUM(...) OVER ()` — dono valid, window function version single-pass mein zyada efficient hota bade data pe.

### Query 2 — Avg purchases per customer & zero-purchase count by channel

- **Business question:** Har channel individually kitna "per customer" efficient hai, aur kitne customers us channel ko bilkul use nahi karte?
- **SQL concept used:** `AVG`, `CASE WHEN` inside aggregate (conditional counting)
- **Line-by-line:** `CASE WHEN num_purchases = 0 THEN 1 ELSE 0 END` har row ko 1 ya 0 mein convert karta hai, phir `SUM()` un 1's ko gin leta hai — ye "conditional counting" ka standard SQL pattern hai.
- **Expected output:** Store: avg 5.81, 14 zero-purchase customers · Web: avg 4.09, 48 zero · Catalog: avg 2.67, **575 zero** (sabse zyada customers Catalog bilkul use nahi karte)
- **Interpretation:** Catalog channel ka low overall share (21.3%) partly isliye hai kyunki 575 customers (26%) ise kabhi use hi nahi karte — ye ek genuinely different insight hai "total volume kam hai" se.
- **Interview Q:** *"`CASE WHEN` ko `COUNT`/`SUM` ke andar kyun use karte ho?"* → Conditional aggregation ke liye — "count rows matching X condition" bina alag query likhe.

---

## sql/03_customer_analysis.sql

### Query 1 & 2 — Customers by Education / Marital Status

- **Business question:** Customer base ka demographic makeup kya hai, aur kaunsa group zyada spend karta hai?
- **SQL concept used:** `GROUP BY`, `AVG`
- **Expected output (Education):** Graduation 1,115 (50.4%) is the largest group; Basic is smallest (54, 2.4%)
- **Expected output (Marital Status, by avg spend):** `Other` group (only 4 people — our recoded Absurd/YOLO rows) spends highest on average (808) but is statistically tiny; among the real groups, Widow (728) and Divorced (613) spend more than Married (591)
- **Interpretation:** Sample sizes matter — a 4-person "Other" group's high average isn't reliable enough to act on; always check `num_customers` alongside any average.
- **Interview Q:** *"Ek group ka average sabse zyada hai lekin sirf 4 log hain usme — kya action lenge?"* → Reliable insight ke liye us conclusion ko ignore/deprioritize karenge; small-sample averages misleading ho sakte hain.

### Query 3 — Acceptance rate by Education (JOIN)

- **Business question:** Kaunsa education segment campaigns ko zyada accept karta hai?
- **Why SQL:** Ye do alag tables (`dim_customers` ka demographic + `fact_campaign_response` ka event data) ko jodne ke liye `JOIN` chahiye.
- **SQL concept used:** `INNER JOIN`, `GROUP BY`, fan-out awareness
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
- **Line-by-line:** `JOIN ... ON d.customer_id = f.customer_id` har customer ki demographic row ko uski **6 campaign rows** se jodta hai — matlab ek customer JOIN ke baad 6 baar repeat hoga (ek per campaign). Isiliye `COUNT(DISTINCT d.customer_id)` use kiya (unique customers ke liye), jabki plain `COUNT(*)` (denominator mein) customer×campaign pairs ginta hai — ye "JOIN fan-out" hai, ek bahut common real-world gotcha.
- **Expected output:** PhD highest (9.17%), Basic lowest (2.47%)
- **Interpretation:** Higher education segments campaigns ko zyada accept karte hain — possibly relevant for targeting priority.
- **Interview Q:** *"JOIN ke baad `COUNT(*)` kya represent karta hai — original rows ya naya combined rows?"* → Naya combined (joined) row count — agar one-to-many join hai, toh ye original "one" side ke row count se zyada hoga. Hamesha check karo ki tumhara denominator kis grain (level of detail) par hai.

---

## sql/04_funnel_analysis.sql

### Query 1 — Visits vs. Purchases (funnel proxy)

- **Business question:** Website engagement (visits) vs actual purchases mein kitna gap hai?
- **⚠️ Caveat (repeated deliberately):** `num_web_visits_month` ek 1-month snapshot hai; web purchases 2-year cumulative hain. Ye ek **directional proxy** hai, precise funnel nahi.
- **Expected output:** Total monthly web visits (summed) = 11,771; Total 2-year web purchases = 9,043
- **Interpretation:** Absolute numbers ko literally "conversion rate" mat bolna — bas ek rough engagement signal ki tarah treat karo.

### Query 2 — Fully dropped-off customers (GROUP BY + HAVING)

- **Business question:** Kitne customers ne teeno channels (Web+Catalog+Store) mila ke bhi ek bhi purchase nahi ki?
- **Why SQL:** `HAVING` zaroori hai kyunki hum ek **aggregated value** (`SUM(num_purchases)`) pe filter kar rahe hain — `WHERE` aggregate functions pe kaam nahi karta.
- **SQL concept used:** `GROUP BY` + `HAVING`, subquery
```sql
SELECT COUNT(*) AS customers_with_zero_purchases
FROM (
    SELECT customer_id, SUM(num_purchases) AS total_purchases
    FROM fact_channel_purchases
    GROUP BY customer_id
    HAVING SUM(num_purchases) = 0
);
```
- **Line-by-line:** Andar wali query har customer ka total purchases (teeno channels mila ke) nikalti hai, `HAVING SUM(num_purchases) = 0` sirf un customers ko rakhti hai jinka total zero hai. Outer query bas unhe count kar leti hai.
- **Expected output:** **6 customers**
- **Interpretation:** Bahut chhota group (0.27%) — zyada critical issue nahi hai, but worth a note in the audit.
- **Interview Q:** *"`WHERE` aur `HAVING` mein kya farak hai?"* → `WHERE` row-level filter hai (GROUP BY se pehle chalta hai), `HAVING` group-level/aggregated filter hai (GROUP BY ke baad chalta hai).

### Query 3 — Funnel by income segment

- **Business question:** Kya engagement/conversion pattern income ke hisaab se badalta hai?
- **SQL concept used:** `CASE WHEN` bucketing + `JOIN`
- **Expected output:**

| Income Band | Customers | Avg Monthly Visits | Avg Web Purchases (2yr) |
|---|---|---|---|
| Under 35k | 549 | 7.00 | 2.00 |
| 35k–68k | 1,096 | 5.70 | 4.49 |
| 68k+ | 567 | 2.96 | **5.33** |

- **Interpretation:** Genuinely striking, real, counter-intuitive pattern — **lower-income customers visit the website more often but buy far less**, while higher-income customers visit less but convert much better. This is exactly the kind of "worth investigating" (not "proven cause") finding we'll carry into Business Insights (Phase 9) — possible hypotheses: pricing friction, browsing-without-buying behavior, or the lower-income group being more price-sensitive/comparison-shopping.
- **Interview Q:** *"Ye pattern dekh ke aap directly bol sakte ho ki 'low income walo ko discounts do'?"* → Nahi — data sirf **association** dikhata hai, causation nahi. Hum bolenge "this may indicate... worth investigating further," seedha solution nahi.

---

## sql/05_segment_analysis.sql

Teen simple, explainable (non-ML) segments banaye — Age band, Family (kids at home), aur Income×Family combined grid.

- **SQL concept used (all 3 queries):** `CASE WHEN` for bucketing, `GROUP BY`, `AVG`
- **Expected output highlights:**
  - Age 65+ spends the most on average (928) vs Under-35 (573)
  - **No kids at home → 1,104 avg spend; Has kids → 409 avg spend** (customers without kids spend nearly **2.7x** more)
  - Combined grid: Higher-Income + No-Kids = 1,380 avg spend (highest) vs Lower-Income + Has-Kids = 145 (lowest)
- **Interpretation:** Family size looks like a stronger differentiator of spend than income alone in this data — a genuinely useful, real segmentation finding for Phase 5.
- **Interview Q:** *"Segmentation ke liye clustering/ML kyun nahi use kiya?"* → Business-explainable rule-based segments (CASE WHEN buckets) kaafi hain jab data simple/low-dimensional ho aur stakeholders ko "why is this customer in this segment" seedha samajh aana chahiye — ML clustering black-box ho sakta hai aur interview mein defend karna mushkil.

---

## sql/06_conversion_analysis.sql

### Query 1 — Overall conversion rate

- **SQL concept used:** Subquery (collapse per-customer first), conditional `SUM(CASE WHEN...)`
- **Expected output:** 604 / 2,212 = **27.31%** converted at least once
- **Interpretation:** Matches Phase 3's "72.7% never responded" finding exactly (100 − 72.69 ≈ 27.31, rounding).

### Query 2 — Serial responders (GROUP BY + HAVING)

- **Expected output:** Exactly 10 customers accepted 5 campaigns (the maximum found in the data — nobody accepted all 6).
- **Interpretation:** A very small, identifiable "super responder" group — good VIP/loyalty targeting candidates.

### Query 3 — Conversion by Recency band (JOIN)

- **Expected output:**

| Recency Band | Customers | Avg Acceptance Rate |
|---|---|---|
| 0–24 days (very recent) | 560 | **9.52%** |
| 25–49 days | 550 | 7.55% |
| 50–74 days | 562 | 6.88% |
| 75–99 days (least recent) | 540 | **5.93%** |

- **Interpretation:** A clean, monotonic, real pattern — the more recently a customer purchased, the more likely they are to accept a new campaign. This directly validates why "Recency" is one of the three pillars of RFM segmentation (Phase 5).
- **Interview Q:** *"Ye pattern RFM segmentation ko kaise justify karta hai?"* → Recency genuinely predicts responsiveness in this data — isse business-logically hum recently-active customers ko zyada target kar sakte hain higher expected ROI ke saath.

---

## sql/07_revenue_analysis.sql

### Query 1 & 2 — Revenue by segment, Top 10 spenders

- **Expected output:** Graduation segment = 51.6% of total revenue (largest group, not necessarily highest per-customer); Top spender ties at 2,525 (matches the max we saw in Phase 1/2).

### Query 3 — Responders vs Non-Responders (real revenue comparison)

- **Business question:** Kya campaign-responders generally higher-value customers bhi hote hain?
- **SQL concept used:** Subquery + `JOIN`, `CASE WHEN`
- **Expected output:**

| Group | Customers | Avg Total Spend |
|---|---|---|
| Never Responded | 1,608 | 461 |
| Responder (1+ campaigns) | 604 | **997** |

- **Interpretation:** Responders spend **more than double** on average compared to never-responders. This is a real, verified, important finding — it suggests campaign responsiveness and customer value are correlated, which strengthens the case for identifying and targeting "responder-like" segments (Phase 5/9). Careful: this is a **correlation**, not proof that campaigns caused the extra spending — high-value customers may simply engage with everything more, including campaigns.
- **Interview Q:** *"Iska matlab campaign ne unhe zyada spend karaya?"* → Zaroori nahi — reverse bhi ho sakta hai (already-high-spending customers campaigns ko bhi zyada respond karte hain). Causation claim karne ke liye A/B test chahiye hota, sirf observational data se nahi.

---

## sql/08_advanced_analysis.sql

### Query 1 — Full campaign profitability (CTE)

- **Business question:** Konsi campaign sabse profitable (ya sabse kam loss-making) thi, cost/revenue assumption ke saath?
- **Why SQL (CTE specifically):** Poora calculation (targeted → cost/revenue → profit/ROI/CAC) ek hi readable query mein chain karna hai bina nested subqueries ke mess ke — `WITH` (CTE) isi ke liye hai.
- **SQL concept used:** `WITH` (Common Table Expression), chained CTEs
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
- **Line-by-line:** `campaign_stats` (first CTE) is a normal GROUP BY summary. `campaign_financials` (second CTE) **reads from the first CTE like a table** and adds the cost/revenue math. The final `SELECT` reads from the second CTE and adds profit/ROI/CAC. Each CTE is a named, readable "step" — much easier to debug than one giant nested query.
- **Expected output:** exactly matches the Phase 3 KPI table (Cmp6 best at −44.8% ROI/19.93 CAC; Cmp2 worst at −95.0% ROI/221.20 CAC) — **a good cross-check that our Python and SQL numbers agree.**
- **Interview Q:** *"CTE aur subquery mein kya farak hai, CTE kyun better hai yaha?"* → Dono functionally similar hain, but CTE ek baar define hoke naam se multiple jagah reuse ho sakta hai aur query top-se-bottom padhne mein zyada readable hoti hai — especially jab steps chain karne hon.

### Query 2 — Ranking campaigns by ROI (window function)

- **Business question:** Har campaign ka rank kya hai (bina rows ko group/collapse kiye)?
- **Why a window function (not just ORDER BY):** `ORDER BY` sirf display order badalta hai; `RANK() OVER (...)` ek **actual rank number column** deta hai jise hum aage filter/compare kar sakte hain (jaise "WHERE roi_rank <= 3").
- **SQL concept used:** Window function `RANK() OVER (ORDER BY ...)`
- **Expected output:** Cmp6 = rank 1, ... Cmp2 = rank 6.
- **Interview Q:** *"`RANK()` aur `ROW_NUMBER()` mein kya farak hai?"* → Agar do rows ki value bilkul same ho, `RANK()` unhe same rank deta hai (aur agla rank number skip karta hai), `ROW_NUMBER()` hamesha unique sequential number deta hai chahe values same hon.

### Query 3 — Spend deciles (NTILE window function)

- **Business question:** Top 10% (VIP) customers by spend kaun hain, aur unka threshold kya hai?
- **Why a window function:** `NTILE(10)` automatically 2,212 customers ko 10 barabar-size groups mein baant deta hai — bina manually percentile calculate kiye.
- **SQL concept used:** Window function `NTILE(n) OVER (ORDER BY ...)`
- **Expected output:** Decile 1 (top 10%, ~221 customers) spends between **1,536 and 2,525** — this is our real, data-driven "VIP threshold."
- **Interpretation:** Business action: customers spending 1,536+ could be flagged as a VIP/high-value segment for special campaign treatment — a genuinely useful, defensible output.
- **Interview Q:** *"NTILE groups hamesha exactly equal size hote hain?"* → Jitna possible ho utna equal — agar total rows `n` se exactly divide na ho, kuch groups mein 1 extra row mil sakti hai (yahan 2,212/10 = 221.2, isliye kuch deciles mein 221 hi customers hain, sab equal).

---

## SQL Concepts Used — Quick Glossary

| Concept | Where first used | One-line meaning |
|---|---|---|
| `SELECT` / scalar subquery | 01, Q1 | Query-inside-query returning one value |
| `GROUP BY` + aggregates | 01, Q2 | Summarize rows into per-category totals |
| `ORDER BY` + `LIMIT` | 01, Q3 | Sort and take top-N rows |
| `CASE WHEN` (bucketing) | 04, Q3 | Turn a numeric column into named buckets |
| `CASE WHEN` (conditional aggregate) | 02, Q2 | Count/sum only rows matching a condition |
| `JOIN` | 03, Q3 | Combine two tables via a shared key |
| `GROUP BY` + `HAVING` | 04, Q2 | Filter on an aggregated (summed) value |
| Subquery (derived table) | 04, Q2 | Use a query's result as if it were a table |
| `WITH` (CTE) | 08, Q1 | Named, readable, chainable query steps |
| Window function `RANK()` | 08, Q2 | Rank rows without collapsing them |
| Window function `NTILE(n)` | 08, Q3 | Split rows into n equal-sized buckets |

We deliberately did **not** use more advanced window functions (`LAG`/`LEAD`, complex partitions) or recursive CTEs — this dataset and business scope don't genuinely need them, and the brief explicitly asked to avoid complexity added "just to look impressive."

---
*Next: Phase 5 — `docs/05_customer_segmentation.md` (a proper RFM-style segmentation model, built on top of the fields and SQL patterns established here).*
