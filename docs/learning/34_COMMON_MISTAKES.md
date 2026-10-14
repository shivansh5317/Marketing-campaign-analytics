# 34 — Common Mistakes

🔴 MUST KNOW

Format: **Wrong Approach → Why Wrong → Correct Approach → Interview Lesson.**

## 1. Confusing CTR and Conversion Rate

- **Wrong:** Using "conversion rate" and "CTR" interchangeably.
- **Why wrong:** CTR measures clicks/impressions (interest); conversion rate measures actual outcome/targeted (action). Different funnel stages.
- **Correct:** Know which one your data actually supports — our project only supports conversion rate (campaign acceptance), not CTR (no impression data exists).
- **Interview lesson:** Always state which metric you mean, and whether your data can even support it.

## 2. Comparing Raw Counts Without Considering Audience Size

- **Wrong:** "Campaign A got 200 conversions, Campaign B got 100 — A is better."
- **Why wrong:** If A targeted 10,000 people and B targeted 500, B's rate (20%) crushes A's (2%).
- **Correct:** Always compute and lead with the **rate**, use raw count as supporting context only.
- **Interview lesson:** This is a very common "spot the mistake" interview question — always mention the denominator.

## 3. Confusing Revenue and Profit

- **Wrong:** "This campaign generated 3,663 in revenue — great campaign!"
- **Why wrong:** Revenue ignores cost. Cmp6's Revenue (3,663) still resulted in a Profit of -2,973 because Cost was 6,636.
- **Correct:** Always pair Revenue with Cost/Profit before judging performance.
- **Interview lesson:** Be ready to state both numbers together, never Revenue alone as a performance verdict.

## 4. Using the Wrong Denominator

- **Wrong:** After a JOIN that fans out rows (e.g., 1 customer → 6 campaign rows), using `COUNT(*)` as if it were the customer count.
- **Why wrong:** It's actually the customer×campaign pair count — a different (larger) number.
- **Correct:** Use `COUNT(DISTINCT customer_id)` when you need the true customer count; be explicit about the grain of any denominator.
- **Interview lesson:** We hit this directly in `sql/03_customer_analysis.sql` Query 3 — a great real example to cite.

## 5. Ignoring Missing Data

- **Wrong:** Running averages/correlations without first checking for missing values.
- **Why wrong:** Silent exclusion (or errors) can bias results without you noticing.
- **Correct:** Always run `.isna().sum()` / `COUNT(*) vs COUNT(column)` checks first, and document the decision (drop/impute/recode) with reasoning.
- **Interview lesson:** We found exactly 24 missing `Income` values (1.07%) and documented a bias-check before deciding to drop them.

## 6. Incorrect JOINs

- **Wrong:** Using a JOIN type that doesn't match what the data actually needs (e.g., forcing a LEFT JOIN "to be safe" when an INNER JOIN is correct, or vice versa).
- **Why wrong:** Produces either missing rows (wrong INNER) or spurious NULL rows (wrong LEFT) that don't reflect reality.
- **Correct:** Understand whether every row on one side is guaranteed to have a match before choosing the JOIN type.
- **Interview lesson:** We used INNER JOIN throughout — explain WHY (every customer guaranteed 6 fact rows via the unpivot), not just that we did.

## 7. Double-Counting Customers

- **Wrong:** Summing a per-campaign or per-channel count and assuming it equals the customer count.
- **Why wrong:** The same customer appears in multiple rows across campaigns/channels (fan-out).
- **Correct:** Use `COUNT(DISTINCT customer_id)` explicitly whenever you need unique customers after a one-to-many relationship.
- **Interview lesson:** Same root cause as Mistake #4 — worth knowing both phrasings of the same underlying trap.

## 8. Misleading Visualizations

- **Wrong:** Using a pie chart with 8+ categories, or a bar chart with an unlabeled/truncated axis.
- **Why wrong:** Makes it hard (or actively misleading) to compare values accurately.
- **Correct:** Match chart type to data shape — pie for few categories/share-of-whole, bar for comparisons, always label axes.
- **Interview lesson:** We deliberately used pie chart ONLY for the 4-segment revenue share — a chart-selection decision you should be able to defend.

## 9. Overclaiming Causality

- **Wrong:** "Campaign X caused customers to spend more."
- **Why wrong:** Without a controlled experiment, you only have correlation/association — reverse causation or a third factor is always possible.
- **Correct:** Use hedged language ("associated with," "may indicate," "worth investigating").
- **Interview lesson:** This is the single most repeated rule throughout this whole project — never break it under interview pressure, even if the interviewer pushes.

## 10. Confusing Correlation With Causation

- **Wrong:** Treating a correlation coefficient as proof of a causal mechanism.
- **Why wrong:** Correlation only shows two things move together — not which one (if either) causes the other.
- **Correct:** State the correlation value, then explicitly note at least one alternative explanation.
- **Interview lesson:** Our `income` ↔ `total_spend` (+0.79) example — always ready to explain "doesn't prove income causes spend."

## 11. Recommending Actions Without Evidence

- **Wrong:** "We should definitely do X" without tying it to a specific, named insight.
- **Why wrong:** Sounds like opinion, not analysis — undermines credibility.
- **Correct:** Every recommendation traces to a specific insight with hedged confidence language (see [22_BUSINESS_RECOMMENDATIONS.md](22_BUSINESS_RECOMMENDATIONS.md)).
- **Interview lesson:** Be ready to name which insight backs any recommendation you state.

## 12. Treating One Campaign as "Best" Without Defining the Metric

- **Wrong:** "Cmp6 is the best campaign" without specifying by what measure.
- **Why wrong:** "Best" could mean highest rate, highest ROI, lowest CAC, highest raw volume — they don't always agree.
- **Correct:** Always specify the metric: "Cmp6 has the best acceptance rate, best ROI, AND lowest CAC" (in our case, they do agree — but say so explicitly, don't assume).
- **Interview lesson:** A strong answer names the metric before naming the winner.

## 13. Overloading Dashboards

- **Wrong:** Cramming every possible chart/KPI/slicer onto one page.
- **Why wrong:** Defeats the purpose — a viewer can't find the one answer they came for.
- **Correct:** One clear business question per page, KPI cards at top, detail below (our Power BI spec design principle, [20_POWER_BI_IN_PROJECT.md](20_POWER_BI_IN_PROJECT.md)).
- **Interview lesson:** Dashboard design questions often test judgment/restraint, not just tool knowledge.

## What I Should Remember

1. Mistakes #4 and #7 share one root cause (JOIN fan-out) — know it as one concept, recognizable under two different phrasings.
2. Mistakes #9 and #10 are the same discipline (never overclaim causation) — the single most-repeated rule in this entire project.
3. For every mistake, I should be able to point to the specific place in this project where I actually avoided it (not just describe it abstractly).

---
*Next: [35_QUICK_REVISION.md](35_QUICK_REVISION.md)*
