# 35 — Quick Revision

🔴 MUST KNOW — revisable in 30-45 minutes before an interview.

## Project Facts (memorize these cold)

| Fact | Value |
|---|---|
| Dataset | Customer Personality Analysis (iFood), CC0, real hiring-case origin |
| Raw → Cleaned rows | 2,240 → 2,212 (28 dropped, 98.75% retained) |
| Tables | `dim_customers` (2,212), `fact_campaign_response` (13,272), `fact_channel_purchases` (6,636) |
| Campaigns | 6 (Cmp1-5 + Response/Cmp6) |
| Best/Worst campaign (acceptance) | Cmp6 15.05% / Cmp2 1.36% |
| Best/Worst campaign (ROI) | Cmp6 -44.8% / Cmp2 -95.0% |
| Best/Worst campaign (CAC) | Cmp6 19.93 / Cmp2 221.20 |
| Channel share | Store 46.2% / Web 32.5% / Catalog 21.3% |
| Catalog never-used | 26.0% (575 customers) |
| Never-responders | 72.7% (1,608 customers) |
| Segments (RFM) | Champions 24.1%→49.1% revenue; Loyal 38.4%→45.4%; At Risk 25.3%→4.7%; Lost 12.2%→0.9% |
| Funnel | 2,212 → 2,206 (99.7%) → 2,168 (98.0%) → 604 (27.3%) — biggest drop Stage3→4 (72.1%) |
| Total Revenue | 1,343,277 monetary units |
| Avg spend (mean/median) | 607.27 / 397 (right-skewed) |
| Key correlations | income↔spend +0.79; income↔web-visits **-0.65**; spend↔purchases +0.82 |
| Power BI | Build spec only, NOT yet physically built |

## SQL Syntax Cheat Sheet

```sql
SELECT col1, SUM(col2) AS total
FROM table
WHERE condition          -- row filter, before grouping
GROUP BY col1             -- bucket rows
HAVING SUM(col2) > 100    -- group-level filter, after grouping
ORDER BY total DESC
LIMIT 10;

-- JOIN
SELECT a.x, b.y FROM table_a a JOIN table_b b ON a.key = b.key;

-- CASE WHEN
CASE WHEN x < 10 THEN 'Low' WHEN x < 20 THEN 'Mid' ELSE 'High' END

-- CTE
WITH step1 AS (SELECT ... ), step2 AS (SELECT ... FROM step1) SELECT * FROM step2;

-- Window functions
RANK() OVER (ORDER BY col DESC)
NTILE(10) OVER (ORDER BY col DESC)
```

## SQL Concepts Checklist

SELECT · WHERE · DISTINCT · ORDER BY/LIMIT · COUNT/SUM/AVG/MIN/MAX · GROUP BY · HAVING · CASE WHEN · JOIN (fan-out awareness) · Subqueries (scalar + derived table) · CTEs · RANK()/NTILE() window functions.

## Pandas Function Cheat Sheet

`read_csv` · `head/info/describe/shape` · `.loc/.iloc` · boolean filtering · `sort_values` · `isna/dropna/fillna` · `duplicated/drop_duplicates` · `value_counts` · `groupby+agg` · `assign` · `merge` · `to_datetime` · `melt` (unpivot) · `qcut` (quantile binning).

## DA Definitions (one-liners)

- **Dimension** = group/filter by. **Measure** = aggregate (SUM/AVG).
- **KPI** = a metric important enough to track regularly.
- **Primary Key** = unique, non-null row identifier. **Foreign Key** = points to another table's PK.
- **Fact table** = events/measurements (many rows). **Dimension table** = descriptive entity (fewer rows).

## Marketing Metrics Formulas

| Metric | Formula |
|---|---|
| Conversion/Acceptance Rate | `Accepted / Targeted × 100` |
| ROI % | `(Revenue - Cost) / Cost × 100` |
| ROAS | `Revenue / Cost` |
| CAC | `Cost / Customers Acquired` |
| Channel Share % | `Channel Total / Grand Total × 100` |

## Funnel Concepts

Funnel = sequential stages, each a subset of the one before. Our funnel: Total → Purchase → Deal-use → Campaign-accept. **Rule:** only compare same-time-window fields as sequential stages (our original mistake, caught and fixed).

## Segmentation (RFM) Cheat Sheet

R(ecency) — lower is better, **score reversed**. F(requency) — higher is better. M(onetary) — higher is better. Each quartile-scored 1-4, summed (3-12), mapped to: Champions (10-12), Loyal (7-9), At Risk (5-6), Lost (3-4). **No ML/clustering.**

## Power BI Concepts

Data Model (tables+relationships) → Measures (DAX, dynamic) vs. Calculated Columns (static per-row) → Visuals/Pages → Slicers/Filters. `DIVIDE()` for safe division. `CALCULATE(..., ALL(...))` to remove a filter for a grand-total.

## Statistics Cheat Sheet

- Mean sensitive to outliers; Median resistant. Mean > Median = right-skewed.
- Std Dev = spread, same units as data (Variance = squared units).
- Quartiles split data into 4 equal-count groups — the literal mechanism behind our RFM scores.
- Correlation (-1 to +1) ≠ Causation, always.
- We have the full population, not a sample → no hypothesis testing/p-values needed here.

## Business Insight One-Liners

1. 72.7% never respond — campaign relevance problem, not product problem.
2. Every campaign is a loss under the assumption constants — targeting, not volume, is the lever.
3. Champions = 24.1% of customers, 49.1% of revenue, 15.14% acceptance.
4. Biggest funnel drop: deal-use → campaign-accept (72.1%).
5. Catalog: 26% never-used — a reach gap, distinct from its volume share.
6. Responders spend 2x+ more than non-responders (correlation, not proven causation).
7. Income ↔ web-visits = -0.65 (income paradox: richer customers visit less, buy more).
8. No-kids households spend 2.7x more than has-kids households.
9. Recency predicts acceptance, monotonically (9.52% → 5.93%).
10. 10 customers are "serial responders" (5 of 6 campaigns) — natural VIP candidates.

## Top 15 Interview Questions (rapid-fire)

1. Tell me about your project (30s pitch).
2. What's the difference between dimension and measure?
3. Explain a JOIN query from your project.
4. WHERE vs. HAVING?
5. What's RFM, and why not K-Means?
6. Explain your funnel and its biggest drop-off.
7. CTR vs. Conversion Rate?
8. ROI vs. ROAS?
9. Why is every campaign's ROI negative, and does that mean stop marketing?
10. How did you handle missing Income values, and why?
11. What's the strongest insight from your analysis?
12. Why didn't you use hypothesis testing?
13. Correlation vs. Causation — give your project's example.
14. Show me your Power BI dashboard. (Answer honestly: spec only, not yet built.)
15. What are your project's limitations?

## Final Self-Test (answer all 25 without looking, then check yourself)

1. What is Data Analytics?
2. What is Marketing Analytics?
3. What problem does my project solve?
4. Explain the dataset (rows, columns, source).
5. Explain one SQL query line by line.
6. Explain JOIN (and the fan-out gotcha).
7. Explain GROUP BY (and how HAVING differs from WHERE).
8. Explain one major Pandas operation (e.g., `merge` or `qcut`).
9. What is EDA, and why do it before/alongside SQL?
10. Why did you choose this visualization for [any specific chart]?
11. Explain CTR (and why it's not in your project).
12. Explain Conversion Rate (and your project's real numbers).
13. Explain ROI (your project doesn't use ROAS separately — explain why they're similar).
14. Explain CAC.
15. Explain funnel analysis and your project's funnel.
16. Explain drop-off, and where your biggest one is.
17. Explain customer segmentation (RFM, generally).
18. Explain your specific 4 customer segments.
19. Explain your Power BI plan (and its honest "not yet built" status).
20. Explain your strongest insight (Champions concentration).
21. Explain one limitation of your project.
22. Give one recommendation, properly hedged.
23. Explain why correlation does not mean causation, with your project's example.
24. Explain why one campaign cannot automatically be called "best" without specifying the metric.
25. Tell me about the project in 1 minute.

**Harder follow-ups (attempt after the 25 above):**
- If your dataset had 10x more rows, what would you do differently?
- If the business asked you to prove a campaign *caused* higher spend, what would you need?
- If a stakeholder insists CTR must exist "because every marketing project has it," how do you respond?
- Defend your choice of RFM over K-Means for a skeptical technical interviewer.
- Your Recency-score direction is reversed from Frequency/Monetary — justify that out loud, from scratch, without notes.

## What I Should Remember

This page alone should be enough to refresh everything the night before an interview — if any line here feels unfamiliar, go back to its full chapter before the interview, don't guess.

---
*Next: [36_GLOSSARY.md](36_GLOSSARY.md)*
