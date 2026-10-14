# 16 — Customer Analysis

🟡 GOOD TO KNOW

## 1. Customer Analytics From Zero

### GENERAL CONCEPT

| Concept | Meaning |
|---|---|
| Customer count | How many distinct customers exist |
| Acquisition | Gaining new customers |
| Engagement | How actively a customer interacts (visits, purchases, campaign responses) |
| Purchase behavior | What/how/how-often a customer buys |
| Repeat behavior | Does a customer come back, or buy once and vanish |
| Customer value | How much revenue a customer represents |
| Response behavior | Does a customer respond to marketing outreach |
| Retention | Keeping existing customers active over time |

## 2. MY PROJECT — What We Actually Analyze

### Analysis 1 — Demographic Breakdown

- **Business question:** What does our customer base look like, and does any demographic relate to spend or response?
- **Data:** `dim_customers` (`education`, `marital_status`, `age`, `kidhome`/`teenhome`)
- **Logic:** `GROUP BY` + `AVG` (`sql/03_customer_analysis.sql`, `sql/05_segment_analysis.sql`)
- **Result:**
  - Education: Graduation is the largest group (50.4%); PhD has the highest campaign acceptance rate (9.17%), Basic the lowest (2.47%).
  - Age: 65+ spends the most on average (928) vs. Under-35 (573).
  - Family size: **No kids at home → 1,104 avg spend; Has kids → 409 avg spend** — a 2.7x difference, a stronger spend-differentiator than income alone.
- **Interpretation:** Family structure looks like a genuinely strong behavioral signal in this data.
- **Business relevance:** Could inform segmentation criteria beyond RFM alone (e.g., combining family-size with RFM segments).

### Analysis 2 — Responders vs. Non-Responders (Customer Value Comparison)

- **Business question:** Do campaign-responsive customers also tend to be higher-value customers?
- **Data:** `dim_customers` joined with a per-customer campaign-response summary
- **Logic:** `sql/07_revenue_analysis.sql` Query 3
- **Result:** Responders avg spend = 997; Never-Responded avg spend = 461 — **responders spend over 2x more.**
- **Interpretation:** Correlated, not necessarily causal — could mean campaigns drive extra spend, OR could mean already-high-value customers simply engage with everything more (including campaigns). We can't distinguish these from this data alone.

### Analysis 3 — Top Spenders / VIP Identification

- **Business question:** Who are our highest-value individual customers?
- **Data:** `dim_customers`, ranked by `total_spend`
- **Logic:** `ORDER BY total_spend DESC LIMIT 10` (`sql/07_revenue_analysis.sql` Query 2); decile-based VIP threshold via `NTILE(10)` (`sql/08_advanced_analysis.sql` Query 3)
- **Result:** Top spend decile (~221 customers) spans **1,536–2,525** — a real, data-driven VIP cutoff.
- **Business relevance:** A concrete, defensible list for a VIP/loyalty program, rather than an arbitrary threshold.

## 3. What Customer-Level Analysis Does NOT Tell Us Here

- We cannot distinguish "new" vs. "returning" customer acquisition — the dataset is a snapshot of existing customers, not an acquisition funnel over time.
- We cannot track an individual customer's behavior change over time (no repeated time-series per customer — each customer is a single row with 2-year cumulative totals).
- Retention, in the strict sense of "did this customer come back after a gap," isn't directly measurable — `Recency` and `Customer_Tenure_Days` are the closest proxies we have.

## 4. INTERVIEW

**Q: "Aapke project mein 'customer value' kaise define kiya?"**
> "Primarily `total_spend` (2-year product spend) se — ye hamara Monetary/RFM measure bhi hai. Combine karke Recency aur Frequency ke saath, humne RFM segmentation banaya jo value ko ek zyada complete tareeke se capture karta hai sirf spend se."

**Q: "Responders zyada spend karte hain — iska matlab campaign ne unhe zyada spend karwaya?"**
> "Zaroori nahi — reverse bhi ho sakta hai: already-high-spending customers campaigns ko bhi zyada respond karte hon. Hum sirf correlation report karte hain, causation prove karne ke liye A/B test chahiye hota, jo humare paas nahi hai."

**Q: "Aapke paas customer retention data hai kya?"**
> "Direct retention-over-time data nahi hai (ye ek snapshot dataset hai, time-series nahi). `Recency` aur `Customer_Tenure_Days` closest proxies hain — maine ye limitation explicitly document ki hai."

## 5. Common Mistakes

- Correlation (responders spend more) ko causation bol dena.
- Small-sample group ka average dekh kar strong conclusion nikalna (e.g., a 4-person category with a high average — always check `num_customers` alongside any average, a mistake explicitly caught in `sql/03_customer_analysis.sql` Query 2's "Other" marital-status group).
- "Retention" ko is dataset mein directly measurable maan lena.

## 6. What I Should Remember

1. Family size (kids at home) is a stronger spend-differentiator than income alone in this data (2.7x gap).
2. Responders spend 2x more than non-responders — correlation, not proven causation.
3. A real, data-driven VIP threshold exists (top decile: 1,536–2,525 spend) via `NTILE`.
4. Always check sample size before trusting a group's average.

---
*Next: [17_CUSTOMER_SEGMENTATION.md](17_CUSTOMER_SEGMENTATION.md)*
