# 13 — Funnel Analysis

🔴 MUST KNOW

## 1. What Is a Funnel?

### GENERAL CONCEPT

**Kya hai:** A funnel views the customer journey as **sequential stages**, where each stage is a subset of the one before it — at every stage, some people "drop off" (don't proceed). Funnel analysis identifies **where** the biggest drop-off is.

**Why it matters:** Knowing "total sales = X" doesn't tell you *where* to improve. A funnel pinpoints the exact stage with the most opportunity.

**Classic example (not our project):** Impression → Click → Visit → Lead → Purchase.

## 2. MY PROJECT — Why We Rebuilt the Funnel (an honest, real correction)

We initially planned "Website Visits (monthly) → Web Purchases (2-year)" as funnel stages. When we checked the real numbers:

| Check | Result |
|---|---|
| Customers with ≥1 web visit (this month) | 2,202 (99.5%) |
| Customers with ≥1 web purchase (2 years) | 2,206 (99.7%) |

**Purchase count came out HIGHER than visit count** — impossible in a real funnel (a later stage can't exceed an earlier one). The cause: `num_web_visits_month` is a **1-month snapshot**, while purchases are a **2-year cumulative total** — different time windows, so they can't be sequential funnel stages.

**We caught this ourselves, by checking real numbers before publishing a claim** — exactly the kind of self-check a strong analyst does without being told. **Fix:** only use fields sharing the same (2-year, cumulative) time window for sequential funnel stages; demote the visit-vs-purchase comparison to a clearly-labeled "engagement proxy," not a funnel stage.

## 3. The Real Funnel (all stages share a consistent 2-year window)

```
Stage 1: Total Customers                           2,212   (100%)
              ↓  (drop-off: 6 customers, 0.3%)
Stage 2: Made ≥1 Purchase (any channel, 2 yrs)      2,206   (99.7%)
              ↓  (drop-off: 38 customers, 1.7%)
Stage 3: Used a Deal/Discount at least once         2,168   (98.0%)
              ↓  (drop-off: 1,564 customers, 72.1%)  ⚠️ BIGGEST DROP-OFF
Stage 4: Accepted ≥1 Marketing Campaign (of 6)        604   (27.3%)
```

### Funnel Metrics — Formulas

| Metric | Formula | Meaning |
|---|---|---|
| Stage % of total | `stage_count / stage1_count × 100` | What share of the original base reached this stage |
| Stage-to-stage retention | `stage_N / stage_(N-1) × 100` | What share of the *previous* stage proceeded |
| Drop-off | `100% − stage-to-stage retention` | What share was lost at this specific step |

## 4. Funnel by Customer Segment

| Segment | Made ≥1 Purchase | Accepted ≥1 Campaign |
|---|---|---|
| Champions | 100.0% | **47.8%** |
| Loyal Customers | 100.0% | 29.7% |
| At Risk | 99.6% | 13.8% |
| Lost/Hibernating | 98.5% | **7.4%** |

**Interpretation:** Purchase engagement barely varies by segment (98.5-100%) — everyone is a real, active-ish shopper. Campaign acceptance varies **6.5x** between best (Champions) and worst (Lost) segment — confirming the drop-off is specifically a **campaign relevance/targeting** issue, not a product-engagement issue, concentrated in the At Risk/Lost segments.

## 5. Funnel by Sales Channel

| Channel | Customers with ZERO purchases |
|---|---|
| Store | 14 (0.6%) |
| Web | 48 (2.2%) |
| Catalog | **575 (26.0%)** |

**Interpretation:** Store and Web are used by nearly everyone. Catalog is genuinely different — over a quarter of customers have *never* used it once.

## 6. Observation vs. Possible Explanation vs. Proven Cause

### GENERAL CONCEPT — this distinction is one of the most interview-important ideas in this whole project

| Level | Meaning | Example (our funnel) |
|---|---|---|
| **Observation** | What the data literally shows, no interpretation | "72.1% of deal-users never accept a campaign." |
| **Possible Explanation** | A reasonable, non-final hypothesis for *why* | "Maybe campaign offers aren't well-matched to what these customers actually buy." |
| **Proven Cause** | Established via a controlled experiment (e.g., A/B test) — **we never have this in this project** | "Changing X caused acceptance to increase by Y%" — ❌ not something we can claim |

**Rule we follow everywhere in this project:** state Observations confidently (they're just facts), state Explanations as hedged hypotheses ("may indicate," "worth investigating"), and **never** state a Proven Cause unless an actual experiment supports it (we never ran one).

## 7. MY PROJECT — What We Are NOT Claiming

- We do **not** claim low catalog usage or low campaign acceptance is *caused* by any specific factor (pricing, message, timing) — only that a pattern/association exists.
- We do **not** present the visit-vs-purchase ratio as a conversion rate — explicitly demoted to an "engagement proxy" after finding the time-window mismatch.
- We do **not** claim this funnel generalizes to any other company or dataset.

## 8. INTERVIEW

**Q: "Aapka funnel kis stage pe sabse zyada drop-off dikhata hai, aur kyun sense banata hai?"**
> "Deal-user se Campaign-acceptor stage ke beech — 72.1% drop. Ye sense banata hai kyunki 'discount use karna' ek low-effort, almost-automatic behavior hai, jabki 'targeted campaign accept karna' customer se zyada specific interest/timing/relevance maangta hai."

**Q: "Aapne shuru mein ek funnel design kiya tha jo galat nikla — kya hua?"**
> (A great real story, use it) "Website-visits (monthly snapshot) ko web-purchases (2-year cumulative) ke against funnel stage banaya tha. Jab real numbers check kiye, purchase-count visit-count se bada nikla — jo ek real funnel mein possible nahi hota. Maine time-window mismatch identify kiya aur us metric ko 'funnel stage' se 'engagement proxy' mein reclassify kiya — ye bina kisi ko bataye khud pakड़ी hui galti thi."

**Q: "Catalog channel ka 26% non-usage dekh kar aap kya suggest karoge?"**
> "'Investigate karo,' seedha solution nahi. Jaise: catalog distribution reach check karo, ya A/B test karo — catalog-non-users ko catalog exposure dene se behavior badalta hai ya nahi. Root-cause data se directly nahi pata chal sakta."

**Q: "Funnel se business ko kya concrete action milta hai?"**
> "At Risk/Lost segments ke liye problem 'purchase karna' nahi hai (wo already kar rahe hain) — problem hai 'campaign se connect na hona.' Isliye unke liye generic 'buy more' push ke bajaye alag messaging/offer-relevance strategy chahiye."

## 9. Common Mistakes

- Different time-window fields ko funnel stages ki tarah treat karna (humne khud ye pakड़ा aur fix kiya).
- Observation ko seedha Proven Cause bol dena — "catalog channel bekar hai" jaisa overclaim.
- Sirf overall funnel dekhna, segment/channel-wise breakdown na karna — asli insight wahin chhupa hota hai.

## 10. What I Should Remember

1. The funnel (2,212 → 2,206 → 2,168 → 604) uses ONLY same-time-window (2-year cumulative) fields — this was a deliberate, corrected design choice.
2. Biggest drop-off: Stage 3 → Stage 4 (72.1%) — a campaign-relevance problem, not a product problem.
3. Catalog has a real, distinct 26% never-used gap — worth investigating, not worth an unproven conclusion.
4. Always separate Observation / Possible Explanation / Proven Cause — never skip straight to the third.

---
*Next: [14_CAMPAIGN_ANALYSIS.md](14_CAMPAIGN_ANALYSIS.md)*
