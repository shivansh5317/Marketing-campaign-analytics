# 06 — SQL From Zero

🔴 MUST KNOW

Har concept: **What / Why / Syntax / Tiny Example / Common Mistake / Analyst Use Case / Project Usage / Interview Question.** Examples yahan generic hain (project-specific queries [07_SQL_USED_IN_PROJECT.md](07_SQL_USED_IN_PROJECT.md) mein hain).

## 1. SELECT / FROM

- **What:** `SELECT` decides *which columns* you want to see; `FROM` decides *which table* they come from.
- **Why:** Every SQL query starts here — it's how you retrieve data at all.
- **Syntax:** `SELECT column1, column2 FROM table_name;`
- **Example:** `SELECT name, age FROM students;`
- **Common mistake:** `SELECT *` (all columns) in production queries — slow and unclear; name only what you need.
- **Analyst use case:** Quick look at raw data before doing anything else.
- **Project usage:** Every query in `sql/*.sql` starts with a `SELECT ... FROM`.
- **Interview Q:** *"`SELECT *` kab avoid karna chahiye?"* → Jab table bada ho ya sirf kuch specific columns chahiye ho — explicit columns query ko readable aur fast rakhte hain.

## 2. WHERE (row-level filtering)

- **What:** Filters rows *before* any grouping happens — keeps only rows matching a condition.
- **Why:** Bina filter ke poora table process karna padta, jab humein sirf ek subset chahiye ho.
- **Syntax:** `SELECT * FROM table WHERE condition;`
- **Example:** `SELECT * FROM students WHERE age > 18;`
- **Common mistake:** `WHERE` ke andar aggregate function use karna (jaise `WHERE COUNT(*) > 5`) — ye invalid hai, iske liye `HAVING` chahiye (Section 6).
- **Analyst use case:** "Sirf active customers dikhao," "Sirf is mahine ka data."
- **Project usage:** `sql/04_funnel_analysis.sql` Query 3's `CASE WHEN` bucketing works alongside filtering logic.
- **Interview Q:** *"`WHERE` kab execute hota hai — `GROUP BY` se pehle ya baad?"* → Pehle. `WHERE` row-level filter hai, grouping se pehle chalta hai.

## 3. DISTINCT

- **What:** Duplicate values ko result se remove karta hai.
- **Why:** "Kitne unique X hain" jaanne ke liye.
- **Syntax:** `SELECT DISTINCT column FROM table;`
- **Example:** `SELECT DISTINCT city FROM customers;`
- **Common mistake:** `COUNT(column)` aur `COUNT(DISTINCT column)` ko same samajhna — pehla duplicates bhi ginta hai, doosra nahi.
- **Analyst use case:** "Humare paas kitne unique campaigns hain?"
- **Project usage:** `sql/01_campaign_overview.sql` Query 1: `COUNT(DISTINCT campaign_name)`.
- **Interview Q:** *"`DISTINCT` aur `GROUP BY` dono unique values de sakte hain — farak kya hai?"* → `DISTINCT` sirf unique rows return karta hai; `GROUP BY` unique groups return karta hai **plus** aggregate calculate karne deta hai har group ke liye. Sirf uniqueness chahiye toh `DISTINCT`, uniqueness + aggregation chahiye toh `GROUP BY`.

## 4. ORDER BY + LIMIT

- **What:** `ORDER BY` result ko sort karta hai; `LIMIT` sirf top-N rows rakhta hai.
- **Why:** "Best/worst N" jaise sawaalon ke liye.
- **Syntax:** `SELECT * FROM table ORDER BY column DESC LIMIT 5;`
- **Example:** `SELECT name, marks FROM students ORDER BY marks DESC LIMIT 3;` (top 3 scorers)
- **Common mistake:** `ORDER BY` bhool jaana aur assume karna data already sorted hai — SQL rows ka koi guaranteed default order nahi deta bina explicit `ORDER BY` ke.
- **Analyst use case:** "Top 10 highest-spending customers."
- **Project usage:** `sql/07_revenue_analysis.sql` Query 2 — top 10 spenders.
- **Interview Q:** *"`LIMIT` aur `TOP` mein farak?"* → `LIMIT` MySQL/SQLite/Postgres mein, `TOP` SQL Server mein — same purpose.

## 5. Aggregate Functions — COUNT, SUM, AVG, MIN, MAX

| Function | What it does | Example |
|---|---|---|
| `COUNT(*)` | Total rows | `COUNT(*)` |
| `COUNT(col)` | Non-null values in col | `COUNT(email)` |
| `SUM(col)` | Total of a numeric column | `SUM(revenue)` |
| `AVG(col)` | Average | `AVG(age)` |
| `MIN(col)` / `MAX(col)` | Smallest/largest value | `MIN(price)`, `MAX(price)` |

- **Why:** Ye poore table ko ek single summary number mein convert karte hain.
- **Common mistake:** `AVG` ko `NULL` values ke saath confuse karna — `AVG`/`SUM`/`COUNT(col)` automatically NULLs ko ignore karte hain (unhe 0 nahi maante); ye important hai jab aap manually average calculate kar rahe ho.
- **Analyst use case:** "Total revenue kitna hai," "Average order value kya hai."
- **Project usage:** Almost every query in `sql/*.sql` uses at least one of these.
- **Interview Q:** *"`COUNT(*)` aur `COUNT(column_name)` mein farak?"* → `COUNT(*)` saari rows ginta hai (NULLs included); `COUNT(column_name)` sirf un rows ko ginta hai jaha wo column NULL nahi hai.

## 6. GROUP BY + HAVING

- **What:** `GROUP BY` rows ko ek column ki value ke hisaab se buckets mein baantta hai, phir har bucket ke liye aggregate calculate hota hai. `HAVING` un buckets ko filter karta hai based on the **aggregated** value.
- **Why:** "Per category summary" chahiye ho tab (jaise "har campaign ka acceptance rate"). `HAVING` chahiye jab filter khud ek `SUM`/`COUNT` pe based ho — `WHERE` aggregate pe kaam nahi karta.
- **Syntax:**
```sql
SELECT category, SUM(value) AS total
FROM table
GROUP BY category
HAVING SUM(value) > 100;
```
- **Tiny example:** "Har department ka average salary dikhao, sirf un departments ka jinki total headcount 10 se zyada hai."
- **Common mistake:** `SELECT` list mein aisa column daalna jo na to `GROUP BY` mein hai na aggregate function ke andar — SQLite ise chup-chaap allow kar deta hai (kuch engines error dete hain), lekin result ambiguous/misleading ho sakta hai.
- **Analyst use case:** "Har channel ka total purchase," "Sirf un customers ko dikhao jinka total spend zero hai."
- **Project usage:** `sql/01_campaign_overview.sql` Query 2 (`GROUP BY campaign_name`); `sql/04_funnel_analysis.sql` Query 2 (`GROUP BY customer_id HAVING SUM(num_purchases) = 0` — finds fully-inactive customers).
- **Interview Q:** *"`WHERE` aur `HAVING` mein farak?"* → `WHERE` = row-level filter, `GROUP BY` se pehle. `HAVING` = group-level filter, `GROUP BY` ke baad, aggregated values pe.

## 7. CASE WHEN

- **What:** SQL ka if/else — ek column ki value ke basis pe ek naya label/value return karta hai.
- **Why:** Numeric values ko named buckets mein convert karna (jaise age → age-band), ya conditional counting/summing karna.
- **Syntax:**
```sql
SELECT
  CASE
    WHEN age < 35 THEN 'Young'
    WHEN age < 60 THEN 'Middle-aged'
    ELSE 'Senior'
  END AS age_group
FROM customers;
```
- **Common mistake:** `ELSE` clause bhool jaana — agar koi row kisi `WHEN` condition se match na kare aur `ELSE` na ho, result `NULL` ban jaata hai silently.
- **Analyst use case:** Income bands, age bands, "conditional counting" (e.g., counting rows where a condition is true, inside `SUM`/`COUNT`).
- **Project usage:** `sql/04_funnel_analysis.sql` Query 3 (income bands); `sql/02_channel_performance.sql` Query 2 (`SUM(CASE WHEN num_purchases = 0 THEN 1 ELSE 0 END)` — conditional counting).
- **Interview Q:** *"`CASE WHEN` ko aggregate function ke andar kyun use karte ho?"* → Ek condition-match hone pe 1, na hone pe 0 return karke, `SUM`/`COUNT` se "kitni rows condition match karti hain" nikal sakte hain — ek alag query likhne ki zaroorat nahi padti.

## 8. JOINs

Full explanation with analogies: [05_DATA_MODEL_AND_DATABASE.md](05_DATA_MODEL_AND_DATABASE.md) Section 3.

- **Syntax:** `SELECT ... FROM table_a a JOIN table_b b ON a.key = b.key;`
- **Common mistake:** JOIN ke baad `COUNT(*)` ko galat samajhna (fan-out) — pehle discuss ho chuka hai.
- **Project usage:** `sql/03_customer_analysis.sql` Query 3, `sql/04_funnel_analysis.sql` Query 3, `sql/06_conversion_analysis.sql` Query 3, `sql/07_revenue_analysis.sql` Query 3.

## 9. Subqueries

- **What:** Ek query ke andar doosri query — inner query pehle chalti hai, uska result outer query use karti hai.
- **Why:** Jab ek intermediate calculation chahiye ho jo direct ek single SQL clause mein na ho sake.
- **Syntax (scalar subquery — one value):**
```sql
SELECT (SELECT COUNT(*) FROM customers) AS total_customers;
```
- **Syntax (derived table — used like a table):**
```sql
SELECT COUNT(*) FROM (
    SELECT customer_id, SUM(amount) AS total
    FROM orders GROUP BY customer_id
    HAVING SUM(amount) = 0
);
```
- **Common mistake:** Subquery ko ek `SELECT` list ke andar use karna jab wo multiple rows return kare — scalar-position subquery ko **exactly ek row, ek column** return karna chahiye.
- **Analyst use case:** Percentage-of-total (denominator ek subquery se aata hai), "collapse then filter" patterns.
- **Project usage:** `sql/01_campaign_overview.sql` Query 1 (scalar); `sql/02_channel_performance.sql` Query 1 (denominator subquery); `sql/04_funnel_analysis.sql` Query 2 (derived table).
- **Interview Q:** *"Subquery aur JOIN mein kab konsa use karoge?"* → Agar sirf ek intermediate aggregated value chahiye (jaise "grand total"), subquery simple hai. Agar do tables ke columns ko row-by-row combine karna hai, JOIN zaroori hai.

## 10. CTEs (Common Table Expressions — `WITH`)

- **What:** Ek named, temporary result-set jo query ke andar ek "step" ki tarah define hota hai, phir aage use hota hai.
- **Why:** Complex multi-step logic ko readable, top-se-bottom steps mein todne ke liye — nested subqueries ka messy alternative.
- **Syntax:**
```sql
WITH step1 AS (
    SELECT category, SUM(value) AS total FROM table GROUP BY category
),
step2 AS (
    SELECT category, total, total * 0.1 AS tax FROM step1
)
SELECT * FROM step2;
```
- **Common mistake:** CTE ko "permanent/cached table" samajh lena — ye sirf us ek query ke duration ke liye exist karta hai, har baar re-evaluate hota hai.
- **Analyst use case:** Multi-step financial calculations (targeted → cost/revenue → profit/ROI) — bilkul jaisa humne kiya.
- **Project usage:** `sql/08_advanced_analysis.sql` Query 1 — 2-step CTE chain for full campaign profitability.
- **Interview Q:** *"CTE, subquery se better kyun hai yaha?"* → Naam se reusable hai, aur query top-se-bottom ek "story" ki tarah padhi ja sakti hai — especially jab steps chain karne hon.

## 11. Window Functions (basic — only what's genuinely used)

- **What:** Aggregate-jaisa calculation karte hain, lekin **rows ko collapse/group nahi karte** — har original row apni jagah rehti hai, bas ek extra calculated column mil jaata hai.
- **Why:** Jab "rank/percentile" chahiye ho, lekin individual rows bhi dikhni chahiye (GROUP BY unhe collapse kar deta).
- **Syntax:**
```sql
SELECT name, score, RANK() OVER (ORDER BY score DESC) AS rank
FROM students;

SELECT name, score, NTILE(4) OVER (ORDER BY score DESC) AS quartile
FROM students;
```
- **Common mistake:** `RANK()` aur `ROW_NUMBER()` ko same samajhna — `RANK()` ties ko same rank deta hai (aur agla number skip karta hai), `ROW_NUMBER()` hamesha unique sequential number deta hai.
- **Analyst use case:** "Har campaign ka rank," "Top 10% customers by spend (deciles)."
- **Project usage:** `sql/08_advanced_analysis.sql` Query 2 (`RANK() OVER (ORDER BY roi_pct DESC)`), Query 3 (`NTILE(10) OVER (ORDER BY total_spend DESC)` — VIP decile).
- **Interview Q:** *"Window function aur GROUP BY mein basic farak?"* → `GROUP BY` rows ko collapse karke ek summary row per group deta hai. Window function har original row ko rakhta hai, bas ek extra "computed-relative-to-a-group" column add karta hai.

**Note (deliberate scope limit):** Hum `LAG`/`LEAD`, complex multi-column `PARTITION BY`, ya recursive CTEs is project mein use nahi karte — dataset/business scope inhe genuinely zaroori nahi banata, aur unnecessarily advanced SQL dikhana khud ek red flag ho sakta hai interview mein ("kya inhe pata bhi hai ye kyun use ho raha hai, ya sirf impress karne ke liye daala hai").

## 12. What I Should Remember

1. Execution order (conceptually): `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY` → `LIMIT`.
2. `WHERE` = row filter (before grouping); `HAVING` = group filter (after grouping).
3. `COUNT(DISTINCT x)` ≠ `COUNT(x)` — always check which one a question actually needs.
4. Window functions keep every row; `GROUP BY` collapses rows.
5. Every concept here is actually used in this project — nothing here is "textbook only."

---
*Next: [07_SQL_USED_IN_PROJECT.md](07_SQL_USED_IN_PROJECT.md)*
