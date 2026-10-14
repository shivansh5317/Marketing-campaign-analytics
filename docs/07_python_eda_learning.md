# 07 — Python / Pandas EDA Learning Notes

Is phase mein humne `notebooks/01_marketing_eda.ipynb` banaya aur **actually run** kiya — har number aur chart is document mein wahi hai jo notebook ne genuinely produce kiya (kuch bhi hand-typed/guessed nahi hai). Ye document us notebook ke har concept, function, aur chart ko Hinglish mein samjhata hai.

**Reproduce karne ke liye:** `notebooks/01_marketing_eda.ipynb` VS Code mein kholo, "Run All" karo (Python kernel jisme pandas/matplotlib/seaborn installed hain).

---

## 1. EDA Kya Hai, Aur Iska Iss Project Mein Role

**Kya hai:** EDA (Exploratory Data Analysis) matlab data ko **charts aur summary statistics ke through explore karna**, bina kisi fixed hypothesis ke — taaki patterns, distributions, relationships, aur anomalies khud data se nazar aa jaayen.

**Kyun zaroori hai:** SQL (Phase 4) humein **precise aggregated numbers** deta hai ("Cmp6 ka acceptance rate 15.05% hai"). Lekin SQL se hume **shape/distribution** ka easily pata nahi chalta — jaise "kya spend normal-distributed hai ya kuch log bahut zyada spend karte hain?" Ye sawaal histogram se turant answer ho jaata hai, SQL query se nahi (bina bahut saari bucket queries likhe).

**Iss project mein use:** Phase 3 (KPIs), Phase 4 (SQL), Phase 5 (segmentation), aur Phase 6 (funnel) ke saare numeric findings ko humne yahan **visually verify aur re-confirm** kiya hai — jaise "Champions segment sabse zyada revenue deta hai" (Phase 5 ka table) ab ek pie chart mein bhi dikh raha hai, same real numbers ke saath.

**Common mistake:** EDA ko sirf "pretty charts banana" samajh lena. Asli purpose hai **decisions aur further analysis directions** nikalna — jaise humne correlation heatmap se dekha `income` aur `num_web_visits_month` ka correlation **-0.65** hai, jo directly Phase 4 ke SQL finding ("kam income wale zyada visit karte hain lekin kam kharidte hain") ko numerically confirm karta hai.

---

## 2. Tools Kyun Chose Kiye (Python Ecosystem)

| Tool | Role | Kyun |
|---|---|---|
| **pandas** | Data load karna, filter/group/merge karna, summary stats | Table-shaped (rows x columns) data ke liye industry-standard Python library |
| **matplotlib** | Low-level charting engine | Har aur koi Python charting library (seaborn included) isi ke upar bani hai; full control deta hai |
| **seaborn** | High-level, prettier statistical charts | `countplot`, `heatmap`, `boxplot` jaise charts ek line mein ban jaate hain, matplotlib se kaafi kam code |
| **Jupyter Notebook** | Interactive environment jaha code + output + chart + explanation ek saath dikhe | Data Analysts ka standard EDA environment — har cell ka result turant dikhta hai |

**Interview Q:** *"Matplotlib aur Seaborn dono kyun use kiye, ek hi kaafi nahi tha?"* → Seaborn matplotlib ke upar hi bana hai (wrapper) — statistical charts (jaise `countplot`, `heatmap`) ke liye seaborn kam code mein achha-dikhne-wala output deta hai, lekin fine control (jaise multiple subplots ka layout, text annotations) ke liye humne matplotlib (`plt.subplots`, `ax.text`) direct use kiya. Dono saath use karna normal industry practice hai.

---

## 3. Notebook Walkthrough — Section by Section

### 3.1 Setup & Imports (existing cell)

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_style("whitegrid")
plt.rcParams["figure.figsize"] = (8, 4.5)
pd.set_option("display.max_columns", 40)
```

- **What it does:** Loads the 4 libraries; sets a consistent chart style/size for the whole notebook; tells pandas to show up to 40 columns when printing a DataFrame (hamare `dim_customers` mein 29 columns hain, default pandas sirf ~20 dikhata hai aur baaki `...` se chhupa deta — humne isse disable kiya).
- **Interview Q:** *"`plt.rcParams` kya karta hai?"* → Matplotlib ki global default settings change karta hai (jaise figure size), taaki har chart mein baar-baar `figsize=...` na likhna pade.

### 3.2 Load & First Look

```python
dim_customers = pd.read_csv("../data/processed/dim_customers.csv")
fact_campaign = pd.read_csv("../data/processed/fact_campaign_response.csv")
fact_channel = pd.read_csv("../data/processed/fact_channel_purchases.csv")
```

**Real output:**
```
dim_customers: (2212, 29)
fact_campaign_response: (13272, 3)
fact_channel_purchases: (6636, 3)
```

Ye Phase 2 ke exact numbers hain — confirm karta hai ki humara EDA sahi, latest cleaned data pe chal raha hai. Phir `dim_customers.head()`, `.info()`, aur `.describe()` se hum data ka structure aur summary stats dekhte hain (concepts + real output Section 4 mein cover honge, Pandas Glossary section mein).

### 3.3 Univariate Numeric — Histograms

**Concept: Univariate analysis** = ek waqt mein **sirf ek variable** ko dekhna (uski shape/spread/center), koi doosra variable involve nahi. Histogram is ke liye standard chart hai — x-axis pe value ranges (bins), y-axis pe "kitne customers us range mein aate hain."

Humne 6 columns ke histograms banaye: `income`, `age`, `total_spend`, `recency`, `total_purchases`, `num_campaigns_accepted` — har ek pe mean (red dashed line) aur median (green dashed line) overlay kiya.

**Real, verified pattern (mean vs median gap = skew indicator):**

| Column | Mean | Median | Shape |
|---|---|---|---|
| `income` | 51,958.8 | 51,371.0 | Roughly symmetric, mild right tail |
| `age` | 45.1 | 44.0 | Roughly symmetric/multi-modal |
| `total_spend` | 607.3 | 397.0 | **Strongly right-skewed** (mean pulled up by a small group of big spenders) |
| `recency` | 49.0 | 49.0 | Roughly uniform (flat) — makes sense, it's basically evenly spread 0–99 |
| `total_purchases` | 12.6 | 12.0 | Mildly right-skewed |
| `num_campaigns_accepted` | 0.4 | 0.0 | **Heavily right-skewed** (most customers = 0, few responders pull mean up) |

**Why this matters (project + interview):** Jab mean aur median mein bada gap ho, iska matlab data **skewed** hai — koi ek metric (jaise sirf mean) akela report karna misleading hoga. `total_spend` ka mean (607) median (397) se 53% zyada hai — isiliye Phase 3 KPI doc mein humne dono report kiye the, sirf mean nahi. Ye poori tarah statistics se connected hai — full formula/explanation Phase 8 mein.

**Interview Q:** *"Histogram se aap kaise pata karoge ki data skewed hai ya normal?"* → Agar mean aur median close hain aur histogram symmetric/bell-shaped dikhta hai → roughly normal. Agar mean median se kaafi zyada hai aur histogram ka ek lamba tail right side pe hai → right-skewed (jaise humara `total_spend`).

### 3.4 Univariate Categorical — Bar Charts

**Concept:** Categorical column ke liye histogram nahi, **bar chart / count plot** use hota hai — har category ka count.

Real counts (seaborn `countplot`, verified):

| Education | Count | | Marital Status | Count | | Segment | Count |
|---|---|---|---|---|---|---|---|
| Graduation | 1,115 | | Married | 857 | | Loyal Customers | 849 |
| PhD | 480 | | Together | 571 | | At Risk | 560 |
| Master | 365 | | Single | 473 | | Champions | 534 |
| 2n Cycle | 198 | | Divorced | 231 | | Lost/Hibernating | 269 |
| Basic | 54 | | Widow | 76 | | | |
| | | | Other | 4 | | | |

**Interview Q:** *"Categorical data ke liye histogram kyun use nahi karte?"* → Histogram numeric ranges (bins) maanta hai jinke beech ordering/continuity ho; categories (jaise "Married", "Single") ke beech koi natural numeric order nahi hota, isliye bar chart (ek bar per discrete category) sahi chart hai.

### 3.5 Campaign & Channel Performance — GroupBy + Bar Charts

```python
campaign_summary = (
    fact_campaign.groupby("campaign_name")["accepted"]
    .agg(customers_accepted="sum", customers_targeted="count")
    .assign(acceptance_rate_pct=lambda d: (100 * d["customers_accepted"] / d["customers_targeted"]).round(2))
    .sort_values("acceptance_rate_pct", ascending=False)
)
```

- **`groupby("campaign_name")`**: rows ko campaign ke hisaab se 6 buckets mein split karta hai (bilkul SQL ke `GROUP BY` jaisa).
- **`.agg(...)`**: ek saath multiple named aggregations — `sum` (accept count) aur `count` (total rows = targeted). Named aggregation (`customers_accepted="sum"`) se result columns ka naam clean rehta hai.
- **`.assign(...)`**: ek **naya calculated column** add karta hai (yahan acceptance rate %) without mutating in a separate step — chaining ke liye zaroori.
- **`.sort_values(...)`**: SQL ke `ORDER BY` jaisa.

**Real output (matches SQL Phase 4 exactly — good cross-check):** Cmp6 = 15.05% (best), Cmp2 = 1.36% (worst); Store = 46.2% > Web = 32.5% > Catalog = 21.3% channel share.

**Interview Q:** *"Pandas ka `groupby` aur SQL ka `GROUP BY` conceptually same hain?"* → Haan bilkul — dono "split rows into groups by a key, then aggregate within each group" hi karte hain. Pandas mein aggregation ke baad Python mein aur processing continue kar sakte ho (charts, further merge), SQL mein result seedha table/result-set hota hai.

### 3.6 Segmentation Deep Dive — Merge + GroupBy + Pie Chart

```python
merged = fact_campaign.merge(dim_customers[["customer_id", "segment", "total_spend"]], on="customer_id")
```

- **Concept: `merge`** = pandas ka JOIN. `fact_campaign` (13,272 rows, no segment info) ko `dim_customers` ke `segment` column ke saath jodta hai `customer_id` (shared key) ke through — bilkul SQL `JOIN ... ON` jaisa. Result mein 13,272 rows hi rehti hain (each campaign-response row ab apna segment bhi jaanta hai) — ye ek **many-to-one merge** hai (many fact rows → one matching dim row each).
- Phir `merged.groupby("segment")["accepted"].mean() * 100` se har segment ka acceptance rate nikala — `mean()` of 0/1 values = proportion (fraction), `*100` se percentage.

**Real output (matches Phase 5 exactly):**

| Segment | Avg Spend | Revenue Share | Acceptance Rate |
|---|---|---|---|
| Champions | 1,234 | 49.1% | 15.14% |
| Loyal Customers | 718 | 45.4% | 7.64% |
| At Risk | 113 | 4.7% | 2.86% |
| Lost/Hibernating | 43 | 0.9% | 1.43% |

**Interview Q:** *"`merge` mein `on="customer_id"` na likha hota toh kya hota?"* → Pandas apne aap dono tables ke **common-named columns** pe merge karne ki koshish karta — agar sirf `customer_id` hi common ho toh same result aata, lekin explicit `on=` likhna hamesha safer/clearer hai (especially jab multiple common columns ho sakte hain).

### 3.7 Bivariate Analysis — Correlation Heatmap & Scatter

**Concept: Bivariate analysis** = **do variables ka relationship** dekhna ek saath (univariate se agla step).

**Correlation heatmap** (`dim_customers[corr_cols].corr()`): har pair of numeric columns ke beech **Pearson correlation coefficient** (-1 to +1) calculate karta hai, `seaborn.heatmap` se color-coded grid mein dikhata hai. (Full correlation formula/interpretation Phase 8 mein.)

**Real, important correlations found:**

| Pair | Correlation | Meaning |
|---|---|---|
| `income` ↔ `total_spend` | **+0.79** | Strong positive — zyada income wale zyada spend karte hain (expected, but now confirmed numerically) |
| `income` ↔ `num_web_visits_month` | **-0.65** | Strong negative — ye Phase 4 SQL ke "income band vs web visits" finding ko confirm karta hai: **kam income wale zyada baar website visit karte hain, lekin kam khareedte hain** |
| `total_spend` ↔ `total_purchases` | +0.82 | Expected — zyada purchases = zyada total spend |
| `recency` ↔ `num_campaigns_accepted` | **-0.09** | Bahut weak, though direction sahi hai (kam recency = thoda zyada acceptance) |

**Scatter plot** (`income` vs `total_spend`, colored by segment): har point ek customer hai; color se dikhta hai wo kis RFM segment mein hai. Pattern: **Champions (blue) aur Loyal (green) upar-right mein cluster karte hain** (high income + high spend), jabki **At Risk (red) aur Lost (purple) bottom-left mein** (low income ya low spend) — visually confirms ki RFM segmentation genuinely income/spend ke sath align karta hai.

**Important nuance (interview-relevant):** `recency` aur `num_campaigns_accepted` ka raw correlation sirf -0.09 hai (weak), lekin Phase 4 SQL mein humne recency-bands (0-24, 25-49, 50-74, 75-99 days) ke against acceptance rate dekha tha aur ek **clean monotonic pattern** mila tha (9.52% → 7.55% → 6.88% → 5.93%). Ye contradiction nahi hai — dono sahi hain, bas **different techniques different cheez dikhate hain**: raw correlation ek noisy 0/1 individual-level variable pe weak dikh sakta hai, jabki **grouped averages (banding)** noise ko smooth kar deta hai aur underlying pattern clearer ban jaata hai.

**Interview Q:** *"Correlation coefficient bahut weak (-0.09) hai lekin banded analysis mein clear pattern dikha — konsa sahi hai?"* → Dono sahi hain, different lenses hain. Individual-level binary/rare-event variables (jaise "accepted or not," jaha zyadatar log 0 hain) pe linear correlation naturally weak dikh sakta hai chahe ek genuine directional trend maujood ho — isiliye hum sirf ek technique pe depend nahi karte, multiple angles se check karte hain.

### 3.8 Funnel Chart & Boxplot

**Funnel bar chart:** 4 stages (Total → Purchase → Deal → Campaign) ko horizontal bars se dikhaya, `docs/06_funnel_analysis.md` ke numbers ko live compute karke (hardcode nahi kiya) — 2212 → 2206 (99.7%) → 2168 (98.0%) → 604 (27.3%). Ye "stage-to-stage retention %" (previous stage ke against, na ki total ke against) bhi print kiya: 99.7% → 98.3% → 27.9% — **note:** ye thoda alag numbers hain Phase 6 ke "% of total" column se, kyunki ye "% of PREVIOUS stage" hai, not "% of Stage 1" — dono valid metrics hain, bas alag denominator.

**Boxplot** (`total_spend` by segment): Ek boxplot **5 numbers** dikhata hai — minimum, 25th percentile (Q1, box ka bottom), median (box ke andar line), 75th percentile (Q3, box ka top), maximum — plus individual dots for outliers beyond a calculated range. Real pattern: Champions/Loyal Customers ka box bahut **wide aur high** hai (spend 0 se 2500 tak spread, kuch outliers upar), jabki At Risk/Lost ka box **chhota aur zero ke paas compressed** hai — ye **spread/variance** ka visual hai, sirf average ka nahi.

**Interview Q:** *"Boxplot se aapko average/mean se extra kya pata chalta hai?"* → Boxplot **spread aur outliers** dikhata hai jo akela mean/median nahi dikha sakte — do segments ka same average ho sakta hai lekin ek ka spread bahut zyada (inconsistent) aur doosre ka bahut kam (consistent) ho sakta hai.

---

## 4. Pandas Function Glossary (used in this notebook)

| Function | What it does | Project usage |
|---|---|---|
| `pd.read_csv()` | CSV file ko DataFrame mein load karta hai | Loading all 3 processed tables |
| `.shape` | (rows, columns) tuple | Verifying 2212×29, 13272×3, 6636×3 |
| `.head()` | First N rows dikhata hai (default 5) | Quick visual sanity check of columns/values |
| `.info()` | Column names, dtypes, non-null counts, memory | Confirmed 0 missing values remain, all dtypes as expected |
| `.describe()` | count/mean/std/min/25%/50%/75%/max for numeric columns | Getting quartiles (used again in Phase 8 stats teaching) |
| `.value_counts()` | Kis category ki kitni rows hain | Education/Marital Status/Segment counts |
| `.groupby(col)` | Rows ko `col` ki value ke hisaab se buckets mein split karta hai | Campaign/channel/segment aggregation |
| `.agg(name=("col","func"))` | Named aggregation — ek saath multiple summary stats | `customers_accepted`, `customers_targeted` in one call |
| `.assign(new_col=lambda d: ...)` | Chain mein ek naya column add karta hai | Calculating `acceptance_rate_pct` inline |
| `.merge(df2, on="key")` | pandas ka JOIN | Attaching `segment` onto `fact_campaign` rows |
| `.corr()` | Har numeric-column-pair ke beech correlation matrix | Correlation heatmap |
| `.mean()`, `.sum()`, `.median()` | Basic aggregate stats | Used throughout |

---

## 5. Chart-Type Cheat Sheet (when to use which)

| Chart | Use when... | Used for in this project |
|---|---|---|
| Histogram | Ek numeric column ki distribution/shape dekhni ho | income, age, total_spend, recency, total_purchases, num_campaigns_accepted |
| Bar chart / countplot | Categories ke counts ya ek computed value compare karne ho | Education/Marital/Segment counts, campaign acceptance rate, channel share |
| Pie chart | Total ka **% breakdown** ek chhoti (~2-6 category) list ke liye dikhana ho | Segment revenue share |
| Scatter plot | Do numeric variables ka relationship (aur ek teesra category color se) dekhna ho | Income vs. Total Spend, by segment |
| Heatmap | Bahut saari variable-pairs ka correlation ek saath dikhana ho | Numeric correlation matrix |
| Boxplot | Ek numeric column ka spread + outliers, multiple groups ke across compare karna ho | Total spend by segment |

**Common mistake (interview-relevant):** Pie chart ko bahut zyada categories (8+) ke saath use karna — tab slices itni chhoti/close ho jaati hain ki compare karna mushkil ho jaata hai; bar chart usually better hota hai jab categories zyada ho. Humne pie chart sirf 4-segment revenue-share ke liye use kiya, jaha categories kam hain.

---

## 6. What This Notebook Does NOT Do (honesty check)

- Koi machine learning / clustering / predictive model nahi hai — sirf descriptive EDA (jo hua wo dikhana), koi "future prediction" nahi.
- Koi statistical hypothesis test (t-test, chi-square, p-value) nahi kiya — ye is project ke liye genuinely zaroori nahi tha (Phase 8 mein iska general concept teach hoga interview ke liye, but "used in project" wala label nahi lagega).
- Correlation ko causation ki tarah kahin present nahi kiya — har jagah "association/pattern" bola gaya hai.

---

## 7. Summary / What's Next

- Notebook `notebooks/01_marketing_eda.ipynb` mein 8 sections hain: Load & First Look, Univariate Numeric, Univariate Categorical, Campaign/Channel Performance, Segmentation Deep Dive, Correlation + Scatter, Funnel + Boxplot, Key Takeaways — sab kuch actually executed, koi hardcoded number nahi.
- Har pandas function aur chart type ka WHAT/WHY/Project-usage cover ho chuka hai.
- Naya, is phase mein pehli baar quantify hua insight: `income` aur `num_web_visits_month` ka -0.65 correlation — pichli SQL finding ko statistically strengthen karta hai.

*Next: Phase 8 — `docs/08_statistics_learning.md` (mean/median/mode/variance/std dev/percentile/correlation/distribution — sab formulas ke saath, isi notebook ke real numbers use karke).*
