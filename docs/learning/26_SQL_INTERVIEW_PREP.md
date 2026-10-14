# 26 — SQL Interview Prep

🔴 MUST KNOW

Format per topic: **Concept → Simple Example → Project Example → Interview Question → Practice Question.**

## SELECT

- **Concept:** Choose which columns to retrieve.
- **Simple example:** `SELECT name FROM students;`
- **Project example:** `SELECT campaign_name, SUM(accepted) FROM fact_campaign_response ...`
- **Interview Q:** "SELECT * kab avoid karoge?" → When the table is wide/large or only specific columns are needed.
- **Practice Q:** Write a query to select `customer_id` and `income` from `dim_customers`.

## WHERE

- **Concept:** Row-level filter, before grouping.
- **Simple example:** `SELECT * FROM students WHERE age > 18;`
- **Project example:** Used implicitly within `CASE WHEN` bucketing conditions across multiple project queries.
- **Interview Q:** "WHERE GROUP BY se pehle ya baad chalta hai?" → Pehle.
- **Practice Q:** Write a query to find all customers with `income > 100000`.

## DISTINCT

- **Concept:** Removes duplicate values from the result.
- **Simple example:** `SELECT DISTINCT city FROM customers;`
- **Project example:** `COUNT(DISTINCT campaign_name)` — `sql/01_campaign_overview.sql` Query 1.
- **Interview Q:** "DISTINCT aur GROUP BY mein farak?" → DISTINCT sirf uniqueness deta hai; GROUP BY uniqueness + aggregation deta hai.
- **Practice Q:** Write a query to count distinct `segment` values in `dim_customers`.

## ORDER BY / LIMIT

- **Concept:** Sort results; restrict to top-N rows.
- **Simple example:** `SELECT * FROM students ORDER BY marks DESC LIMIT 3;`
- **Project example:** `sql/07_revenue_analysis.sql` Query 2 — top 10 spenders.
- **Interview Q:** "LIMIT aur TOP mein farak?" → Engine-specific syntax, same purpose.
- **Practice Q:** Write a query for the 5 customers with the highest `recency` (least recently active).

## GROUP BY

- **Concept:** Buckets rows by a column's value, enabling per-category aggregation.
- **Simple example:** `SELECT dept, AVG(salary) FROM employees GROUP BY dept;`
- **Project example:** `sql/01_campaign_overview.sql` Query 2 — acceptance rate per campaign.
- **Interview Q:** "GROUP BY ke bina agar aggregate function use karen toh kya hota hai?" → Poora table ek single group ban jaata hai, ek hi summary row milti hai (jaise `SELECT COUNT(*) FROM table;` — bina GROUP BY, ye already ek "whole table" aggregate hai).
- **Practice Q:** Write a query for the average `total_spend` per `education` level.

## HAVING

- **Concept:** Filters on an *aggregated* value, after grouping.
- **Simple example:** `SELECT dept, COUNT(*) FROM employees GROUP BY dept HAVING COUNT(*) > 10;`
- **Project example:** `sql/04_funnel_analysis.sql` Query 2 — customers with `SUM(num_purchases) = 0`.
- **Interview Q:** "WHERE se ye kyun nahi ho sakta?" → WHERE aggregate pe filter nahi kar sakta, GROUP BY se pehle chalta hai.
- **Practice Q:** Write a query to find customers who accepted 3 or more campaigns.

## JOIN

- **Concept:** Combine rows from two tables via a shared key.
- **Simple example:** `SELECT s.name, g.marks FROM students s JOIN grades g ON s.id = g.student_id;`
- **Project example:** `sql/03_customer_analysis.sql` Query 3 — `dim_customers` JOIN `fact_campaign_response`.
- **Interview Q:** "JOIN ke baad COUNT(*) galat kyun ho sakta hai?" → Fan-out — one-to-many join rows ko multiply kar deta hai.
- **Practice Q:** Write a query to find average `total_spend` by `channel` (joining `dim_customers` and `fact_channel_purchases`).

## CASE WHEN

- **Concept:** SQL's if/else — bucket numeric values into named categories, or do conditional aggregation.
- **Simple example:** `CASE WHEN age < 18 THEN 'Minor' ELSE 'Adult' END`
- **Project example:** `sql/04_funnel_analysis.sql` Query 3 — income bands.
- **Interview Q:** "ELSE bhool jaane se kya hota hai?" → Non-matching rows silently NULL ban jaate hain.
- **Practice Q:** Write a query bucketing customers into "Low Spend" (<300), "Medium Spend" (300-1000), "High Spend" (>1000).

## Aggregations (COUNT/SUM/AVG/MIN/MAX)

- **Concept:** Collapse many rows into one summary number.
- **Simple example:** `SELECT AVG(price) FROM products;`
- **Project example:** Used in nearly every query in `sql/*.sql`.
- **Interview Q:** "COUNT(*) vs COUNT(column) farak?" → `COUNT(*)` counts all rows (NULLs included); `COUNT(column)` skips NULLs in that column.
- **Practice Q:** Write a query for the min/max/avg `recency` across all customers.

## Subqueries

- **Concept:** A query inside a query — scalar (one value) or derived-table (used like a table).
- **Simple example:** `SELECT (SELECT COUNT(*) FROM students) AS total;`
- **Project example:** `sql/02_channel_performance.sql` Query 1 — subquery in the % denominator.
- **Interview Q:** "Subquery aur JOIN mein kab konsa?" → Single aggregated value chahiye ho toh subquery; row-by-row column combination chahiye ho toh JOIN.
- **Practice Q:** Write a query showing each customer's `total_spend` as a % of the overall total spend.

## CTEs (WITH)

- **Concept:** Named, readable, chainable query steps.
- **Simple example:** `WITH high_earners AS (SELECT * FROM employees WHERE salary > 100000) SELECT COUNT(*) FROM high_earners;`
- **Project example:** `sql/08_advanced_analysis.sql` Query 1 — 2-step CTE for campaign profitability.
- **Interview Q:** "CTE, subquery se better kyun?" → Readable, named, reusable within the same query.
- **Practice Q:** Write a CTE-based query computing each campaign's cost, revenue, and profit (using Z_CostContact=3, Z_Revenue=11).

## Window Functions

- **Concept:** Aggregate-like calculation without collapsing rows.
- **Simple example:** `RANK() OVER (ORDER BY score DESC)`
- **Project example:** `sql/08_advanced_analysis.sql` Query 2 (RANK), Query 3 (NTILE).
- **Interview Q:** "RANK() vs ROW_NUMBER()?" → RANK ties get the same rank (skips the next number); ROW_NUMBER always unique.
- **Practice Q:** Write a query ranking customers by `total_spend` within each `segment`.

## Project-Specific SQL Practice Problems (try these yourself)

1. Find the 3 customers with the highest `num_campaigns_accepted`.
2. Find the average `income` for customers who accepted Cmp6 vs. those who didn't.
3. Find what % of each `segment`'s customers have `complain = 1`.
4. Using a CTE, compute each channel's total purchases and its % of the grand total (replicate Query 1 of `sql/02_channel_performance.sql` using a CTE instead of a subquery).
5. Find the education level with the highest average `num_deals_purchases`.

## What I Should Remember

1. Every SQL concept here maps to a real, runnable query already in `sql/*.sql` — I should be able to open the file and re-explain it live if asked.
2. Practice problems should be attempted hands-on against `data/processed/marketing_analytics.db`, not just read.

---
*Next: [27_PYTHON_INTERVIEW_PREP.md](27_PYTHON_INTERVIEW_PREP.md)*
