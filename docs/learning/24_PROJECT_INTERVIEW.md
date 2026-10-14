# 24 — Project Interview

🔴 MUST KNOW

A detailed Q&A bank based **only** on this actual project. Format: **Question → Hinglish Answer → Technical Answer → Likely Follow-up → What's Being Tested → Common Mistake.**

## A. Basic Project Questions

| Question | Hinglish Answer | Technical Answer | Likely Follow-up | Tests | Common Mistake |
|---|---|---|---|---|---|
| Project kya hai? | "Ek real customer-campaign dataset pe Marketing Analytics project — kaunsi campaign kaam kar rahi, kaunse customer segments respond karte hain." | 2,212-customer, 6-campaign dataset; SQL+Python analysis, RFM segmentation, funnel analysis, Power BI spec. | "Kyun ye domain choose ki?" | Clarity of pitch | Rambling without a clear 1-min structure |
| Aapka role kya tha? | "Maine akela poora pipeline kiya — cleaning se lekar insights tak." | End-to-end: data cleaning, SQL, Python EDA, segmentation, funnel, insights. | "Sabse mushkil part kaunsa tha?" | Ownership/depth | Vague "I did analysis" without specifics |

## B. Dataset Questions

| Question | Hinglish Answer | Technical Answer |
|---|---|---|
| Dataset kaha se aaya? | "Real iFood hiring case, Kaggle pe CC0 license ke saath public." | 2,240 rows → 2,212 after cleaning, 29 columns, documented in [04_DATASET_DEEP_DIVE.md](04_DATASET_DEEP_DIVE.md) |
| Kitne rows/columns? | "2,212 customers, cleaning ke baad." | 29 raw → 24 cleaned + derived RFM columns in `dim_customers` |
| Missing values kaise handle kiye? | "Sirf Income mein 24 missing the (1%), maine drop kiya." | `dropna(subset=["Income"])` — justified in [10_DATA_CLEANING.md](10_DATA_CLEANING.md) |

**Follow-up trap:** *"Agar missing % 30% hota, tab bhi drop karte?"* → "Nahi — itna bada % hota toh imputation (median/mode) seriously consider karta, ya missing-ness ko khud ek feature flag bana deta."

## C. Data Cleaning

| Question | Answer Summary |
|---|---|
| Kya cleaning ki? | 5 issues: impossible ages, missing income, income outlier, junk marital-status labels, text-typed date. |
| Outlier kaise detect kiya? | Domain-logic checks — implausible age (>90), extreme value jump (666,666 vs 162,397). |
| Har outlier remove kiya? | Nahi — genuine high-spenders (VIP decile) kept, sirf clear data-errors removed. |

## D. SQL

| Question | Answer Summary |
|---|---|
| Kaunsi SQL concepts use ki? | SELECT→window functions — full list in [07_SQL_USED_IN_PROJECT.md](07_SQL_USED_IN_PROJECT.md) |
| JOIN ke baad fan-out kya hai? | One-to-many JOIN ke baad rows repeat hoti hain — `COUNT(*)` customer×campaign pairs ginta hai, customer count nahi. |
| CTE kyun use ki? | Multi-step profitability calculation (targeted→cost/revenue→profit/ROI/CAC) ko readable steps mein todne ke liye. |

## E. Python / F. Pandas

| Question | Answer Summary |
|---|---|
| Notebook mein kya kiya? | Load → describe → univariate (histograms) → categorical (bar) → campaign/channel bars → segment deep-dive → correlation+scatter → funnel+boxplot. All executed, real output. |
| `merge` kaha use kiya? | Segment label ko campaign-response rows pe attach karne ke liye, segment-wise acceptance rate nikalne hetu. |
| `qcut` kyun? | RFM quartile scoring ke liye — Recency/Frequency/Monetary ko 4-4 groups mein baantne ke liye. |

## G. Marketing Metrics

| Question | Answer Summary |
|---|---|
| Conversion rate formula? | accepted/targeted × 100. Cmp6=15.05% best, Cmp2=1.36% worst. |
| CTR calculate ki? | Nahi — ad-impression data nahi hai, openly documented as unavailable. |
| ROI negative hai, iska matlab? | "Contact-everyone" assumption ke against inefficient hai, marketing band karne ka matlab nahi. |

## H. Funnel Analysis

| Question | Answer Summary |
|---|---|
| Funnel kya hai? | Total→Purchase→Deal-use→Campaign-accept, all 2-year consistent fields. |
| Sabse bada drop-off? | Deal-use→Campaign-accept, 72.1%. |
| Koi galti pakड़ी? | Haan — original visit-vs-purchase funnel invalid tha (time-window mismatch), khud pakड़ke fix kiya. |

## I. Campaign Analysis

| Question | Answer Summary |
|---|---|
| Best/worst campaign? | Cmp6 (15.05%) / Cmp2 (1.36%). |
| Raw count se compare kiya? | Nahi — rate (%) primary metric, raw count misleading ho sakta hai. |

## J. Customer Segmentation

| Question | Answer Summary |
|---|---|
| Segmentation method? | RFM quartile scoring, 4 segments, no ML. |
| Champions ka profile? | 24.1% customers, 49.1% revenue, 15.14% acceptance. |
| ML kyun nahi? | Rule-based/explainable segmentation data ki simplicity ke liye kaafi thi; ML unnecessary complexity add karta bina genuine need ke. |

## K. Power BI

| Question | Answer Summary |
|---|---|
| Dashboard dikhao? | "Abhi physically nahi bana — poora build-spec ready hai (5 pages, saare DAX measures), honestly batana zaroori hai." |

## L. Statistics

| Question | Answer Summary |
|---|---|
| Hypothesis testing use ki? | Nahi — poori population hai, sample-inference ki zaroorat nahi. |
| Skew kaise check kiya? | Mean vs median gap — total_spend 607 vs 397, strongly right-skewed. |

## M. Business Questions

| Question | Answer Summary |
|---|---|
| Sabse bada business insight? | Champions concentration (24.1%→49.1% revenue). |
| Company ko kya action leni chahiye? | Segment-specific targeting — poore list ko contact karna band karke high-probability segments prioritize karna (hedged as "consider/investigate"). |

## N. Recommendations

| Question | Answer Summary |
|---|---|
| Sabse confident recommendation? | R3 — recently-active customers ko priority do (clean, monotonic pattern). |
| Sabse kam confident? | R5 — Catalog investigate karo (pattern real hai, cause unknown). |

## O. Limitations

| Question | Answer Summary |
|---|---|
| Sabse badi limitation? | Single company/time-period, no real campaign-cost data, no experiments run — sab association hai, causation nahi. |

## P. Difficult Follow-Ups

| Question | Strong Answer Direction |
|---|---|
| "Ye sirf ek portfolio project hai, koi real business impact nahi hua na?" | "Sahi hai — ye ek learning/demonstration project hai ek real dataset pe. Lekin har technique (SQL joins, RFM, funnel, hedged recommendations) genuinely transferable hai kisi bhi real company ke liye." |
| "Agar main aapke RFM thresholds change kar dun, segments bhi change ho jayenge na?" | "Haan — quartile-based hai, isliye data-relative hai. Ye ek feature hai, bug nahi — jaise data grow/shift karega, thresholds automatically adapt karenge agar script re-run ho." |
| "Aapne khud se dataset clean kiya — kaise pata ki sahi kiya?" | "Har decision explicit reasoning ke saath documented hai (WHAT/WHY/HOW/WHY-this-approach) — koi bhi decision blind nahi thi, aur main har ek ko defend kar sakta hoon [10_DATA_CLEANING.md](10_DATA_CLEANING.md) se." |
| "Power BI dashboard bina banaye hi project 'complete' keh sakte ho?" | "Main 'complete' nahi, specific status bataunga — core analysis (SQL/Python/segmentation/funnel/insights) complete hai, Power BI presentation layer ek ready-to-execute spec hai." |

## What I Should Remember

1. Every category here has at least 2-3 ready answers with a Hinglish + technical version.
2. For "difficult follow-ups," honesty ("yahan limitation hai") always beats a defensive/evasive answer.
3. Full depth on any single topic lives in its dedicated chapter — this file is the quick-recall index.

---
*Next: [25_DA_INTERVIEW_PREP.md](25_DA_INTERVIEW_PREP.md)*
