# 08 — Statistics Learning Notes

Ye document practical statistics concepts sikhata hai — sirf wahi jo humare project mein genuinely use hue (ya jo samajhna zaroori hai apne hi numbers ko sahi interpret karne ke liye). Har concept ke real values Phase 1/3/7 ke actual computed output se liye gaye hain — kuch bhi naya invent nahi kiya gaya.

---

## 1. Population vs. Sample (pehle ye clear karna zaroori hai)

**Kya hai:**
- **Population** = poora group jiske baare mein hum jaanna chahte hain.
- **Sample** = population ka ek chhota, usually random, subset — jab poori population ka data collect karna possible/practical na ho.

**Humare dataset mein kaunsa hai?** Humare 2,212 customers company ke **poore tracked customer database** hain (jo bhi contacted/tracked kiya gaya), na ki us database ka ek random sample. Isliye jab hum kehte hain "average spend = 607.3," ye **exact population statistic** hai is business ke liye — koi estimate/guess nahi, koi margin-of-error wala number nahi.

**Kyun ye important hai:** Ye exactly wajah hai ki humein **hypothesis testing, p-values, confidence intervals** jaise "sample se population inference karne wale" tools is project mein use nahi karne pade — hamare paas already poori relevant population hai, hume kisi unseen larger group ke baare mein guess/infer nahi karna. (In concepts ka general beginner-DA-interview coverage `docs/learning/29_STATISTICS_INTERVIEW_PREP.md` mein milega — is document ka focus sirf **descriptive statistics** hai jo project mein actually use hui.)

**Interview Q:** *"Kya aapke numbers 'statistically significant' hain?"* → Ye question technically tabhi apply hota hai jab hum ek **sample** se poori population ke baare mein infer kar rahe hon. Humare paas already poori tracked population hai, isliye "significance testing" ki zaroorat nahi — humare numbers seedhe, exact, observed facts hain is customer base ke liye.

---

## 2. Measures of Central Tendency (Mean, Median, Mode)

### 2.1 Mean (Average)

**Formula:** $\bar{x} = \dfrac{\sum x_i}{n}$ — sab values jodo, count se divide karo.

**Real values (from Phase 7 `describe()`):**

| Column | Mean |
|---|---|
| `income` | 51,958.8 |
| `total_spend` | 607.3 |
| `age` | 45.1 |
| `recency` | 49.0 |

**Weakness:** Mean **extreme values se easily affect** hota hai. Isiliye hamesha median ke saath compare karna chahiye.

### 2.2 Median (Middle Value)

**Kya hai:** Sab values ko sort karke **beech wali value** (ya beech ki 2 values ka average, agar even count ho).

**Real values:** `income` median = 51,371.0 · `total_spend` median = 397.0 · `age` median = 44.0 · `recency` median = 49.0.

**Kyun important:** Median **outliers se resistant (robust)** hota hai. `total_spend` ka mean (607.3) median (397) se **53% zyada** hai — iska matlab kuch high-spenders mean ko upar khींच rahe hain, jabki "typical"/majority customer sirf ~397 spend karta hai.

**MEAN vs MEDIAN — Kab konsa report karo?**

| Situation | Better metric | Kyun |
|---|---|---|
| Data roughly symmetric (jaise `recency`, `age`) | Mean ya Median, dono theek | Skew minimal hai, dono similar |
| Data skewed / outliers hain (jaise `total_spend`, `income` mildly) | **Median** (ya dono report karo) | Mean misleading ho sakta hai |

**Real project decision:** Phase 3 KPI doc mein humne `total_spend` ke liye explicitly **dono** report kiye (mean 607.27 AND median 397) — exactly is wajah se.

### 2.3 Mode (Most Frequent Value)

**Kya hai:** Wo value jo **sabse zyada baar** aati hai.

**Real values (categorical — from Phase 7 `value_counts()`):**
- `education` mode = **Graduation** (1,115 customers, 50.4%)
- `marital_status` mode = **Married** (857 customers)
- `segment` mode = **Loyal Customers** (849 customers)

**Real value (numeric):** `num_campaigns_accepted` mode = **0** (median bhi 0 hai — matlab "kabhi accept nahi kiya" hi sabse common outcome hai, matches our 72.7% never-responders finding).

**Interview Q:** *"Mode kab useful hota hai jab mean/median na ho sake?"* → Categorical data ke liye — "Education" ka koi mean/median nahi ban sakta (text hai), lekin mode ("sabse common category kaunsi hai") hamesha calculate ho sakta hai.

---

## 3. Measures of Spread (Range, Variance, Standard Deviation)

### 3.1 Range

**Formula:** `Range = Max - Min`

| Column | Min | Max | Range |
|---|---|---|---|
| `income` | 1,730 | 162,397 | 160,667 |
| `total_spend` | 5 | 2,525 | 2,520 |
| `age` | 18 | 74 | 56 |
| `recency` | 0 | 99 | 99 |

**Weakness:** Range sirf 2 extreme points use karta hai — beech ka poora data ignore ho jaata hai. Ek single outlier poore range ko distort kar sakta hai (jaise humne Phase 2 mein Income=666,666 wala outlier drop kiya tha — agar wo reh jaata, range 160,667 ki jagah 660,667 dikhta, bahut misleading).

### 3.2 Variance & Standard Deviation

**Formula:**
$$\text{Variance} = \sigma^2 = \frac{\sum (x_i - \bar{x})^2}{n}, \qquad \text{Std Dev} = \sigma = \sqrt{\sigma^2}$$

**Kya matlab hai:** Har value ka mean se "kitna door" hai (deviation), use square karke (taaki negative/positive cancel na ho), phir average — ye **variance** hai. Variance ka square root lene se **standard deviation** milta hai, jo original units mein wapas aa jaata hai (variance ka unit "squared" hota hai, jo directly samajhna mushkil hai — isiliye std dev zyada report kiya jaata hai).

**Real values (from Phase 7 `describe()`):**

| Column | Std Dev | Mean | Interpretation |
|---|---|---|---|
| `income` | 21,527.3 | 51,958.8 | Kaafi spread — customers ki income bahut vary karti hai |
| `total_spend` | 602.5 | 607.3 | Std dev mean ke lagbhag barabar hai — **bahut high relative variability** (kuch customers ~0 spend karte hain, kuch 2,500+) |
| `age` | 11.7 | 45.1 | Moderate spread — zyadatar customers 33-57 ke aas-paas |
| `recency` | 28.9 | 49.0 | High spread relative to range (0-99) — roughly uniform distribution ka sign |

**Interview Q:** *"Standard deviation zyada hone ka business impact kya hai?"* → `total_spend` ka std dev (602.5) khud mean (607.3) ke lagbhag barabar hai — ye batata hai customer base **bahut heterogeneous** hai (kuch bahut low spend, kuch bahut high) — "ek size fits all" marketing strategy is wajah se kaam nahi karegi, **segmentation** (Phase 5) genuinely zaroori ban jaata hai, sirf "nice to have" nahi.

---

## 4. Percentile & Quartile (directly used in RFM segmentation!)

**Kya hai:**
- **Percentile** = wo value jiske **neeche data ka X%** aata hai. Jaise 75th percentile = wo value jiske neeche 75% data hai.
- **Quartile** = specifically 25%, 50%, 75% percentile points — data ko **4 barabar hisso** mein baantte hain (Q1, Q2=median, Q3, aur implicitly Q4=max).
- **IQR (Interquartile Range)** = `Q3 - Q1` — beech ke 50% data ka spread (range se zyada robust, kyunki extreme 25% dono taraf se ignore ho jaate hain).

**Real values (from `describe()`):**

| Column | Q1 (25%) | Q3 (75%) | IQR |
|---|---|---|---|
| `income` | 35,233.5 | 68,487.0 | 33,253.5 |
| `total_spend` | 69.0 | 1,048.0 | 979.0 |
| `total_purchases` | 6.0 | 18.2 | 12.2 |
| `recency` | 24.0 | 74.0 | 50.0 |

**🔗 Direct project connection — RFM Segmentation (Phase 5):** Humara pura RFM scoring system **quartiles pe based hai!** `pd.qcut(df["recency"], 4, ...)` ne `recency` ko exactly 4 quartile-groups mein split kiya (0-24 = score 4 kyunki lower recency achha hai, 25-49 = score 3, 50-74 = score 2, 75-99 = score 1). Same technique `total_purchases` (Frequency) aur `total_spend` (Monetary) pe bhi laga — ye quartile concept ka ek genuinely real, applied use-case hai, sirf textbook definition nahi.

**Interview Q:** *"Aapne customers ko groups mein baantne ke liye quartiles kyun use kiye, fixed thresholds (jaise 'income > 50000') kyun nahi?"* → Quartiles automatically **data-driven aur balanced** groups dete hain (har group mein ~25% customers) — fixed thresholds business-arbitrary ho sakte hain aur agar data ka distribution shift ho (jaise agle saal average income badh jaaye), fixed number outdated ho jaata. Quartiles hamesha current data ke against relative rehte hain.

---

## 5. Distribution Shape & Skewness

**Kya hai:** "Distribution" batata hai data **kaise spread hua hai** — kya zyadatar values center mein hain (bell-shape/"normal"), ya ek taraf zyada concentrated hain aur doosri taraf lamba tail hai (skewed)?

**Skewness ka quick check (bina formula ke):** Agar **Mean > Median**, data **right-skewed** hai (lamba tail right/high-value side pe). Agar **Mean < Median**, **left-skewed**. Agar **Mean ≈ Median**, roughly symmetric.

**Real distributions found (Phase 7 histograms):**

| Column | Mean vs Median | Shape |
|---|---|---|
| `total_spend` | 607.3 vs 397.0 | **Strongly right-skewed** — bahut se low/medium spenders, thode high spenders lamba tail banate hain |
| `num_campaigns_accepted` | 0.4 vs 0.0 | **Heavily right-skewed** — majority 0, chhota tail 1-5 tak |
| `income` | 51,958.8 vs 51,371.0 | Roughly symmetric, very mild right skew |
| `recency` | 49.0 vs 49.0 | Roughly **uniform** (flat) — koi central peak nahi, sab values equally likely |

**Business meaning of right-skew in `total_spend`:** Confirms exactly what Phase 5 segmentation found — thode "Champions" (high spend) poori distribution ko upar khींचते hain. Ye is baat ka statistical proof hai ki **"average customer" ek misleading concept hai** — segmentation ke bina hum ek non-existent "average" customer ke liye strategy banate, jo na high-spenders ko na low-spenders ko sahi se serve karta.

---

## 6. Outliers

**Kya hai:** Wo values jo baaki data se **bahut zyada door** hain.

**Do tarah ke outliers is project mein mile — inhe alag samajhna zaroori hai:**

| Type | Example | Kya kiya |
|---|---|---|
| **Data-quality error** (galat/impossible value) | `Year_Birth` = 1893/1899/1900 (age 114-121); `Income` = 666,666 (4x se zyada agla-highest) | **Removed** (Phase 2) — ye genuine customer data nahi tha, data-entry glitch tha |
| **Genuine extreme (valid, real customer)** | Top-decile spenders (1,536–2,525 range, Phase 8 SQL `NTILE`); boxplot ke "dots" upar Champions/Loyal segment mein (Phase 7) | **Kept** — ye real high-value customers hain, in-ko hataana galat hota (business ke liye ye sabse valuable log hain!) |

**Detection method used:** Simple domain-logic checks (implausible age > 90; extreme jump vs. next-highest value) — koi formal statistical rule (jaise "IQR × 1.5" method) explicitly apply nahi kiya, kyunki in cases mein manual inspection se hi clearly obvious tha ki kya galat hai.

**Interview Q:** *"Har outlier ko remove kar dena chahiye?"* → Bilkul nahi — pehle check karo ki outlier ek **data error** hai ya ek **genuine rare-but-valid case**. Humare project mein dono types mile: Year_Birth/Income-666666 error the (removed), lekin top-spending customers genuine outliers the jo hum kabhi remove nahi karenge — wo hi toh "VIP"/Champions segment ka core hain.

---

## 7. Correlation

**Kya hai:** Do numeric variables **kis had tak saath-saath badalte hain**, ek number (-1 se +1) ke roop mein.
- **+1** = perfect positive (ek badhta hai toh doosra bhi badhta hai)
- **-1** = perfect negative (ek badhta hai toh doosra ghatta hai)
- **0** = koi linear relationship nahi

**Real correlations found (Phase 7 heatmap, Pearson method — pandas `.corr()` default):**

| Pair | Correlation | Interpretation |
|---|---|---|
| `income` ↔ `total_spend` | **+0.79** | Strong positive — zyada income, zyada spend |
| `total_spend` ↔ `total_purchases` | +0.82 | Strong positive — zyada purchases, zyada total spend (expected) |
| `income` ↔ `num_web_visits_month` | **-0.65** | Strong negative — kam income wale zyada visit karte hain, kam khareedte hain |
| `num_campaigns_accepted` ↔ `total_spend` | +0.45 | Moderate positive |
| `recency` ↔ `num_campaigns_accepted` | -0.09 | Very weak (individual-level noise; grouped/banded view showed a clearer pattern — Section 3.7 of Phase 7 doc) |

**⚠️ Most important rule (repeated everywhere in this project, and worth repeating here):**

> **Correlation ≠ Causation.**

`income` aur `total_spend` ka strong +0.79 correlation ye **NAHI** prove karta ki "income badhne SE spend badhta hai" — dono simply **saath badalte hain observed data mein**. Ho sakta hai koi teesra factor (jaise age, lifestyle, family size) dono ko independently influence kar raha ho. Causation prove karne ke liye **controlled experiment/A/B test** chahiye hota, sirf observational correlation se nahi.

**Interview Q:** *"Correlation aur Causation mein farak samjhao, apne project ka example dekar."* → "`income` aur `total_spend` mein 0.79 correlation hai — matlab dono saath move karte hain hamare data mein. Lekin main ye nahi keh sakta ki 'zyada income customer ko zyada spend karne pe majboor karta hai' — reverse bhi possible hai, ya koi third factor (age, family size) dono ko drive kar raha ho. Causation ke liye humein experiment chahiye hota, jo humare paas nahi hai — hum sirf association/pattern report karte hain."

---

## 8. What We Deliberately Did NOT Use (and why)

| Concept | Used in project? | Why not |
|---|---|---|
| Hypothesis testing (t-test, chi-square) | ❌ No | Hamare paas poori population hai, sample-to-population inference ki zaroorat nahi (Section 1) |
| p-values | ❌ No | Same reason — inferential statistics ka concept hai, descriptive analysis ke liye zaroori nahi |
| Confidence intervals | ❌ No | Same reason |
| Probability distributions (Normal/Binomial formulas) | ❌ No (only informally described shape as "roughly normal" or "skewed") | Project ka scope descriptive rehta hai; formal probability modeling ki zaroorat nahi thi |

Ye sab concepts genuinely **beginner/intermediate DA interviews mein poochhe jaate hain** (general knowledge ke roop mein) — unka basic coverage `docs/learning/29_STATISTICS_INTERVIEW_PREP.md` mein milega, lekin humesha clearly label hoga ki "ye humare project mein use nahi hua," taaki galti se project-specific claim na ban jaaye.

---

## 9. Summary Table — All Stats Used, At a Glance

| Concept | Where used in project |
|---|---|
| Mean vs Median | `total_spend`/`income` skew check (Phase 3, Phase 7, Phase 8) |
| Mode | Education/Marital/Segment most-common category |
| Range | Quick min-max sanity checks (Phase 1 data understanding) |
| Variance/Std Dev | Spread of income/spend — motivates segmentation |
| Percentile/Quartile | **RFM scoring** (Phase 5) — R/F/M all quartile-based |
| Distribution shape/skew | `total_spend` right-skew → segmentation justification |
| Outliers | Phase 2 cleaning (errors removed) vs. Phase 5/7 (genuine high-spenders kept) |
| Correlation | Phase 7 heatmap — income/spend/visits relationships |

---
*Next: Phase 9 — `docs/09_business_insights.md` (synthesizing every real finding from Phases 3–7 into Observation → Evidence → Interpretation → Business Implication → Next Step format).*
