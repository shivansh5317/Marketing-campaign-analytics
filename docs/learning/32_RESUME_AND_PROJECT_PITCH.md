# 32 — Resume and Project Pitch

🔴 MUST KNOW

## 1. The Pitches

### 30-Second Pitch

"I built a Marketing Analytics project on a real, 2,212-customer campaign-response dataset — analyzing which of 6 campaigns performed best, segmenting customers using RFM, and mapping an engagement funnel. Using SQL and Python, I found that just 24% of customers ('Champions') drive 49% of revenue and respond to campaigns at 10x the rate of inactive customers."

### 60-Second Pitch

(30-second version, plus:) "I cleaned the raw data myself — fixing impossible ages, a missing-income gap, and inconsistent category labels — then built a small fact/dimension star schema to practice real SQL joins. I wrote 8 SQL files covering everything from basic aggregation to CTEs and window functions, and a fully-executed Python EDA notebook with correlation analysis and visualizations. I also built a rule-based RFM segmentation (no machine learning) that splits customers into 4 explainable groups, and validated it against real campaign-response and revenue data."

### 2-Minute Pitch

(60-second version, plus:) "One thing I'm proud of: I initially designed a funnel using website-visits-per-month against 2-year purchase totals, but when I checked the real numbers, purchases came out higher than visits — which is impossible in a real funnel. I caught that myself, traced it to a time-window mismatch, and rebuilt the funnel using only consistent, same-window fields. The corrected funnel showed the biggest drop-off (72%) is between 'using a discount' and 'accepting a targeted campaign' — suggesting the real gap is campaign relevance, not basic buying behavior. I also wrote a full Power BI build specification — page layouts, DAX measures, everything — even though I haven't physically built it in Power BI Desktop yet, because I wanted that part to be honestly labeled as a documented plan, not something I was pretending already existed."

## 2. Resume Bullets (explained)

> ⚠️ **Rule followed throughout:** never claim revenue impact, a % improvement, or cost reduction unless it was actually calculated and is directly defensible. Every bullet below maps to something real and verifiable.

### Bullet 1
> "Analyzed a 2,212-customer, 6-campaign marketing dataset using SQL and Python to identify campaign performance, customer value concentration, and engagement drop-off points."

- **What it means:** The project's scope and scale, stated factually.
- **Evidence:** `docs/01`, `docs/03`, `docs/04`.
- **What interviewer can ask:** "Walk me through one of those findings." → Be ready with the Champions/funnel insight.
- **What I must know:** Exact numbers (2,212, 6) — never round loosely if asked for specifics.

### Bullet 2
> "Built a reusable Python data-cleaning pipeline resolving 5 real data-quality issues (missing values, outliers, inconsistent categories, invalid dates), retaining 98.75% of records."

- **What it means:** Real, justified cleaning work, not a black-box "I cleaned the data."
- **Evidence:** `scripts/clean_data.py`, `docs/02_data_cleaning.md`.
- **What interviewer can ask:** "Why did you drop instead of impute?" → Have the Issue-2 (missing Income) reasoning ready.
- **What I must know:** Which issues were dropped vs. recoded, and why for each.

### Bullet 3
> "Wrote 8 SQL analysis files (SELECT through CTEs and window functions) against a 3-table star schema, including a JOIN-based campaign-acceptance-by-demographic analysis and an NTILE-based VIP customer decile."

- **What it means:** Concrete SQL skill depth, not just "I know SQL."
- **Evidence:** `sql/*.sql`, `docs/04_sql_learning.md`, `docs/07_SQL_USED_IN_PROJECT.md`.
- **What interviewer can ask:** "Explain the CTE query." → Be ready to walk through `sql/08_advanced_analysis.sql` Query 1 live.
- **What I must know:** The exact SQL concepts list (Chapter 06/07) — don't blank on "what's a window function."

### Bullet 4
> "Designed and validated a rule-based RFM customer segmentation (no ML), identifying a 24.1%-of-customers segment ('Champions') that generates 49.1% of total revenue and converts at 10x the rate of the lowest segment."

- **What it means:** A real, interview-defensible segmentation result with validated business impact.
- **Evidence:** `scripts/segment_customers.py`, `docs/05_customer_segmentation.md`.
- **What interviewer can ask:** "Why RFM over clustering?" → Explainability/simplicity argument, ready in [17_CUSTOMER_SEGMENTATION.md](17_CUSTOMER_SEGMENTATION.md).
- **What I must know:** The exact quartile-scoring mechanism and the reversed-Recency gotcha.

### Bullet 5
> "Performed Python EDA (pandas/matplotlib/seaborn) including a correlation analysis that quantified a -0.65 relationship between income and web-visit frequency, confirming a pattern first observed in SQL."

- **What it means:** Cross-tool verification — a sign of rigor, not just "I made some charts."
- **Evidence:** `notebooks/01_marketing_eda.ipynb`, `docs/07_python_eda_learning.md`.
- **What interviewer can ask:** "What does -0.65 mean practically?" → Strong negative — lower income customers visit more but buy less.
- **What I must know:** That this is correlation, not causation — never overclaim here.

## 3. INTERVIEW

**Q: "Aapke resume bullet mein '49.1% of revenue' likha hai — ye number kaha se aaya?"**
> "`docs/05_customer_segmentation.md` mein — Champions segment ka `total_spend` sum lekar poore dataset ke total se divide kiya, verified via both SQL aur the Phase 7 notebook pie chart. Main exact calculation live bhi dikha sakta hoon."

**Q: "Aapne kabhi revenue-impact wala number claim nahi kiya resume mein — kyun?"**
> "Kyunki is project se koi real business revenue impact measure nahi hua — ye ek portfolio/learning project hai, live-deployed nahi. Jo bhi number maine claim kiya hai, wo dataset ke andar genuinely calculate hua hai aur verify ho sakta hai — maine kabhi aisa number nahi likha jo main defend na kar sakoon."

## 4. Common Mistakes

- Resume mein vague bullets ("Worked on a marketing project") — specificity (numbers, tools, techniques) hamesha stronger hota hai.
- Fake/unverifiable impact claims ("increased revenue by 20%") jab project mein aisa kuch measure hi nahi hua.
- Bullet likhna but uske peeche ka exact number/logic yaad na hona.

## 5. What I Should Remember

1. Every resume bullet traces to a real, named file/number — I never say something I can't immediately back up.
2. The pitches scale up (30s → 60s → 2min) by adding depth, not by repeating — each longer version should feel like a natural continuation.
3. No fabricated business-impact metrics, ever.

---
*Next: [33_MOCK_INTERVIEW.md](33_MOCK_INTERVIEW.md)*
