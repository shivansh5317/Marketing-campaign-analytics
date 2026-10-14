# 21 — Business Insights

🔴 MUST KNOW

Full evidence trail for every insight below: [docs/09_business_insights.md](../09_business_insights.md). This file is the interview-ready, condensed version — all 11 insights, each as **Observation → Evidence → Interpretation → Business Implication.**

## Recap: Observation vs. Interpretation vs. Causation (see also [13_FUNNEL_ANALYSIS.md](13_FUNNEL_ANALYSIS.md) Section 6)

- **Observation** = what the data literally shows.
- **Interpretation** = a reasonable, non-final explanation ("may indicate," "suggests").
- **Causation** = a proven cause, requiring a controlled experiment — **never claimed anywhere in this project**, because we never ran one.

## The 11 Real Insights

| # | Observation | Evidence | Business Implication |
|---|---|---|---|
| 1 | 72.7% of customers never accepted a single campaign | `docs/03`, `docs/06`, `sql/06` Q1 | Problem looks like campaign relevance/targeting, not product engagement (98%+ purchase engagement is near-universal) |
| 2 | Every campaign shows a loss under the dataset's cost/revenue assumption constants, even the best (Cmp6: -44.8% ROI) | `docs/03`, `sql/08` Q1 | "Contact everyone" is inefficient under this assumption — targeting efficiency matters as much as offer quality |
| 3 | Champions (24.1% of customers) = 49.1% of revenue, 15.14% acceptance; Lost (12.2%) = 0.9% revenue, 1.43% acceptance | `docs/05` Section 6 | Concentrate retention effort on Champions/Loyal (94.5% of revenue combined); minimal-cost touches for Lost |
| 4 | Biggest funnel drop-off: deal-use → campaign-accept (72.1% drop) | `docs/06` Section 3 | The gap is campaign relevance/timing, not basic purchasing behavior |
| 5 | Catalog channel: 26.0% of customers have NEVER used it (vs. 2.2% Web, 0.6% Store) | `docs/06` Section 5, `sql/02` Q2 | A reach/awareness gap, distinct from Catalog's lower total-volume share |
| 6 | Campaign responders spend 2x+ more than non-responders (997 vs. 461 avg) | `sql/07` Q3 | Useful as a targeting signal — NOT proof that campaigns caused the extra spend (reverse causation equally plausible) |
| 7 | Income "paradox": lower-income customers visit more (7.00/mo) but buy less (2.00/2yr); higher-income visit less (2.96/mo) but buy more (5.33/2yr). Correlation income↔visits = **-0.65** | `sql/04` Q3, Phase 7 notebook | Worth investigating (pricing sensitivity? comparison-shopping?) — root cause not determinable from this data |
| 8 | No-kids households spend 2.7x more than has-kids households (1,104 vs. 409) | `sql/05` Q2/Q3 | Family structure may be a stronger segmentation signal than income alone |
| 9 | Recency predicts acceptance, monotonically: 9.52% (most recent) → 5.93% (least recent) | `sql/06` Q3 | Statistically validates Recency as an RFM pillar; prioritize recently-active customers for new campaigns |
| 10 | Exactly 10 customers accepted 5 of 6 campaigns (max found, nobody accepted all 6) | `sql/06` Q2 | Natural, high-confidence VIP/loyalty program candidates |
| 11 | Missing-income customers (24 rows, dropped) had a 4.17% response rate vs. 15.03% for everyone else | `docs/02` Issue 2 | Interesting but sample too small (24 rows) to act on — documented for transparency only |

## How To Discuss These In An Interview (a reusable pattern)

> "[Observation, with the real number] → [Evidence: which file/query it came from] → [Interpretation, hedged] → [Business implication, phrased as 'worth investigating' or 'consider,' never a guarantee]."

Example: *"72.7% of our customers never accepted a single campaign (verified in both our SQL conversion-analysis query and the funnel analysis) — this suggests the gap is specifically in campaign relevance or targeting, since basic purchase engagement is near-universal (98%+). That's worth investigating further, for example by testing whether segment-specific offers close this gap — I wouldn't claim a single root cause without an experiment."*

## INTERVIEW

**Q: "Aapka sabse important/strongest insight kaunsa hai?"**
> "Insight 3 — sirf 24.1% customers (Champions) 49.1% revenue aur sabse zyada campaign response dete hain. Ye genuinely actionable hai: business apna marketing/retention budget ka bada hissa is chhote, high-value group pe concentrate kar sakta hai, aur ye numbers khud verify hote hain segment-validation table se."

**Q: "Koi aisa insight jo aapko surprise kiya?"**
> "Insight 7 — income paradox. Maine expect kiya tha ki high-income customers zyada website visit bhi karenge aur zyada bhi khareedenge, lekin actual correlation -0.65 nikla (income aur visits ulta related hain). Ye interesting hai lekin main iska 'kyun' confidently nahi bata sakta — sirf ek observed pattern hai."

## Common Mistakes

- Insight ko seedha causation bol dena ("campaign caused the spend increase").
- Chhote-sample findings (Insight 11, 24 rows) ko confidently generalize kar dena.
- Sirf positive insights dikhana, limitations chhupana.

## What I Should Remember

1. Every insight here has a specific file/query behind it — I can always point to the exact evidence.
2. Every interpretation uses hedged language ("may indicate," "suggests," "worth investigating") — never a hard causal claim.
3. Insight 3 (Champions concentration) and Insight 4 (funnel drop-off) are the two headline findings to lead with.

---
*Next: [22_BUSINESS_RECOMMENDATIONS.md](22_BUSINESS_RECOMMENDATIONS.md)*
