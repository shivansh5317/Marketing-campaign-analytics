# 31 — Project Defense

🔴 MUST KNOW

Goal: answer naturally, not from memorized scripts. Each answer below is a **direction/structure**, not a word-for-word script — internalize the logic, then speak it in your own words.

| Question | Answer Direction |
|---|---|
| "Tell me about your project." | Use the 1-minute pitch ([03_PROJECT_OVERVIEW.md](03_PROJECT_OVERVIEW.md)) — business problem, dataset, tools, headline finding. |
| "Why did you choose Marketing Analytics?" | Genuine interest in business-impact analytics (not just technical exercises); marketing has clear, intuitive business metrics (conversion, ROI) that connect technical work to real decisions. |
| "Why this dataset?" | Real (not synthetic), genuinely has revenue/campaign/channel data (many alternatives lacked one of these), small enough to fully understand, has real honest data-quality issues to clean. |
| "What business problem?" | Which campaigns/segments/channels are worth future investment, given 6 campaigns and 2,212 customers of real response history. |
| "What was your role?" | End-to-end solo: cleaning, SQL, Python EDA, segmentation, funnel, insights, Power BI spec. |
| "What did you clean?" | 5 issues — impossible ages, missing income, income outlier, inconsistent categories, text-typed dates. Each with a specific, justified action. |
| "Why SQL?" | Industry-standard for structured/relational querying; demonstrates real joins/CTEs/window-function skill directly relevant to DA roles. |
| "Why Python?" | Complements SQL for visual exploration, statistics, and flexible iteration — not redundant with SQL, each tool plays to its strength. |
| "Why Power BI?" | Converts technical findings into a self-service, interactive format for non-technical stakeholders. |
| "Which metric mattered most?" | Campaign Acceptance Rate (conversion) — the most direct signal of "did this campaign work," and the base for ROI/CAC. |
| "Why did you choose this funnel?" | Built it from fields sharing a consistent (2-year cumulative) time window, after catching and correcting an initial design that mixed incompatible time windows. |
| "Why did you choose this visualization [for X]?" | Match chart type to the actual question — see the chart-selection table in [11_EDA_AND_VISUALIZATION.md](11_EDA_AND_VISUALIZATION.md). |
| "Which campaign performed best and why?" | Cmp6 (15.05% acceptance, best ROI/CAC among 6) — likely due to being the most recent/best-timed, though we can't prove the exact cause without experiment data. |
| "How did you define 'best'?" | Primarily acceptance rate (rate, not raw count), cross-checked with ROI and CAC where cost/revenue data exists. |
| "What was the biggest challenge?" | Catching the funnel time-window mismatch — required actually checking real numbers (purchase > visit count) rather than trusting the initial design, then redesigning the funnel correctly. |
| "What was the strongest insight?" | Champions = 24.1% of customers but 49.1% of revenue and the highest campaign acceptance rate — a real, large, directly-verified concentration pattern. |
| "What recommendation did you make?" | Prioritize Champions/Loyal for retention, minimal-cost touches for Lost/Hibernating, and investigate (not assume) the Catalog channel's reach gap. |
| "What are the limitations?" | No real per-transaction financials (assumption constants only), no campaign dates, single company/time-period, no controlled experiments — all stated in [23_END_TO_END_PROJECT_WALKTHROUGH.md](23_END_TO_END_PROJECT_WALKTHROUGH.md) Section 16. |
| "What would you improve?" | Build the actual Power BI dashboard, get real cost/revenue data, run an A/B test on a top recommendation. |
| "What if the dataset were larger?" | Could support more granular segments, more reliable small-sample findings (e.g., the missing-income group's behavior, currently too small to act on), and potentially real statistical hypothesis testing if structured as an experiment. |
| "What data would you ask the company for?" | Real campaign cost/revenue, campaign dates, ad-channel data (if CTR/Impressions relevant), and ideally A/B test results. |
| "What if the business disagrees with your recommendation?" | Explain the evidence/reasoning, acknowledge the recommendation is based on observational data (not an experiment), and stay open to additional context the business may have that the data doesn't capture. |

## How To Practice This

1. Cover the right column, read only the question, answer out loud in your own words.
2. Check against the direction given — did you cover the key substance, even if your phrasing differed?
3. Repeat the ones you stumbled on.

## INTERVIEW (meta — about the defense itself)

**Q: "Aap itna confidently apne limitations kyun bata rahe ho — kya ye weakness dikhayega?"**
> "Nahi — ek analyst jo apni analysis ki boundaries jaanta hai zyada trustworthy lagta hai ek analyst se jo overclaim karta hai. Interviewers specifically ye test karte hain ki kya candidate apne kaam ko honestly critique kar sakta hai."

## Common Mistakes

- Memorized, robotic-sounding answers instead of natural, understood explanations.
- Avoiding/deflecting the "limitations" and "biggest challenge" questions instead of answering them directly and specifically.
- Inventing a recommendation's confidence level higher than the evidence supports.

## What I Should Remember

1. Every answer here should sound like *my own understanding*, not a recited script.
2. The "biggest challenge" answer (the funnel time-window bug) is a genuinely strong, specific, real story — use it.
3. Limitations and "what would you improve" are opportunities to show maturity, not weaknesses to hide.

---
*Next: [32_RESUME_AND_PROJECT_PITCH.md](32_RESUME_AND_PROJECT_PITCH.md)*
