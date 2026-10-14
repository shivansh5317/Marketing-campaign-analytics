# 05 — Customer Segmentation (RFM-style, no ML)

## 1. What is Segmentation? (Hinglish)

**Kya hai:** Segmentation matlab apne poore customer base ko **chote, meaningful groups** mein baantna, taaki har group ke saath alag tarike se deal kiya ja sake — jaise sabko same email bhejne ke bajaye, "high-value customers" ko VIP offer aur "inactive customers" ko win-back offer bhejna.

**Kyun zaroori hai:** Har customer same nahi hota — kuch bahut zyada spend karte hain aur baar-baar aate hain, kuch sirf ek baar aake gayab ho jaate hain. Agar business sabko EXACTLY same tareeke se treat kare (same offer, same frequency of contact), toh:
- High-value customers ko under-appreciate kar sakte hain (unhe zyada special treatment deni chahiye thi)
- Low-value/inactive customers pe paisa waste kar sakte hain (jo respond hi nahi karenge)

**Chota generic example:** Ek mobile network company apne users ko "heavy data users," "occasional users," aur "inactive users" mein baantti hai — heavy users ko unlimited data plan offer karti hai, inactive users ko "wapas aao" discount bhejti hai.

**Project mein use:** Humne **RFM (Recency, Frequency, Monetary)** — ek classic, widely-used, non-ML segmentation technique — use ki hai, jo humare paas genuinely available fields se seedha calculate hoti hai.

**Common mistake:** Segmentation ke liye seedha ML clustering (K-Means, etc.) pe jump kar dena. Jab data simple/low-dimensional ho aur business ko "why is this customer in this segment" ka **clear, rule-based answer** chahiye ho, RFM jaisa explainable approach zyada practical aur defensible hota hai — ML clustering black-box hota hai aur interview mein justify karna mushkil.

**Interview questions:**
- *"Segmentation kya hai aur business isse kyun use karte hain?"* → Customers ko groups mein baant ke har group ke liye targeted strategy banana, resources efficiently allocate karna.
- *"RFM aur K-Means clustering mein kya farak hai?"* → RFM rule-based hai (fixed formula, koi bhi customer ka segment predict karna easy/transparent), K-Means data-driven/black-box hai (clusters ka exact meaning har baar interpret karna padta hai, aur naya data aane pe clusters shift ho sakte hain).

## 2. Why RFM specifically? (fields we actually have)

| RFM Component | Column we already have | Source |
|---|---|---|
| **R**ecency | `recency` | Given directly in the raw data (days since last purchase) |
| **F**requency | `total_purchases` (derived) | `num_web_purchases + num_catalog_purchases + num_store_purchases` (Phase 2) |
| **M**onetary | `total_spend` (derived) | Sum of the 6 product spend columns (Phase 2) |

All three genuinely exist — nothing invented. This is exactly why RFM was the natural choice over, say, geographic or behavioral-clickstream segmentation (which this dataset doesn't support).

## 3. How We Defined the Segments (methodology)

### Step 1 — Score each dimension into quartiles (1–4)

**Concept: Quartile.** Kisi bhi numeric column ko **4 barabar-size groups** mein baantna, sorted order mein — bottom 25% = Q1, next 25% = Q2, next 25% = Q3, top 25% = Q4. (Full stats explanation with formulas comes in Phase 8 — here we just use the idea.)

We scored each customer 1–4 on each of R, F, M using their real quartile cutoffs:

| Score | Recency (days) — lower is better, so reversed | Frequency (purchases) | Monetary (spend) |
|---|---|---|---|
| 1 (worst) | 74–99 | 0–6 | 5–69 |
| 2 | 49–74 | 6–12 | 69–397 |
| 3 | 24–49 | 12–18 | 397–1,048 |
| 4 (best) | 0–24 | 18–32 | 1,048–2,525 |

⚠️ **Important, deliberate reversal:** for Recency, a **lower** number is better (recently active), so we flip the score direction (0–24 days → score 4, not score 1). Getting this backwards is the single most common RFM mistake.

### Step 2 — Combine into one RFM Score (3–12)

`rfm_score = R_score + F_score + M_score` — simple sum, so a customer who's simultaneously recent, frequent, and high-spending gets close to 12; a customer who's none of those gets close to 3.

### Step 3 — Map the score to 4 explainable segment names

| RFM Score | Segment |
|---|---|
| 10–12 | **Champions** |
| 7–9 | **Loyal Customers** |
| 5–6 | **At Risk** |
| 3–4 | **Lost / Hibernating** |

This mapping is a **business judgment call**, not a statistical formula — we chose 4 segments (not 8 or 27) deliberately, to keep it simple enough that every segment is easy to explain and act on. Full implementation: [scripts/segment_customers.py](../scripts/segment_customers.py).

## 4. How Customers Are Assigned (real, verified segment sizes)

| Segment | Customers | % of Base | Avg Recency | Avg Frequency | Avg Monetary |
|---|---|---|---|---|---|
| Champions | 534 | 24.1% | 27.7 days | 20.2 purchases | 1,234 |
| Loyal Customers | 849 | 38.4% | 53.6 days | 14.6 purchases | 718 |
| At Risk | 560 | 25.3% | 49.2 days | 6.2 purchases | 113 |
| Lost / Hibernating | 269 | 12.2% | 76.5 days | 4.3 purchases | 43 |

## 5. What Each Segment Means (business interpretation)

- **Champions (24.1%)** — Recently active, buy often, spend the most. These are the customers the business should protect and reward (loyalty perks, early access to new products) — losing them would hurt the most.
- **Loyal Customers (38.4%, the largest group)** — Solid, dependable, moderately engaged. Good candidates for upsell campaigns to push them toward "Champion" status.
- **At Risk (25.3%)** — Still fairly recent, but low frequency and spend. Possible early warning group — worth a re-engagement offer before they slide into "Lost."
- **Lost / Hibernating (12.2%)** — Haven't purchased in a long time, low historical frequency/spend. Lowest priority for expensive campaigns; a low-cost win-back email is more appropriate than a heavy marketing spend.

## 6. Business Validation — Do These Segments Actually Matter?

We didn't stop at defining segments — we checked whether they actually explain real behavior, by joining segments against the campaign-response and revenue data:

| Segment | Campaign Acceptance Rate | Share of Total Revenue |
|---|---|---|
| Champions | **15.14%** | **49.1%** |
| Loyal Customers | 7.64% | 45.4% |
| At Risk | 2.86% | 4.7% |
| Lost / Hibernating | **1.43%** | **0.9%** |

**This is a genuinely powerful, real, verified finding:** just 24.1% of customers (Champions) generate **49.1% of all revenue** and respond to campaigns at **~10x the rate** of Lost/Hibernating customers (15.14% vs 1.43%). Combined, Champions + Loyal Customers (62.5% of the base) drive **94.5% of total revenue** — the classic "small share of customers drive most of the value" pattern, now backed by our own numbers rather than assumed.

## 7. Interview Questions

- *"Aapne 4 hi segments kyun banaye, 3 ya 8 kyun nahi?"* → 4 segments business-actionable rehte hain (har ek ke liye clear, alag strategy sochi ja sakti hai) bina overly granular hue; RFM score range (3–12) ko 4 baraabar-ish buckets mein baantna bhi natural tha.
- *"Recency ko score karte waqt direction kyun reverse ki?"* → Kyunki low recency (kam din pehle purchase kiya) achha hai — agar seedha score karte (high recency = high score), toh sabse INACTIVE customers ko "best" score mil jaata, jo galat hota.
- *"Ye segmentation model business mein deploy hone ke baad kaise update hoga?"* → Recency/Frequency/Monetary time ke saath change hote hain, isliye ye script (`segment_customers.py`) ko periodically (jaise monthly) re-run karna hoga taaki segments current data reflect karein — ek one-time static analysis nahi hai.
- *"Champions segment sabse zyada revenue deta hai — iska matlab baaki segments ignore kar dein?"* → Nahi — At Risk aur Loyal segments abhi bhi meaningful revenue (~50%) contribute karte hain; sahi approach ye hai ki **har segment ke liye cost-appropriate strategy** banayi jaaye (Champions pe zyada invest, Lost pe minimal-cost re-engagement), poori tarah ignore nahi karna.

---
*Next: Phase 6 — `docs/06_funnel_analysis.md` (deep-diving the Visit→Purchase funnel we previewed in SQL Phase 4, including segment-wise and channel-wise breakdowns).*
