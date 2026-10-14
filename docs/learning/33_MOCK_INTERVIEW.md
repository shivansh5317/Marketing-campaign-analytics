# 33 — Mock Interview

🟡 GOOD TO KNOW — best used actively: answer out loud BEFORE reading the model answer.

**How to use this file:** For each round, read only the questions first. Answer them yourself (out loud, or written). Only then scroll down to the model answers. Don't peek early — that defeats the purpose.

---

## Round 1 — Project Introduction

**Questions:**
1. Tell me about your project.
2. Why did you pick this dataset?

<details>
<summary>Model Answers (click/scroll only after answering)</summary>

1. **Model answer:** Use the 1-minute pitch ([03_PROJECT_OVERVIEW.md](03_PROJECT_OVERVIEW.md)). **Why it works:** covers business problem, data, tools, and one concrete headline finding in under a minute. **Common mistake:** starting with tool names ("I used SQL and Python...") instead of the business problem. **Strong follow-up:** "What was the hardest part?" → the funnel time-window bug story.
2. **Model answer:** Real, public, CC0-licensed; genuinely has campaign/revenue/channel data (many alternatives lacked one of these); small enough to fully understand; has honest data-quality issues. **Why it works:** shows a deliberate, evidence-based choice, not "first dataset I found." **Common mistake:** "It was popular on Kaggle" as the only reason.

</details>

---

## Round 2 — Basic Data Analytics

**Questions:**
1. What's the difference between a dimension and a measure?
2. Walk me through your data-cleaning workflow.

<details>
<summary>Model Answers</summary>

1. **Model answer:** Measure = numeric, aggregated (SUM/AVG) — e.g., `total_spend`. Dimension = used to group/filter — e.g., `education`. **Why it works:** gives a definition AND a project-grounded example. **Common mistake:** confusing "numeric column" with "measure" — some numeric columns (like `Kidhome`) are actually used as dimensions.
2. **Model answer:** Use the PROBLEM→DETECTION→WHY→ACTION→WHY-chosen→RESULT framework from [10_DATA_CLEANING.md](10_DATA_CLEANING.md), walking through at least 2 real issues. **Common mistake:** vague "I removed nulls and duplicates" without specifics.

</details>

---

## Round 3 — SQL

**Questions:**
1. Explain a JOIN query from your project, clause by clause.
2. What's the difference between WHERE and HAVING?

<details>
<summary>Model Answers</summary>

1. **Model answer:** Walk through `sql/03_customer_analysis.sql` Query 3 — explain the JOIN condition, the `GROUP BY`, and specifically the fan-out gotcha (`COUNT(*)` counts customer×campaign pairs after the join). **Why it works:** shows you understand JOIN *behavior*, not just syntax. **Strong follow-up:** "What if you used COUNT(DISTINCT d.customer_id) instead?" → Different, smaller number — true customer count, not pair count.
2. **Model answer:** WHERE filters rows before grouping; HAVING filters aggregated groups after. **Common mistake:** saying "they're the same" or being unable to give an example requiring HAVING specifically (like `sql/04_funnel_analysis.sql` Query 2).

</details>

---

## Round 4 — Python / Pandas

**Questions:**
1. How did you compute the campaign acceptance rate in pandas?
2. What's a time you had to fix a data type issue?

<details>
<summary>Model Answers</summary>

1. **Model answer:** `fact_campaign.groupby("campaign_name")["accepted"].agg(customers_accepted="sum", customers_targeted="count").assign(acceptance_rate_pct=lambda d: 100 * d["customers_accepted"]/d["customers_targeted"])`. **Why it works:** precise, real code, not hand-waved. **Common mistake:** describing it only in English without being able to name the actual functions used.
2. **Model answer:** `Dt_Customer` was stored as text; converted with `pd.to_datetime(..., format="%Y-%m-%d")` to unlock date arithmetic for `customer_tenure_days`. **Common mistake:** not knowing why a text-date blocks arithmetic.

</details>

---

## Round 5 — Marketing Metrics

**Questions:**
1. What's the difference between ROI and ROAS?
2. Why is conversion rate better than raw conversion count for comparing campaigns?

<details>
<summary>Model Answers</summary>

1. **Model answer:** ROI = `(Revenue-Cost)/Cost` (profit %, cost-aware). ROAS = `Revenue/Cost` (a ratio, doesn't subtract cost — can look fine while actually being a loss). **Common mistake:** treating them as interchangeable.
2. **Model answer:** Raw count is biased by audience size — a campaign reaching more people will likely get more raw conversions even if it's less effective per person. Rate normalizes for that. **Example:** Cmp6 (15.05%) vs Cmp2 (1.36%) — same targeted population (2,212), so here rate and count actually agree, but this wouldn't hold if audience sizes differed.

</details>

---

## Round 6 — Funnel / Customer Analytics

**Questions:**
1. Where's your biggest funnel drop-off, and why does it make sense?
2. How did your original funnel design go wrong?

<details>
<summary>Model Answers</summary>

1. **Model answer:** Deal-use → Campaign-accept, 72.1% drop. Makes sense because using a discount is low-effort/near-universal, while accepting a targeted campaign needs specific relevance/timing. **Common mistake:** not being able to state the actual % or stage names.
2. **Model answer:** Originally compared monthly web visits against 2-year web purchases; purchase count came out higher than visit count, which is impossible for a real funnel — caught via checking real numbers, traced to the time-window mismatch, fixed by using only same-window fields. **Why it works:** a specific, honest, self-corrected story — very strong signal of rigor.

</details>

---

## Round 7 — Power BI

**Questions:**
1. Show me your dashboard.
2. What would Page 1 of your dashboard contain?

<details>
<summary>Model Answers</summary>

1. **Model answer:** Honestly state it's a complete build spec, not yet physically built (GUI tool, couldn't build it in this coding session) — then offer to walk through the spec. **Why it works:** honesty beats a vague dodge or an overclaim.
2. **Model answer:** KPI cards (Total Customers, Total Revenue, Acceptance Rate), a campaign acceptance-rate bar chart, a campaign ROI bar chart, and a campaign slicer — per [20_POWER_BI_IN_PROJECT.md](20_POWER_BI_IN_PROJECT.md).

</details>

---

## Round 8 — Statistics

**Questions:**
1. Why didn't you use hypothesis testing in this project?
2. What does it mean that total_spend's mean is higher than its median?

<details>
<summary>Model Answers</summary>

1. **Model answer:** We have the full customer population, not a sample — hypothesis testing/p-values are for inferring an unknown population value from a sample, which we don't need to do here.
2. **Model answer:** The data is right-skewed — a small group of high spenders pulls the mean up above the "typical" (median) customer's spend. This is why we report both, not just the mean.

</details>

---

## Round 9 — Business Case

**Questions:**
1. Every campaign shows a loss — should the company stop marketing?
2. What's the difference between an insight and a recommendation?

<details>
<summary>Model Answers</summary>

1. **Model answer:** Not necessarily — it suggests "contact everyone" targeting is inefficient under the dataset's cost/revenue assumption; targeting only high-probability segments could flip the economics. **Common mistake:** answering "yes, stop marketing" — too extreme, not supported by the actual implication.
2. **Model answer:** Insight = an observed fact ("Champions = 49.1% of revenue"). Recommendation = a suggested action built on that fact, properly hedged ("consider prioritizing Champions for retention offers").

</details>

---

## Round 10 — Deep Project Follow-Up

**Questions:**
1. If I gave you this dataset again from scratch, what would you do differently?
2. What's one thing in your analysis you're NOT fully confident about?

<details>
<summary>Model Answers</summary>

1. **Model answer (adapt to your own honest view):** Possibly design the funnel more carefully from the start by checking time-windows before building anything, or seek real campaign-cost data upfront rather than relying on the assumption constants. **Why it works:** shows reflective, growth-oriented thinking.
2. **Model answer:** The missing-income group's much-lower response rate (4.17% vs. 15.03%) — real pattern, but only 24 rows, too small to act on confidently. **Why it works:** demonstrates honest self-assessment rather than false confidence in every single number.

</details>

## What I Should Remember

1. Answer every question OUT LOUD before checking the model answer — reading isn't the same as retrieving from memory under pressure.
2. The funnel time-window story (Rounds 6/1) is your strongest "shows rigor" anecdote — have it ready at all times.
3. Every "common mistake" listed here is a real trap — notice if you fall into one while practicing.

---
*Next: [34_COMMON_MISTAKES.md](34_COMMON_MISTAKES.md)*
