# 00 — Project Blueprint

# MARKETING INTELLIGENCE & CAMPAIGN OPTIMIZATION PLATFORM
### Customer Campaign Response, Conversion & ROI Analytics

Status: **Phase 0 complete** (dataset chosen and verified with real data). This document is the single source of truth for scope — every later phase must stay consistent with what's written here.

---

## 1. Business Scenario

Our company sells food/grocery-style products to an existing customer base through **three sales channels** — Website, Catalog, and physical Store. Over roughly two years, the company ran **six direct-marketing campaigns** (personalized offers/promotions) targeted at its entire customer database, and tracked which customers accepted each offer.

Leadership wants to know:

- Which of our 6 campaigns actually worked, and which wasted money?
- Which customer segments respond to campaigns — and which never respond at all?
- Are we acquiring/retaining customers efficiently, or losing money on outreach?
- Which sales channel (Web / Catalog / Store) is doing the heavy lifting?
- Where does customer engagement drop off between "visiting" and "buying"?
- What should we do differently for the next campaign?

This is an **analytics and business-reasoning project**, not a machine-learning project. Every number in every chart traces back to a real column in a real dataset.

## 2. Business Problem

> "We've run 6 campaigns and have 2,240 customers' worth of purchase history, but we don't have a structured way to tell which campaigns/segments/channels are worth investing in again."

The project answers this with SQL + Python analysis, a segmentation model, funnel analysis, and a Power BI dashboard that a marketing/business stakeholder could actually act on.

## 3. Dataset Decision — Evidence, Not Guesswork

Per your instruction, I inspected multiple real candidates **before** deciding. I did not pick something just because it's famous.

### 3.1 Candidates evaluated

| Dataset | Real? | Has Revenue? | Has Channels? | Has Funnel? | Verdict |
|---|---|---|---|---|---|
| **Customer Personality Analysis / iFood Marketing Campaign** (chosen) | ✅ Yes, CC0 public domain, originally a real iFood Data-Analyst hiring case | ✅ Yes — real $ spend per customer | ✅ Yes — Web/Catalog/Store purchase channels | ⚠️ Partial — Visits→Purchases proxy | **Selected** — richest genuine coverage of campaigns + revenue + segmentation |
| Bank Marketing (UCI, Moro et al. 2014) | ✅ Yes, DOI-cited, peer-reviewed, 45,211 rows | ❌ No revenue/spend at all | ⚠️ Only "cellular vs telephone" | ⚠️ Single-step (contact→subscribe) | Excellent provenance, but **zero** revenue/ROI/CAC/CTR — too big a gap vs. your KPI goals |
| Sales Conversion Optimization / Facebook Ads (Kaggle, `loveall`) | ✅ Yes, real anonymized FB ad data, 1,143 rows | ❌ No revenue field | ❌ Single channel only (Facebook) | ✅ Impressions→Clicks→Conversion | Great for CTR/CPC teaching, but thin provenance, no revenue, only 3 campaigns, single channel — too small to be the flagship |

**Decision: Customer Personality Analysis (a.k.a. "iFood Marketing Campaign" dataset) is the primary dataset.**

I did **not** blend multiple unrelated datasets together — stitching two different companies' data into one story would itself look fabricated in an interview. One coherent, real, defensible dataset is safer and simpler.

### 3.2 Why this dataset, specifically

- **Genuinely real**: originally released by Dr. Omar Romero-Hernandez / used as an actual iFood (Brazilian food-delivery company) Data Analyst hiring case ([source repo](https://github.com/nailson/ifood-data-business-analyst-test)). Mirrored publicly on Kaggle under **CC0 (public domain)** license as ["Customer Personality Analysis"](https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis) — 1.2M+ views, 258K+ downloads, tagged "well-documented" and "clean data" by the community.
- Covers **6 real campaigns**, **real revenue** (2-year product spend), **real purchase-channel behavior**, and **real demographic fields** — enough to legitimately build segmentation, campaign ROI, and funnel analysis without inventing a single number.
- Small enough (2,240 rows) for a beginner to fully understand every row, large enough to be statistically meaningful.
- Has **genuine data quality problems** (missing values, outliers, inconsistent categories) — perfect, honest material for the Data Cleaning phase, rather than a suspiciously "already perfect" dataset.

### 3.3 Verified facts (I downloaded and inspected the actual file — nothing below is assumed)

```
File:        data/raw/ifood_marketing_campaign_raw.csv
Rows:        2,240 customers
Columns:     29
Duplicates:  0 duplicate rows, 0 duplicate customer IDs
Date range:  Dt_Customer (enrollment) from 2012-07-30 to 2014-06-29
```

| Check | Verified Result |
|---|---|
| Missing values | `Income` has **24 missing values** (float64, NaN) — everything else is complete |
| Impossible ages | 3 customers have `Year_Birth` of 1893, 1899, 1900 → implied ages 114–121 in 2014 — clearly bad data |
| Income outlier | Max `Income` = 666,666 vs. next-highest 162,397 — a clear outlier; median is 51,381 |
| Inconsistent categories | `Marital_Status` includes `Alone` (3), `Absurd` (2), `YOLO` (2) — 7 rows with non-standard labels |
| `Z_CostContact` / `Z_Revenue` | Constant at **3** and **11** for every row — this is a documented convention from the original dataset (assumed cost to contact one customer, and assumed revenue if they accept an offer), **not a number I invented**. We will use it transparently, labeled as an assumption. |
| Campaign acceptance rates (real, calculated) | Cmp1: 6.43% · Cmp2: 1.34% · Cmp3: 7.28% · Cmp4: 7.46% · Cmp5: 7.28% · Response (last/6th): 14.91% |
| Customers who never accepted any campaign | 1,631 of 2,240 (**72.8%**) — a genuinely striking, real headline number |
| Total 2-year spend (`TotalSpend`, derived) | min 5, median 396, mean 605.8, max 2,525 (monetary unit not specified in source — we will call it "monetary units," not claim a currency) |

### 3.4 What this dataset does **NOT** support (stated upfront, not discovered halfway through)

Being upfront now avoids fabricating later:

| Requested in the brief | Available? | What we'll actually do |
|---|---|---|
| Channels = Email/Social/Search/Display/Referral | ❌ Not in data | Reframe "channel" as the real **sales/purchase channel** (Web/Catalog/Store) — a legitimate, different, still-valuable channel-efficiency question |
| Impressions / Clicks / CTR | ❌ Not in data | Will **not** invent these. Documented as unavailable. (Optional add-on dataset noted below if you want CTR/CPC teaching later.) |
| Funnel: Impressions→Clicks→Visits→Leads→Purchases | ⚠️ Partial | Real funnel we *can* build: **Website Visits (monthly) → Web Purchases (2-yr)**. Flagged clearly as a proxy because the two fields use different time windows — a real limitation we'll explain, not hide. |
| Campaign performance trend over time | ❌ Not derivable | No campaign launch/end dates exist, only accept/not-accept per customer. We can still compare campaigns to each other, just not plot a real calendar timeline. |
| Geography | ❌ Not in data | No country/state/city fields in this file. Skipped — not faked. |
| True ROAS/ROI at transaction-level | ⚠️ Approximate only | Built from the `Z_CostContact`/`Z_Revenue` constants — a modeling assumption, always labeled as such, never presented as observed fact. |

**Optional future add-on (not built now):** if you later want to practice Impressions/Clicks/CTR/CPC specifically, the Kaggle "Sales Conversion Optimization" (Facebook Ads) dataset can be added as a clearly-separated, clearly-labeled **Module B**, without merging it into this dataset's story. Documented in [11_web_layer.md](../docs/11_web_layer.md)-adjacent notes when we get there — not required for a strong project.

## 4. Data Sources & Licensing

- **Primary technical source (downloaded, reproducible, no login required):** `https://raw.githubusercontent.com/nailson/ifood-data-business-analyst-test/master/ml_project1_data.csv`
- **License / citation of record (recommended for your README/resume):** ["Customer Personality Analysis"](https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis) by Akash Patel, Kaggle, **CC0: Public Domain**. Same schema — verified column-for-column against our downloaded file (29/29 match).
- **Business origin story (for interview color, not a licensing source):** the data originates from a real Data Analyst hiring case published by iFood (Brazilian food-delivery marketplace); the case has been public and openly analyzed (100+ public notebooks, 1.2M+ Kaggle views) for years, so it is safe to discuss openly as a "real company case study" rather than a live/confidential test.

## 5. File / Table Structure

### Raw (as downloaded — untouched)
```
data/raw/ifood_marketing_campaign_raw.csv    (2,240 rows × 29 columns, single flat file)
```

### Processed (planned output of Phase 2 — a small, honest star schema)

Rather than leaving one giant wide table, we'll restructure into a simple **fact/dimension** design. This is a genuine, standard data-modeling technique (not invented complexity) and it's exactly what lets us teach real SQL `JOIN`s in Phase 4:

```
dim_customers.csv           — 1 row per customer: cleaned demographics, derived age,
                               tenure, RFM fields, total spend, segment labels
fact_campaign_response.csv  — 1 row per (customer, campaign): unpivoted from the 6
                               wide AcceptedCmp*/Response columns → customer_id,
                               campaign_name, accepted
fact_channel_purchases.csv  — 1 row per (customer, channel): unpivoted from
                               NumWebPurchases/NumCatalogPurchases/NumStorePurchases
                               → customer_id, channel, num_purchases
```

`dim_customers` is the **dimension** (describes who the customer is); the two `fact_*` tables are **facts** (record an event/measurement: did they accept a campaign, did they buy through a channel). This mirrors real-world data warehouse design and gives us a clean teaching example of "fact vs. dimension" in Phase 1.

## 6. Important Fields (summary — full data dictionary in Phase 1 doc)

| Field | Meaning |
|---|---|
| `ID` | Unique customer identifier (primary key) |
| `Year_Birth`, `Education`, `Marital_Status`, `Income`, `Kidhome`, `Teenhome` | Customer demographics |
| `Dt_Customer` | Date customer enrolled |
| `Recency` | Days since customer's last purchase |
| `MntWines`...`MntGoldProds` (6 columns) | $ spent per product category in last 2 years — sums to real Revenue |
| `NumDealsPurchases`, `NumWebPurchases`, `NumCatalogPurchases`, `NumStorePurchases` | Purchase counts by channel/type |
| `NumWebVisitsMonth` | Website visits in the last month |
| `AcceptedCmp1`–`AcceptedCmp5`, `Response` | Accept/reject flags for the 6 campaigns |
| `Complain` | Complained in last 2 years (0/1) |
| `Z_CostContact`, `Z_Revenue` | Constant assumption values (cost to contact = 3, revenue if accepted = 11) used for campaign ROI math |

## 7. Relationships

Single source table today → split into 1 dimension + 2 fact tables in Phase 2, joined on `customer_id`:

```
dim_customers (1) ───< fact_campaign_response (many)
dim_customers (1) ───< fact_channel_purchases (many)
```

## 8. Main KPIs (only what's genuinely available — full formulas & Hinglish teaching in Phase 3)

- Total Customers, Total Campaigns
- Campaign Acceptance Rate (= Conversion Rate per campaign)
- Total Revenue, Average Spend per Customer
- Campaign Cost, Campaign Revenue, Campaign Profit, Campaign ROI (via `Z_CostContact`/`Z_Revenue`)
- Customer Acquisition Cost (cost per responding customer)
- RFM: Recency (given), Frequency (derived), Monetary (derived)
- Channel Mix (% purchases via Web/Catalog/Store)
- Visit-to-Purchase engagement proxy
- Complaint Rate
- Multi-campaign responsiveness (0–5 campaigns accepted, per customer)

**Not calculated:** CTR, Impressions, CPC/CPM, ROAS-by-ad, geographic breakdowns — genuinely unavailable, explicitly not faked.

## 9. Business Questions This Project Will Answer

- Which campaign had the best/worst acceptance rate, and by how much?
- Which customer segments (income, family size, age, education) respond more?
- Is the company acquiring campaign responders profitably, given the cost/revenue assumption?
- Which sales channel dominates, and does that differ by segment?
- Where's the biggest engagement drop-off (visits vs. purchases)?
- Which segment should get the next campaign budget?

## 10. Analysis Roadmap (phase order — will not be skipped around)

| Phase | Deliverable |
|---|---|
| 0 | `docs/00_project_blueprint.md` ✅ (this file) |
| 1 | `docs/01_dataset_understanding.md` |
| 2 | `docs/02_data_cleaning.md` + cleaning script |
| 3 | `docs/03_marketing_kpis.md` |
| 4 | `sql/*.sql` + `docs/04_sql_learning.md` |
| 5 | `docs/05_customer_segmentation.md` (RFM-style, no ML) |
| 6 | `docs/06_funnel_analysis.md` |
| 7 | `notebooks/01_marketing_eda.ipynb` + `docs/07_python_eda_learning.md` |
| 8 | `docs/08_statistics_learning.md` |
| 9 | `docs/09_business_insights.md` |
| 10 | Power BI dashboard + `docs/10_powerbi_learning.md` |
| 11 | *(Optional)* Web presentation layer + `docs/11_web_layer.md` |
| 12–18 | Interview prep, resume bullets, quick revision, final audit |

## 11. Technology Stack

| Layer | Tool | Why |
|---|---|---|
| Data cleaning & EDA | Python (pandas, numpy, matplotlib, seaborn) in Jupyter | Industry-standard, beginner-friendly, visual |
| Analysis / querying | SQL on SQLite (local, file-based) | Zero server setup; still 100% real SQL (SELECT/JOIN/GROUP BY/CTE) |
| Dashboard | Power BI Desktop | Resume-required BI tool; basic DAX only |
| Optional presentation | React or Next.js reading pre-computed CSV/JSON | Only if time permits — never the core project |

## 12. Folder Structure (already created)

```
DA2/
├── data/
│   ├── raw/            ✅ ifood_marketing_campaign_raw.csv
│   └── processed/       (Phase 2 output)
├── sql/                  (Phase 4)
├── notebooks/            (Phase 7)
├── scripts/              (Phase 2 cleaning script)
├── dashboard/            (Phase 10 .pbix)
├── web/                  (Phase 11, optional)
├── docs/                 ✅ this blueprint
├── screenshots/          (dashboard screenshots for portfolio)
├── README.md             ✅
├── requirements.txt      ✅
└── .gitignore            ✅
```

## 13. Learning Roadmap (preview — full teaching happens inline per phase)

- **SQL:** SELECT, WHERE, GROUP BY, ORDER BY, JOIN, CASE WHEN, aggregates, subqueries, simple CTEs, only-if-useful window functions
- **Python/Pandas:** loading, cleaning (`fillna`, `dropna`, `astype`, date parsing), groupby, merge, derived columns
- **Statistics:** mean/median, percentage, distribution, std dev, correlation — only where genuinely useful
- **Segmentation:** RFM logic (no clustering/ML)
- **Power BI:** data model, basic DAX measures, slicers, KPI cards

## 14. Interview Scope

Everything in the final interview-prep doc will map 1:1 to something actually built here: real SQL you wrote, real pandas cleaning decisions, real KPI formulas, real dashboard choices. Nothing about deep learning, clustering, or advanced statistics will appear, because none of that is used.

## 15. How This Differs From Your E-Commerce Sales & Customer Analytics Project

Since I haven't seen that project's exact contents, here's the intended differentiation — tell me if your old project already covered any of this and I'll adjust:

| Angle | Typical E-commerce Sales Dashboard | This Project |
|---|---|---|
| Core question | "How much did we sell, by product/time/region?" | "Which campaigns/segments are worth investing marketing budget in?" |
| Key new KPI family | Revenue, AOV, top products | **Campaign acceptance rate, CAC, campaign ROI/profit** |
| Segmentation purpose | Who are our best customers (retention) | **Who should receive the *next* campaign (targeting)** |
| New analytical structure | Usually one flat sales table | **Fact/dimension star schema** built via unpivoting — new SQL `JOIN` practice |
| Funnel concept | Rare in sales dashboards | **Visit → Purchase engagement funnel**, explicitly a marketing concept |
| Narrative arc | Backward-looking reporting | Forward-looking decision recommendation ("reinvest in Campaign X / target Segment Y") |

## 16. Limitations We Will State Openly (not hide)

- Single-company dataset — no cross-company/cross-industry generalization claims.
- No true ad-channel or funnel-impression data — "channel" here means sales channel, not acquisition channel.
- `Z_CostContact`/`Z_Revenue` are dataset-provided constants, not observed per-transaction financials — every ROI number built on them will be labeled as an estimate.
- No campaign dates — no real time-series trend of campaign performance.
- Currency unit is unspecified in the source — figures are called "monetary units," never assigned a currency symbol we can't verify.

---
*Next: Phase 1 — `docs/01_dataset_understanding.md` (full column-by-column data dictionary, beginner-friendly Hinglish explanation of rows/columns/dimensions/measures/keys).*
