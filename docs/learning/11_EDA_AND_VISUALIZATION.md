# 11 — EDA and Visualization

🔴 MUST KNOW

Full pandas-function-level walkthrough: [docs/07_python_eda_learning.md](../07_python_eda_learning.md). This file focuses on **chart selection reasoning** — why each chart type, what to look for, what business question it answers.

## 1. What Is EDA? Why Do Analysts Do It?

### GENERAL CONCEPT

**Kya hai:** Exploratory Data Analysis (EDA) = data ko **charts aur summary stats ke through explore karna**, bina ek fixed hypothesis ke, taaki patterns/relationships/anomalies khud nazar aa jaayen.

**Kyun karte hain:** SQL/aggregation precise numbers deta hai, lekin **shape/distribution/relationship** dikhane mein charts zyada effective hain. "Kya spend normal hai ya kuch log bahut zyada spend karte hain" — ye histogram se turant pata chalta hai.

### Univariate vs. Bivariate Analysis

| Type | Meaning | Example in project |
|---|---|---|
| **Univariate** | Ek waqt mein sirf ek variable dekhna | Income ka histogram |
| **Bivariate** | Do variables ka relationship dekhna | Income vs. Total Spend scatter |
| **Trend analysis** | Time ke saath change dekhna | ❌ Not applicable here — no campaign dates exist in this dataset |
| **Distribution** | Data kaise spread hua hai (shape) | Total spend ka right-skew |
| **Relationship analysis** | Do/zyada variables kaise saath move karte hain | Correlation heatmap |

## 2. Chart-Type Deep Dive

### Histogram

- **When to use:** Ek numeric column ki shape/spread/center dekhni ho.
- **When NOT to use:** Categorical data ke liye (no natural bins/order).
- **What question it answers:** "Is data symmetric, skewed, or does it have a clear peak?"
- **Used for:** `income`, `age`, `total_spend`, `recency`, `total_purchases`, `num_campaigns_accepted`.

### Bar Chart / Count Plot

- **When to use:** Categories compare karni ho (counts, ya ek computed value jaise rate/%).
- **When NOT to use:** Rarely wrong, but with too many categories (15+) it gets cluttered — consider a table instead.
- **What question it answers:** "Which category has the highest/lowest value?"
- **Used for:** Education/Marital/Segment counts, campaign acceptance rate, channel share.

### Pie / Donut Chart

- **When to use:** Small number (~2-6) of categories, showing **share of a whole (%)**.
- **When NOT to use:** Many categories (slices become too thin to compare) — this is a very common interview "spot the mistake" question.
- **What question it answers:** "What % of the total does each group represent?"
- **Used for:** Segment revenue share (4 segments — small enough to work well).

### Scatter Plot

- **When to use:** Relationship between TWO numeric variables, optionally colored by a 3rd categorical variable.
- **When NOT to use:** When one variable is categorical (use box plot instead).
- **What question it answers:** "As X increases, what happens to Y? Do groups separate visually?"
- **Used for:** `income` vs. `total_spend`, colored by `segment` — visually confirms segments cluster by income/spend as expected.

### Correlation Heatmap

- **When to use:** Many numeric variable **pairs** need to be compared for relationship strength at once.
- **When NOT to use:** As a substitute for actually looking at the scatter plot shape — correlation only captures *linear* relationships, can miss curves/patterns.
- **What question it answers:** "Which variables move together, and how strongly?"
- **Used for:** `income`, `age`, `recency`, `total_spend`, `total_purchases`, `num_web_visits_month`, `num_campaigns_accepted` — 7×7 matrix.

### Box Plot

- **When to use:** Comparing the **spread and outliers** of a numeric variable across multiple groups.
- **When NOT to use:** When you only care about a single summary number (mean) — box plots are for spread, not point-estimates.
- **What question it answers:** "Which group is more consistent vs. more spread out? Are there outliers?"
- **Used for:** `total_spend` by `segment` — Champions/Loyal have a wide, high box (variable, high spend); At Risk/Lost are tightly clustered near zero.

### Funnel Bar Chart

- **When to use:** Sequential stages where each stage is a subset of the previous one.
- **What question it answers:** "Where's the biggest drop-off?"
- **Used for:** Total → Purchase → Deal-use → Campaign-accept.

## 3. Chart-by-Chart Walkthrough (real notebook output)

| Chart | Variables | What Pattern to Look For | What It Shows (real) | Business Question Answered |
|---|---|---|---|---|
| Numeric histograms (×6) | income, age, total_spend, recency, total_purchases, num_campaigns_accepted | Mean vs. median gap = skew | `total_spend` and `num_campaigns_accepted` are heavily right-skewed; `recency` is roughly uniform | "Is our customer base homogeneous or does a small group dominate?" → Small group dominates spend |
| Categorical count plots (×3) | education, marital_status, segment | Which category is largest | Graduation (50.4%), Married (38.7%), Loyal Customers (38.4%) are the largest groups | "What does our customer base look like demographically?" |
| Campaign acceptance bar | campaign_name, acceptance_rate | Tallest vs. shortest bar | Cmp6 (15.05%) vs. Cmp2 (1.36%) — 11x gap | "Which campaign should we learn from / avoid repeating?" |
| Channel share bar | channel, share_pct | Relative bar heights | Store 46.2% > Web 32.5% > Catalog 21.3% | "Which channel deserves more investment?" |
| Segment spend/revenue/acceptance (×3) | segment × total_spend / revenue share / acceptance | Concentration in one segment | Champions = 24.1% of customers but 49.1% of revenue, 15.14% acceptance | "Which customers matter most?" |
| Correlation heatmap | 7 numeric fields | Dark red/blue cells = strong relationship | income↔total_spend = +0.79; income↔num_web_visits_month = **-0.65** | "What drives spend? Does income relate to browsing behavior?" |
| Scatter (income vs. spend, by segment) | income, total_spend, segment | Do colors cluster separately? | Champions/Loyal cluster upper-right (high income+spend); At Risk/Lost cluster lower-left | Visually validates the RFM segmentation makes behavioral sense |
| Funnel bar | 4 stages | Where's the tallest drop | 99.7% → 98.0% → **27.3%** — biggest drop between deal-use and campaign-accept | "Where should we focus improvement efforts?" |
| Boxplot (spend by segment) | segment, total_spend | Box height/position, outlier dots | Champions/Loyal: wide, high boxes; At Risk/Lost: tight, near-zero | "How consistent is spend within each segment?" |

## 4. INTERVIEW

**Q: "Aapne pie chart sirf segment-revenue-share ke liye kyun use kiya, baaki jagah nahi?"**
> "Pie chart tabhi effective hai jab categories kam (2-6) ho — humare 4 segments ke liye sahi tha. Education (5) ya campaigns (6) ke liye bhi theoretically use kar sakte the, lekin bar chart wahan zyada precise comparison deta hai — pie mein close-value slices compare karna mushkil hota hai."

**Q: "Correlation heatmap se aapko kya pata chala jo GROUP BY se nahi chal sakta tha?"**
> "GROUP BY categories ke against summarize karta hai. Heatmap ek saath **saari numeric-pair relationships** dikhata hai — jaise humein pata chala `income` aur `num_web_visits_month` ka -0.65 correlation hai, jo humne pehle SQL mein income-band-wise dekha tha, ab ek single number se confirm ho gaya."

**Q: "Boxplot se aapko average se extra kya mila?"**
> "Spread aur outliers. Champions ka average spend high hai, but boxplot ye bhi dikhata hai ki unka spend bahut **variable** hai (kuch bahut zyada, kuch kam) — jabki Lost segment ka spend consistently low hai. Ye nuance sirf average se nahi milta."

## 5. Common Mistakes

- Pie chart 8+ categories ke saath use karna — bar chart better hota.
- Sirf mean dekhna, distribution shape (histogram) ignore kar dena — misses skew.
- Correlation ko causation samajh lena — sirf association dikhata hai.
- Scatter plot mein color/legend na daalna jab groups compare karne ho.

## 6. What I Should Remember

1. Har chart type ka apna specific use-case hai — "koi bhi chart chal jaayega" wali soch galat hai.
2. Har chart is project mein ek specific business question answer karta hai — sirf "pretty visualization" nahi.
3. Real numbers har chart ke peeche hain, kuch bhi hardcoded/assumed nahi — `notebooks/01_marketing_eda.ipynb` re-run karke khud verify kiya ja sakta hai.

---
*Next: [12_MARKETING_METRICS_FROM_ZERO.md](12_MARKETING_METRICS_FROM_ZERO.md)*
