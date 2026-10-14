# 17 — Customer Segmentation

🔴 MUST KNOW

## 1. What Is Segmentation?

### GENERAL CONCEPT

**Kya hai:** Segmentation matlab poore customer base ko **chhote, meaningful groups** mein baantna, taaki har group ke saath alag strategy se deal kiya ja sake.

**Why companies segment:** Har customer same nahi hota. High-value customers ko under-appreciate karna, ya low-value/inactive customers pe paisa waste karna — dono avoid karne ke liye segmentation zaroori hai.

**What is a segment:** Ek group of customers jo ek shared characteristic/behavior ke basis pe define hua ho (demographic, behavioral, engagement-based, ya RFM).

## 2. MY PROJECT — RFM Segmentation (the actual method used)

⚠️ **No ML/clustering (no K-Means) is used anywhere in this project.** Segmentation is 100% rule-based RFM, computed directly from fields the dataset genuinely provides.

### Why RFM Specifically

| RFM Component | Column we have | Source |
|---|---|---|
| **R**ecency | `recency` | Given directly (days since last purchase) |
| **F**requency | `total_purchases` | Derived: web+catalog+store purchases |
| **M**onetary | `total_spend` | Derived: sum of 6 product-spend columns |

All three genuinely exist — nothing invented. This is why RFM was the natural choice, not a trend/behavioral-clickstream segmentation (which this dataset doesn't support).

### RFM From Scratch

- **Recency:** How recently did this customer last purchase? *Lower is better* (more recently active).
- **Frequency:** How often has this customer purchased? *Higher is better.*
- **Monetary:** How much has this customer spent? *Higher is better.*

### Step 1 — Quartile Scoring (1-4 each)

Each customer is scored 1-4 on R, F, M using **quartiles** (4 equal-sized groups by count — see [18_STATISTICS_FROM_ZERO.md](18_STATISTICS_FROM_ZERO.md) for the general quartile concept):

| Score | Recency (days) — reversed, lower=better | Frequency (purchases) | Monetary (spend) |
|---|---|---|---|
| 1 (worst) | 74-99 | 0-6 | 5-69 |
| 2 | 49-74 | 6-12 | 69-397 |
| 3 | 24-49 | 12-18 | 397-1,048 |
| 4 (best) | 0-24 | 18-32 | 1,048-2,525 |

⚠️ **The single most common RFM mistake, which we handled deliberately:** for Recency, LOW is good, so the score direction is **reversed** (0-24 days → score 4, not score 1). Getting this backwards silently breaks the entire segmentation.

### Step 2 — Combine Into One Score

`rfm_score = R_score + F_score + M_score` (range 3-12).

### Step 3 — Map Score → Segment Name

| RFM Score | Segment |
|---|---|
| 10-12 | **Champions** |
| 7-9 | **Loyal Customers** |
| 5-6 | **At Risk** |
| 3-4 | **Lost / Hibernating** |

This 4-segment mapping is a **business judgment call**, not a statistical formula — chosen to be simple enough that every segment is easy to explain and act on (not 8 or 27 segments). Implementation: [scripts/segment_customers.py](../../scripts/segment_customers.py).

**A real implementation gotcha we handled:** `pd.qcut()` can fail ("bin edges must be unique") when many rows share the same value. For `total_purchases` specifically, we applied `.rank(method="first")` before `qcut` to break ties, so 4 equal-sized groups are always achievable.

## 3. Real, Verified Segment Sizes & Profile

| Segment | Customers | % of Base | Avg Recency | Avg Frequency | Avg Monetary |
|---|---|---|---|---|---|
| Champions | 534 | 24.1% | 27.7 days | 20.2 purchases | 1,234 |
| Loyal Customers | 849 | 38.4% | 53.6 days | 14.6 purchases | 718 |
| At Risk | 560 | 25.3% | 49.2 days | 6.2 purchases | 113 |
| Lost/Hibernating | 269 | 12.2% | 76.5 days | 4.3 purchases | 43 |

## 4. What Each Segment Means (Business Interpretation)

- **Champions (24.1%)** — Recently active, buy often, spend the most. Protect and reward (loyalty perks, early access).
- **Loyal Customers (38.4%, largest group)** — Solid, moderately engaged. Good upsell-to-Champion candidates.
- **At Risk (25.3%)** — Fairly recent but low frequency/spend. Early-warning group for re-engagement offers.
- **Lost/Hibernating (12.2%)** — Long inactive, low historical value. Lowest priority for expensive campaigns; a low-cost win-back email fits better.

## 5. Business Validation — Do These Segments Actually Matter?

| Segment | Campaign Acceptance Rate | Share of Total Revenue |
|---|---|---|
| Champions | **15.14%** | **49.1%** |
| Loyal Customers | 7.64% | 45.4% |
| At Risk | 2.86% | 4.7% |
| Lost/Hibernating | **1.43%** | **0.9%** |

**A genuinely powerful, real, verified finding:** just 24.1% of customers generate **49.1%** of all revenue and respond to campaigns at **~10x** the rate of the lowest segment. Champions + Loyal (62.5% of base) drive **94.5%** of total revenue.

## 6. RFM vs. K-Means Clustering (GENERAL CONCEPT comparison, since this is a common interview trap)

| | RFM (used here) | K-Means Clustering (NOT used here) |
|---|---|---|
| Type | Rule-based, fixed formula | Data-driven, algorithm-discovered |
| Explainability | High — anyone can see exactly why a customer is in a segment | Lower — cluster meaning must be interpreted after the fact, can be "black box" |
| Stability | Segment definitions are fixed and transparent | Clusters can shift if the data or number-of-clusters (k) changes |
| When appropriate | Simple, low-dimensional data; stakeholders need a clear "why" | Higher-dimensional data, when natural groupings aren't obvious from known business rules |
| Used in this project? | ✅ Yes | ❌ No — not needed, and would add unnecessary complexity/defense burden for this scope |

## 7. INTERVIEW

**Q: "Aapne 4 hi segments kyun banaye?"**
> "RFM score range (3-12) ko 4 roughly-equal buckets mein baantna natural tha, aur 4 segments business-actionable rehte hain — har ek ke liye clear, alag strategy sochi ja sakti hai, bina overly granular hue."

**Q: "Recency ko score karte waqt direction kyun reverse ki?"**
> "Kyunki low recency (kam din pehle purchase kiya) achha hai. Agar seedha score karte, sabse INACTIVE customers ko 'best' score mil jaata — ye galat hota."

**Q: "RFM aur K-Means mein farak, aur aapne RFM kyun choose kiya?"**
> "RFM rule-based/transparent hai — koi bhi dekh sakta hai ki customer X kyun is segment mein hai. K-Means data-driven/black-box hota hai. Humara data simple/low-dimensional tha aur stakeholders ko clear 'why' chahiye tha, isliye RFM zyada defensible choice thi."

**Q: "Champions sabse zyada revenue dete hain — baaki segments ignore kar den?"**
> "Nahi — At Risk aur Loyal abhi bhi meaningful revenue (~50%) contribute karte hain. Sahi approach: har segment ke liye cost-appropriate strategy (Champions pe zyada invest, Lost pe minimal-cost touch), poori tarah ignore nahi karna."

**Q: "Ye segmentation kitni baar update honi chahiye?"**
> "Recency/Frequency/Monetary time ke saath badalte hain, isliye `segment_customers.py` ko periodically (jaise monthly) re-run karna chahiye — ye ek one-time static analysis nahi hai."

## 8. Common Mistakes

- Recency scoring direction reverse karna bhool jaana.
- Bahut zyada segments banana (8+) — actionability kam ho jaati hai.
- Segmentation ko "set once, forget forever" samajhna — ye data ke saath refresh hona chahiye.
- RFM ko ML clustering bol dena interview mein — ye technically galat hai, clearly differentiate karo.

## 9. What I Should Remember

1. RFM = Recency + Frequency + Monetary, quartile-scored (1-4 each), summed (3-12), mapped to 4 named segments. No ML.
2. Recency scoring is REVERSED (low recency = high score) — the #1 gotcha.
3. Champions = 24.1% of customers, 49.1% of revenue, 15.14% acceptance — the headline finding.
4. Segments are validated against real outcomes (revenue share, acceptance rate), not just defined and left unverified.

---
*Next: [18_STATISTICS_FROM_ZERO.md](18_STATISTICS_FROM_ZERO.md)*
