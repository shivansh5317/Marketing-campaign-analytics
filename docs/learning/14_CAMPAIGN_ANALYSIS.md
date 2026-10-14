# 14 — Campaign Analysis

🔴 MUST KNOW

## 1. How Analysts Evaluate Marketing Campaigns

### GENERAL CONCEPT

A campaign is typically judged on multiple angles, not just one:

| Angle | What it checks |
|---|---|
| **Performance** | Did people respond? (acceptance/conversion rate) |
| **Comparison** | How does it stack up against other campaigns? |
| **Engagement** | Did it generate interest even if not full conversion? |
| **Revenue/Efficiency** | Was the outcome worth what it cost? |
| **Trend over time** | Is performance improving/declining? (needs date data — **not available in our dataset**) |

**Why raw counts can mislead:** A campaign might have more conversions *simply because it reached more people* — not because it was more effective. Always compare **rates**, not just raw counts, and check **efficiency** (cost per outcome), not just volume.

## 2. MY PROJECT — Campaign Analyses, In Full

### Analysis 1 — Which campaign had the best/worst acceptance rate?

- **QUESTION:** Which of the 6 campaigns converted the highest/lowest % of targeted customers?
- **DATA:** `fact_campaign_response` (13,272 rows — 2,212 customers × 6 campaigns)
- **SQL/PYTHON LOGIC:** `GROUP BY campaign_name`, `SUM(accepted)/COUNT(*)` (`sql/01_campaign_overview.sql` Query 2; same logic replicated in the Phase 7 notebook)
- **RESULT:** Cmp6 = 15.05% (best), Cmp2 = 1.36% (worst) — an **11x** gap.
- **INTERPRETATION:** Cmp6 (the most recent campaign in the dataset) massively outperforms. Since all 6 campaigns target the same customer base and we don't have campaign-creative/offer details, we can state this as association, not a proven reason.
- **BUSINESS IMPLICATION:** Worth investigating what made Cmp6 different (timing, offer, messaging) — if repeatable, that design could inform the next campaign.

### Analysis 2 — Is the company acquiring responders profitably?

- **QUESTION:** Given the cost/revenue assumption, is any campaign actually profitable?
- **DATA:** `fact_campaign_response` + the dataset's `Z_CostContact`(3)/`Z_Revenue`(11) constants
- **SQL/PYTHON LOGIC:** `sql/08_advanced_analysis.sql` CTE chain (targeted → cost/revenue → profit/ROI/CAC)
- **RESULT:** **Every campaign shows a loss** — even Cmp6 (ROI = -44.8%).
- **INTERPRETATION:** Under the "contact everyone" assumption built into this dataset, no campaign pays for itself.
- **BUSINESS IMPLICATION:** Suggests that **targeting fewer, higher-probability customers** (rather than the whole database) could flip the economics — directly motivates the segmentation work (Chapter 17).

### Analysis 3 — Serial responders vs. one-time responders

- **QUESTION:** Is there a small group of highly-engaged "repeat responders"?
- **DATA:** `fact_campaign_response`, grouped by customer
- **SQL/PYTHON LOGIC:** `GROUP BY customer_id HAVING SUM(accepted) >= 2` (`sql/06_conversion_analysis.sql` Query 2)
- **RESULT:** Exactly 10 customers accepted 5 of 6 campaigns (the maximum found — nobody accepted all 6).
- **INTERPRETATION:** A very small, consistent, highly-engaged group exists.
- **BUSINESS IMPLICATION:** Natural VIP/loyalty-program candidates.

## 3. Why Raw Counts Can Be Misleading — A Worked Example

Imagine (hypothetical, not our real data) Campaign A reaches 2,000 customers and gets 100 acceptances; Campaign B reaches 200 customers and gets 40 acceptances.

| | Campaign A | Campaign B |
|---|---|---|
| Raw acceptances | 100 (looks "better") | 40 |
| Acceptance Rate | 100/2000 = 5% | 40/200 = **20%** |

**Campaign B is actually far more effective per person reached**, even though its raw count is lower. This is exactly why every campaign comparison in this project uses a **rate** (`acceptance_rate_pct`), never a raw count alone, as the primary ranking metric — see `sql/01_campaign_overview.sql` Query 2 explicitly computing and sorting by the rate.

## 4. INTERVIEW

**Q: "Aap do campaigns ko kaise compare karoge — sirf conversions count se?"**
> "Nahi — raw count misleading ho sakta hai agar audience size alag ho. Main hamesha **rate** (acceptance %) ko primary metric rakhta hoon, aur agar cost/revenue data available ho toh **efficiency** (ROI/CAC) bhi dekhta hoon — teeno angles (absolute, rate, efficiency) alag kahaniyan bata sakte hain."

**Q: "Aapke data mein campaign launch dates kyun nahi hain, aur iska kya impact hai?"**
> "Dataset mein sirf accept/reject flags hain, koi launch/end date nahi — isliye maine real calendar time-series trend analysis nahi kiya. Maine ye limitation explicitly document ki hai, taaki koi galti se socha na jaaye ki humne trend analysis kiya hai."

**Q: "Har campaign loss dikha rahi hai — iska matlab company marketing band kar de?"**
> "Zaroori nahi. Ye batata hai 'sabko contact karna' strategy is cost/revenue assumption ke against inefficient hai — sahi response hoga **targeting ko improve karna** (sirf high-probability segments ko contact karna), poori marketing band karna nahi."

## 5. Common Mistakes

- Raw acceptance count ko "best campaign" ka proof maan lena bina rate check kiye.
- Negative ROI dekh kar "marketing hi band kar do" jaisa extreme recommendation dena.
- Campaign trend ("improving over time?") claim karna jab dataset mein dates hi nahi hain.

## 6. What I Should Remember

1. Always rank campaigns by **rate**, with raw counts and (where available) efficiency as supporting context — never raw count alone.
2. Every campaign is a loss under the dataset's assumption constants — the fix implied is better targeting, not less marketing.
3. No campaign dates exist — never claim a time trend here.

---
*Next: [15_CHANNEL_ANALYSIS.md](15_CHANNEL_ANALYSIS.md)*
