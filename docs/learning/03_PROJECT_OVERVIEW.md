# 03 — Project Overview

🔴 MUST KNOW

## 1. What Actually Exists In My Project

| Category | Details |
|---|---|
| **Dataset** | "Customer Personality Analysis" a.k.a. iFood Marketing Campaign dataset — 2,240 raw rows → 2,212 after cleaning, 29 raw columns |
| **Data source** | Real, public, CC0-licensed Kaggle dataset, originally a real iFood (Brazilian food-delivery co.) Data Analyst hiring case |
| **Tables (processed)** | `dim_customers` (2,212 rows), `fact_campaign_response` (13,272 rows), `fact_channel_purchases` (6,636 rows) |
| **SQL analyses** | 8 `.sql` files — campaign overview, channel performance, customer analysis, funnel, segments, conversion, revenue, advanced (CTEs + window functions) |
| **Python analyses** | Full EDA notebook (`notebooks/01_marketing_eda.ipynb`) — loaded, described, 6 univariate histograms, 3 categorical bar charts, campaign/channel bar charts, segment deep-dive (3 charts), correlation heatmap + scatter, funnel chart + boxplot — all executed with real output |
| **Statistics used** | Mean/median/mode, range/variance/std dev, percentiles/quartiles (used directly in RFM scoring), distribution shape/skew, outlier handling, correlation |
| **KPIs calculated** | Campaign Acceptance Rate, Campaign Cost/Revenue/Profit/ROI, CAC, Total Revenue, Avg Spend, Channel Share, Engagement proxy, Complaint Rate |
| **Funnel implemented** | Total Customers → Made ≥1 Purchase → Used a Deal → Accepted ≥1 Campaign (all real, 2-year-consistent fields) |
| **Segmentation implemented** | RFM (Recency/Frequency/Monetary) quartile scoring → 4 segments: Champions, Loyal Customers, At Risk, Lost/Hibernating. **No ML/clustering.** |
| **Power BI** | Full build specification written (`docs/10_powerbi_learning.md`) — **not yet built** in Power BI Desktop |
| **Frontend/web** | None — `web/` folder intentionally empty, optional and skipped |
| **Business insights** | 11 documented, evidence-based insights + 7 hedged recommendations (`docs/09_business_insights.md`) |

## 2. What Is NOT In My Project

Saying this openly so nothing gets accidentally over-claimed in an interview:

- ❌ No Machine Learning, no clustering (K-Means etc.) — segmentation is 100% rule-based RFM.
- ❌ No Impressions/Clicks/CTR/CPC — no ad-platform data exists in this dataset.
- ❌ No geographic data — no country/state/city columns.
- ❌ No campaign launch/end dates — can't build a real calendar time-series of campaign performance.
- ❌ No real per-transaction financials — campaign Cost/Revenue use the dataset's own stated constants (`Z_CostContact=3`, `Z_Revenue=11`), always labeled as an assumption.
- ❌ No live Power BI dashboard yet — a complete build spec exists, but it hasn't been physically built in Power BI Desktop.
- ❌ No hypothesis testing / p-values / confidence intervals — not needed (we have the full customer population, not a sample).
- ❌ No optional web front-end — skipped, out of scope.

## 3. Business Scenario

A retailer sells food/grocery-style products to an existing customer base through 3 sales channels (Website, Catalog, Store). Over ~2 years it ran 6 direct-marketing campaigns targeted at its whole customer database. Leadership wants to know which campaigns worked, which customer segments respond, whether outreach is efficient, which channel does the heavy lifting, and where engagement drops off.

## 4. The Pitches

### 30-Second Version

"Maine ek real customer-campaign dataset (2,212 customers, 6 marketing campaigns) analyze kiya SQL aur Python se — pata kiya kaunsi campaign best/worst perform kar rahi thi, RFM technique se customers ko 4 segments mein baanta, aur ek engagement funnel banaya jo dikhata hai customers kaha 'drop off' hote hain. Sabse bada insight: sirf 24% customers ('Champions') 49% revenue aur sabse zyada campaign response dete hain."

### 1-Minute Version

"Ye ek Marketing Analytics project hai ek real iFood customer dataset pe — 2,212 customers, 6 campaigns, 3 sales channels. Maine data clean kiya (missing income, impossible ages, junk categories fix kiye), phir ek fact/dimension star-schema banaya taaki SQL JOINs practice ho sakein. SQL se maine campaign performance, channel efficiency, aur customer-demographic patterns nikale. Phir Python/pandas se poora EDA kiya — distributions, correlations, segment-wise charts. Ek RFM-based segmentation banaya (Recency/Frequency/Monetary, koi ML nahi) jisse 4 customer groups mile — Champions se lekar Lost/Hibernating tak. Sabse important insight: Champions sirf 24% customers hain lekin 49% revenue aur 10x zyada campaign-response dete hain Lost customers ke muqable. Poora analysis ek Power BI dashboard mein present karne ka plan hai (build-spec ready hai)."

### 2-Minute Version

(1-minute version + add:)

"Data cleaning mein maine 4 real issues fix kiye — 3 impossible birth-years, ek extreme income outlier, 7 junk marital-status labels, aur ek text-typed date column. Har decision (drop vs. impute vs. recode) ko maine explicitly justify kiya — jaise Income missing sirf 24 rows (1%) tha isliye maine impute karne ke bajaye drop kiya, taaki artificial assumption inject na ho.

SQL side pe maine SELECT se lekar window functions (RANK, NTILE) tak sab use kiya — jaise NTILE se top-10%-by-spend customers ka VIP threshold nikala. Funnel analysis mein ek interesting cheez mili — maine shuru mein ek galat funnel design kiya tha (website-visits-monthly vs. purchases-2-year), jab numbers check kiye toh pata chala purchase-count visit-count se bada tha — jo impossible hai. Maine ye pakड़ ke fix kiya, real funnel banaya sirf consistent 2-year fields se — sabse bada drop-off 'deal-use' se 'campaign-accept' ke beech mila (72% drop)."

### 5-Minute Version (full walkthrough)

Use [23_END_TO_END_PROJECT_WALKTHROUGH.md](23_END_TO_END_PROJECT_WALKTHROUGH.md) — ye file specifically isi purpose ke liye bani hai, 17-stage pipeline (Business Problem → Limitations/Future Improvements) ko explain karti hai.

## 5. What Business Problem Are We Solving?

> "Humare paas 6 campaigns aur 2,212 customers ka purchase history hai, lekin ek structured tareeka nahi tha ye batane ka ki kaunsi campaigns/segments/channels dobara invest karne layak hain."

## 6. Why Does the Company Care?

Marketing budget limited hota hai. Bina analysis ke, company sabko same offer bhejti rehti — jo humne dikhaya hai financially loss-making hai (Insight 2, `docs/09_business_insights.md`). Analysis se targeted, efficient decisions liye ja sakte hain.

## 7. What Are We Measuring? (headline KPIs)

Campaign Acceptance Rate, Campaign ROI/CAC, Total Revenue, Channel Share, RFM segment sizes/value, Funnel drop-off %. Full formulas: [12_MARKETING_METRICS_FROM_ZERO.md](12_MARKETING_METRICS_FROM_ZERO.md).

## 8. Main Business Questions

- Which campaign had the best/worst acceptance rate, and by how much?
- Which customer segments respond more?
- Is the company acquiring responders profitably (under the stated assumption)?
- Which sales channel dominates?
- Where's the biggest engagement drop-off?
- Which segment should get the next campaign budget?

## 9. Tools Used

Python (pandas, numpy, matplotlib, seaborn) for cleaning/EDA · SQLite for SQL analysis · Power BI Desktop for the dashboard (build spec ready, not yet built).

## 10. What Does the Final Output Look Like?

A set of markdown reports (`docs/00`–`10`), a fully executed Jupyter notebook with real charts, 8 verified SQL analysis files, and (once built by hand in Power BI Desktop) a 4-5 page interactive dashboard.

## 11. INTERVIEW

**Q: "Ye project kis liye bana?"**
> "Portfolio/interview-preparation ke liye — Marketing Analytics domain mein SQL, Python, aur segmentation skills dikhane ke liye, ek genuinely real dataset use karke."

**Q: "Ye project kisi real company ke liye actually deployed hai?"**
> "Nahi — ye ek portfolio/learning project hai ek real, public dataset pe. Dataset khud ek real iFood hiring-case se aaya hai, lekin analysis maine independently ek learning/demonstration project ke roop mein kiya hai."

## 12. What I Should Remember

1. Real dataset, real numbers — nothing invented, always ready to point to the exact file/query behind any claim.
2. Power BI dashboard is a *planned, spec'd* deliverable, not yet built — always say this honestly if asked to show it.
3. Always have the 30-second and 1-minute pitches ready without needing notes.

---
*Next: [04_DATASET_DEEP_DIVE.md](04_DATASET_DEEP_DIVE.md)*
