# 01 — Data Analytics From Zero

🔴 MUST KNOW

## 1. What is Data Analytics?

### GENERAL CONCEPT

**Kya hai:** Data Analytics matlab **raw data ko examine karna taaki useful conclusions nikal sakein** jo business decisions mein help karein. Simple words mein: **numbers/records ko dekhkar "so what?" ka jawab dena.**

**Kyun exist karta hai:** Companies ke paas bahut saara data hota hai (sales, customers, campaigns, website visits) — lekin data khud kuch nahi bolta. Ek Data Analyst ka kaam hai us data ko **questions ka jawab** banana: "Kaunsa product zyada bik raha hai? Kaunsa customer chhod ke ja raha hai? Kaunsi campaign kaam kar rahi hai?"

**Chota example:** Ek shop-owner ke paas 1 saal ki sales ka Excel sheet hai. Data Analytics matlab us sheet se nikalna — "Saturday ko sabse zyada sales hoti hai," "Winter mein sweater zyada bikte hain" — aur phir business ko batana "Saturday ko extra staff rakho."

### What Does a Data Analyst Actually Do?

1. Business se sawaal samajhna ("Kaunsi campaign best perform kar rahi hai?")
2. Data dhoondhna/collect karna
3. Data ko clean karna (galtiyan/missing values fix karna)
4. Data ko analyze karna (SQL, Python, Excel)
5. Result ko visualize karna (charts, dashboard)
6. Business ko **insight + recommendation** dena — sirf numbers nahi, "iska matlab kya hai aur ab kya karna chahiye"

### Business Question vs. Analytical Question

| Type | Example |
|---|---|
| **Business Question** (stakeholder poochta hai, vague/high-level) | "Hamari marketing kaam kar rahi hai kya?" |
| **Analytical Question** (analyst isse translate karta hai, specific/measurable) | "Har campaign ka acceptance rate kya hai, aur best vs. worst mein kitna gap hai?" |

**Ye translation skill hi asli Data Analyst ka core kaam hai** — vague business sawaal ko specific, data-answerable sawaal mein convert karna.

## 2. Core Vocabulary (from scratch)

| Term | Meaning | Chota Example |
|---|---|---|
| **Raw data** | Bilkul original, unprocessed data — jaisa collect hua waisa hi | Ek CSV file jo directly system se export hui, kuch bhi clean nahi kiya |
| **Structured data** | Data jo rows aur columns mein organized hai (tables) | Excel sheet, database table |
| **Dataset** | Ek complete collection of related data (usually ek table/file) | `ifood_marketing_campaign_raw.csv` |
| **Row / Record** | Ek single observation/entity | Ek customer |
| **Column / Field** | Ek attribute jo har row ke liye store hota hai | `Income`, `Age` |
| **Feature / Variable** | Column ka hi doosra naam (statistics/ML context mein zyada common) | `Income` ek "feature/variable" hai |
| **Dimension** | Wo column jiske "according to" hum group/filter karte hain | `Education`, `Campaign Name` |
| **Measure** | Wo numeric column jise hum SUM/AVG/COUNT karte hain | `Total Spend`, `Revenue` |
| **Metric** | Ek specific calculated number jo business ke liye meaningful hai | "Conversion Rate" |
| **KPI** (Key Performance Indicator) | Ek metric jo itna important hai ki business regularly track karta hai | "Campaign Acceptance Rate" |
| **Insight** | Data se nikla ek meaningful observation/pattern | "72.7% customers ne kabhi campaign accept nahi kiya" |
| **Dashboard** | Ek visual, interactive screen jisme multiple charts/KPIs ek saath dikhte hain | Power BI report |
| **Report** | Usually static summary of findings (PDF/doc/slide) | Ek monthly performance PDF |
| **Recommendation** | Insight ke base pe "ab kya karna chahiye" | "Champions segment ko loyalty offer do" |

## 3. The Data Analytics Workflow

```
Business Problem
      ↓
Data Collection
      ↓
Data Understanding
      ↓
Data Cleaning
      ↓
Data Analysis
      ↓
Visualization
      ↓
Insight
      ↓
Recommendation
```

Har stage ka apna purpose hai — agar koi stage skip kar do, aage ka kaam galat ho sakta hai (jaise bina cleaning ke analysis karna galat numbers de sakta hai).

## 4. MY PROJECT — Mapping the Workflow

| Workflow Stage | What We Actually Did | File |
|---|---|---|
| Business Problem | "Kaunsi campaigns kaam kar rahi hain, kaunse customers respond karte hain, kaunsa channel efficient hai?" | [03_PROJECT_OVERVIEW.md](03_PROJECT_OVERVIEW.md) |
| Data Collection | Real, public "Customer Personality Analysis" (iFood) dataset download kiya, khud collect nahi kiya | [04_DATASET_DEEP_DIVE.md](04_DATASET_DEEP_DIVE.md) |
| Data Understanding | Column-by-column data dictionary banaya, data types/missing-values/duplicates check kiye | [04_DATASET_DEEP_DIVE.md](04_DATASET_DEEP_DIVE.md) |
| Data Cleaning | Impossible ages, income outlier, junk categories fix kiye — `scripts/clean_data.py` | [10_DATA_CLEANING.md](10_DATA_CLEANING.md) |
| Data Analysis | SQL queries (8 files) + Python EDA notebook | [07_SQL_USED_IN_PROJECT.md](07_SQL_USED_IN_PROJECT.md), [11_EDA_AND_VISUALIZATION.md](11_EDA_AND_VISUALIZATION.md) |
| Visualization | Matplotlib/Seaborn charts in notebook; Power BI dashboard (build spec ready) | [11_EDA_AND_VISUALIZATION.md](11_EDA_AND_VISUALIZATION.md), [20_POWER_BI_IN_PROJECT.md](20_POWER_BI_IN_PROJECT.md) |
| Insight | 11 documented insights with evidence | [21_BUSINESS_INSIGHTS.md](21_BUSINESS_INSIGHTS.md) |
| Recommendation | 7 hedged, evidence-based recommendations | [22_BUSINESS_RECOMMENDATIONS.md](22_BUSINESS_RECOMMENDATIONS.md) |

## 5. INTERVIEW

**Q: "Data Analyst aur Data Scientist mein kya farak hai?"**
> Simple Hinglish answer: "Data Analyst mostly **past/present data se insights nikalta hai** — 'kya hua, kyun hua' — SQL, Excel, dashboards use karke. Data Scientist usually **future predict karta hai** ML models bana ke. Meri is project mein maine Data Analyst wala kaam kiya hai — koi prediction model nahi banaya, sirf SQL/Python se real patterns nikale aur RFM jaisa rule-based segmentation use kiya, ML clustering nahi."

**Q: "Ek Analyst ke liye sabse important skill kya hai?"**
> "Technical skill (SQL/Python) zaroori hai, lekin sabse important hai **business question ko sahi analytical question mein convert karna** — warna technically-correct answer bhi galat business sawaal ka jawab de sakta hai."

**Q: "Insight aur Recommendation mein farak batao."**
> "Insight = 'kya dikha data mein' (jaise 'Champions 49% revenue dete hain'). Recommendation = 'iske base pe kya karna chahiye' (jaise 'Champions ko retention offers do'). Insight fact hai, recommendation ek suggested action hai jo evidence pe based ho, guarantee nahi."

## 6. Common Mistakes (beginner)

- Data cleaning skip karke seedha analysis shuru karna — galat/misleading numbers aa sakte hain.
- "Insight" aur "Recommendation" ko same samajhna — insight fact hai, recommendation action-suggestion hai.
- Har metric ko individually dekhna, "so what" na poochna — number sirf tab useful hai jab wo decision mein help kare.

## 7. What I Should Remember

1. Data Analytics = raw data → decisions, ek defined workflow ke through.
2. Dimension = group/filter karne ke liye, Measure = aggregate (SUM/AVG) karne ke liye.
3. KPI ek "important enough to track regularly" metric hai.
4. Har analysis workflow business problem se shuru hokar recommendation pe khatam hona chahiye — beech mein rukna incomplete hai.

---
*Next: [02_MARKETING_ANALYTICS_FROM_ZERO.md](02_MARKETING_ANALYTICS_FROM_ZERO.md)*
