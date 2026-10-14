# 01 — Dataset Understanding

Is document mein hum apne dataset ko **line-by-line, column-by-column** samjhenge — jaise ek Data Analyst apne pehle din pe naye dataset ko samajhta hai. Saath mein kuch fundamental concepts (row, column, dimension, measure, primary key, foreign key, fact vs dimension) bhi Hinglish mein cover karenge, kyunki ye poore project mein baar baar use honge.

---

## 1. Dataset Source (recap)

- **File:** `data/raw/ifood_marketing_campaign_raw.csv`
- **Downloaded from:** original iFood Data-Analyst hiring case GitHub repo (raw CSV, no login needed)
- **Citation of record:** ["Customer Personality Analysis"](https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis), Kaggle, **CC0 Public Domain**
- Full provenance/licensing detail already documented in [00_project_blueprint.md](00_project_blueprint.md) section 3–4 — not repeating it here.

## 2. Dataset Description

Ye ek **customer-level** dataset hai — matlab **har row ek customer hai**, uske demographics, uska 2-saal ka spending behavior, aur usne kaunse marketing campaigns accept kiye, sab ek hi row mein hai. Ye "wide format" table hai (bahut saare columns, ek hi row mein sab kuch).

Company profile jo data se implied hoti hai: ek retailer jo apne **existing customers** ko products (wine, fruits, meat, fish, sweets, gold/premium items) directly bechta hai **teen channels** se — Website, Catalog, aur physical Store — aur time-to-time **email/direct offers (campaigns)** bhejta hai apne customer database ko.

## 3. Shape (Rows & Columns)

| Metric | Value |
|---|---|
| Total rows (customers) | **2,240** |
| Total columns | **29** |
| Duplicate rows | **0** |
| Duplicate `ID` values | **0** |

## 4. Full Column-by-Column Data Dictionary

### Group A — Customer Identity & Demographics ("People")

| Column | Data Type | Meaning | Example | Notes |
|---|---|---|---|---|
| `ID` | int64 | Unique customer identifier | `5524` | This is our **Primary Key** — verified 0 duplicates |
| `Year_Birth` | int64 | Customer's birth year | `1957` | ⚠️ 3 impossible values found (1893, 1899, 1900) |
| `Education` | object (text) | Education level | `Graduation`, `PhD`, `Master`, `2n Cycle`, `Basic` | Clean — only 5 valid categories, no junk |
| `Marital_Status` | object (text) | Marital status | `Single`, `Married`, `Together`, `Divorced`, `Widow` | ⚠️ Also contains `Alone`(3), `Absurd`(2), `YOLO`(2) — 7 junk rows |
| `Income` | float64 | Yearly household income (monetary units, currency unspecified) | `58138.0` | ⚠️ 24 missing (NaN); 1 extreme outlier (666,666) |
| `Kidhome` | int64 | Number of children at home | `0`, `1`, `2` | Clean |
| `Teenhome` | int64 | Number of teenagers at home | `0`, `1`, `2` | Clean |
| `Dt_Customer` | object (text, date-like) | Date customer enrolled with the company | `2012-09-04` | Stored as text — needs parsing to real date in Phase 2 |
| `Recency` | int64 | Days since customer's last purchase | `58` | Range 0–99. Clean |
| `Complain` | int64 (flag) | 1 = complained in last 2 years, 0 = did not | `0` | 21 of 2,240 complained |

### Group B — Product Spend ("Products") — real 2-year revenue

| Column | Data Type | Meaning | Min | Mean | Max |
|---|---|---|---|---|---|
| `MntWines` | int64 | $ spent on wine (2 yrs) | 0 | 303.9 | 1,493 |
| `MntFruits` | int64 | $ spent on fruits | 0 | 26.3 | 199 |
| `MntMeatProducts` | int64 | $ spent on meat | 0 | 167.0 | 1,725 |
| `MntFishProducts` | int64 | $ spent on fish | 0 | 37.5 | 259 |
| `MntSweetProducts` | int64 | $ spent on sweets | 0 | 27.1 | 263 |
| `MntGoldProds` | int64 | $ spent on premium/gold items | 0 | 44.0 | 362 |

These six columns sum to a derived `TotalSpend` (our real Revenue/Monetary measure) — min 5, median 396, mean 605.8, max 2,525. All clean, no missing values.

### Group C — Purchase Behavior / Sales Channel ("Place")

| Column | Data Type | Meaning | Min | Mean | Max |
|---|---|---|---|---|---|
| `NumDealsPurchases` | int64 | Purchases made using a discount | 0 | 2.33 | 15 |
| `NumWebPurchases` | int64 | Purchases via company website | 0 | 4.08 | 27 |
| `NumCatalogPurchases` | int64 | Purchases via catalog | 0 | 2.66 | 28 |
| `NumStorePurchases` | int64 | Purchases directly in store | 0 | 5.79 | 13 |
| `NumWebVisitsMonth` | int64 | Website visits in the **last month** (snapshot, not 2-year) | 0 | 5.32 | 20 |

⚠️ Only 6 customers have **zero** purchases across Web+Catalog+Store combined (basically inactive). Note the different time windows: `NumWebVisitsMonth` = last month only, but `NumWebPurchases` = last 2 years. We will always caveat this when treating them as a "funnel."

### Group D — Campaigns ("Promotion") — real conversion data

| Column | Data Type | Meaning | Acceptance rate (real, calculated) |
|---|---|---|---|
| `AcceptedCmp1` | int64 (flag) | Accepted campaign 1 | 6.43% |
| `AcceptedCmp2` | int64 (flag) | Accepted campaign 2 | 1.34% |
| `AcceptedCmp3` | int64 (flag) | Accepted campaign 3 | 7.28% |
| `AcceptedCmp4` | int64 (flag) | Accepted campaign 4 | 7.46% |
| `AcceptedCmp5` | int64 (flag) | Accepted campaign 5 | 7.28% |
| `Response` | int64 (flag) | Accepted the 6th/most recent campaign | 14.91% |

Real, verified distribution of **how many of the 6 campaigns each customer accepted**:

| Campaigns accepted | 0 | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|---|
| Customers | 1,631 | 370 | 142 | 51 | 36 | 10 |
| % of base | 72.8% | 16.5% | 6.3% | 2.3% | 1.6% | 0.4% |

Nobody accepted all 6. **72.8% of customers never said yes to a single campaign** — a real, important headline number we'll revisit in Business Insights (Phase 9).

### Group E — Cost/Revenue Assumption Constants

| Column | Data Type | Meaning | Value |
|---|---|---|---|
| `Z_CostContact` | int64 | Assumed cost to contact **one** customer with an offer | Constant `3` for all rows |
| `Z_Revenue` | int64 | Assumed revenue **if** that customer accepts the offer | Constant `11` for all rows |

These two are **documented constants from the original dataset**, not something we invented. They exist so we can compute campaign-level cost/revenue/ROI even though the raw file has no per-transaction financial data. Every calculation using them will be clearly labeled as "based on the dataset's assumption constants," never presented as observed fact.

## 5. Data Types Summary

In pandas terms: 24 columns are `int64` (whole numbers — counts, flags, years), 1 is `float64` (`Income` — has decimals because of the missing values), and 2 are `object`/text (`Education`, `Marital_Status`, `Dt_Customer` — `Dt_Customer` *looks* like a date but pandas reads it as plain text until we explicitly parse it in Phase 2).

## 6. Missing Values

Only **one** column has missing values:

| Column | Missing Count | % of Data |
|---|---|---|
| `Income` | 24 | 1.07% |

Every other column (all 28 others) is 100% complete. This will be handled in Phase 2 (with the WHAT/WHY/HOW/WHY reasoning the brief asked for — not done here, that's cleaning, not understanding).

## 7. Duplicate Records

- **Full-row duplicates:** 0
- **Duplicate `ID`s:** 0

No cleanup needed here — genuinely clean on this front.

## 8. Possible Inconsistencies / Data Quality Issues Found

| Issue | Where | Detail |
|---|---|---|
| Impossible age | `Year_Birth` | 3 customers show birth years 1893, 1899, 1900 → implied age of 114–121 in 2014 |
| Extreme outlier | `Income` | One customer shows Income = 666,666 vs. the next-highest value of 162,397 |
| Inconsistent category labels | `Marital_Status` | Contains `Alone` (3 rows), `Absurd` (2 rows), `YOLO` (2 rows) — not standard marital status labels |
| Text-typed date | `Dt_Customer` | Stored as plain text (`"2012-09-04"`), not a real date type — blocks any date arithmetic until parsed |

All four are **real findings from actually running pandas on the file** — nothing here is hypothetical. Full fix strategy comes in Phase 2.

## 9. Dimensions vs Measures (applied to our actual columns)

| Type | Columns |
|---|---|
| **Measures** (numeric, we `SUM`/`AVG`/`COUNT` these) | `Income`, `MntWines`...`MntGoldProds`, `TotalSpend` (derived), `NumWebPurchases`, `NumCatalogPurchases`, `NumStorePurchases`, `NumDealsPurchases`, `NumWebVisitsMonth`, `Recency` |
| **Dimensions** (we `GROUP BY`/filter using these) | `Education`, `Marital_Status`, `Kidhome`, `Teenhome`, `Complain`, and — after Phase 2 unpivoting — `Campaign_Name` and `Channel` |
| **Flags** (0/1, usually used as dimensions to segment, occasionally summed to count "how many accepted") | `AcceptedCmp1`–`5`, `Response`, `Complain` |
| **Identifiers** (neither — used for joining/uniqueness) | `ID` |

## 10. Relationships

**Today:** single flat file, no relationships (it's one table).

**Planned (Phase 2 target):** we will split this into 1 dimension table + 2 fact tables, joined on `customer_id`:

```
dim_customers (1) ───< fact_campaign_response (many)
dim_customers (1) ───< fact_channel_purchases (many)
```

Why split at all? Because right now `AcceptedCmp1`...`AcceptedCmp5`, `Response` are **6 separate columns** — to ask "which campaign performed best," we'd need to write 6 nearly-identical queries. If we instead reshape this into **one column called `campaign_name` with 6 possible values**, one `GROUP BY campaign_name` answers it in a single query. This reshaping is called **unpivoting** (wide → long), a genuinely common real-world data-prep step, not something invented for this project.

---

## 11. Concept Teaching (beginner-friendly Hinglish)

### 11.1 Row (Record)

**Kya hai:** Row ek table ki ek **horizontal line** hoti hai jo ek complete "entity" ya "observation" ko represent karti hai. Hamare case mein, **har row = ek customer** — uski age se lekar usne kaunsa campaign accept kiya, sab kuch ek hi row mein.

**Kyun zaroori hai:** Data ko organize karne ka sabse basic unit row hi hai. Jab hum kehte hain "2,240 customers hain," toh matlab hai "2,240 rows hain."

**Chota example:** Ek class register mein "Ravi | 15 | 10th | Delhi" — ye ek row hai, jo Ravi naam ke student ko represent karti hai.

**Project mein use:** `ID=5524` wali row poori tarah Customer #5524 ke baare mein hai — uski income, uska spend, uske accepted campaigns — sab isi ek row mein.

**Common mistake:** Beginners kabhi kabhi row aur column ko ulta bol dete hain, ya sochte hain "row count" hi "column count" hai. Duplicate rows ko bhi ignore kar dena ek common mistake hai — hume hamesha check karna chahiye (jaisa humne kiya: 0 duplicates).

**Interview questions:**
- *"Dataset mein row kya represent karti hai?"* → Simple: "Ek single observation/entity — hamare case mein ek customer."
- *"Aap duplicate rows kaise detect karoge?"* → `df.duplicated().sum()` in pandas, ya SQL mein `GROUP BY` + `HAVING COUNT(*) > 1`.

---

### 11.2 Column (Field / Attribute)

**Kya hai:** Column ek **vertical** field hai jo **har row ke liye same tarah ka data** store karta hai — ek particular "characteristic" ya "attribute." Jaise `Income` column har customer ki income batata hai.

**Kyun zaroori hai:** Columns hi decide karte hain ki hum data ke baare mein KYA jaante hain. Agar `Income` column nahi hota, toh hum kabhi income-based segmentation kar hi nahi paate.

**Chota example:** "Name," "Age," "City" — teeno columns hain; har student (row) ke liye inki apni value hogi.

**Project mein use:** Hamare paas 29 columns hain — `Income`, `Education`, `MntWines`, `Response`, etc. — har ek customer ka ek specific attribute batata hai.

**Common mistake:** Column ka data type bina check kiye assume kar lena. Jaise humne dekha `Income` asal mein `float64` hai (kyunki usme missing values/NaN hain) — agar hum bina check kiye ise "integer" maan lete, toh calculation mein dikkat aa sakti thi.

**Interview questions:**
- *"Column aur field mein kya difference hai?"* → Zyaadatar same hi matlab, "column" database/spreadsheet context mein zyada common, "field" thoda purana/generic term.
- *"Pandas mein columns ke data types kaise check karte ho?"* → `df.dtypes`.

---

### 11.3 Dimension vs Measure

**Kya hai:**
- **Measure** (ya "metric"/"fact value") — ek **numeric value jise hum aggregate karte hain** (SUM, AVG, COUNT, MIN, MAX). Jaise `Income`, `MntWines`, `TotalSpend`.
- **Dimension** — wo attribute **jiske "according to" hum measures ko group/filter/slice karte hain**. Jaise `Education`, `Marital_Status`, `Campaign_Name`.

**Kyun zaroori hai:** Almost har business question is form mein hota hai: **"[MEASURE] by [DIMENSION]"**. Jaise — "Total Spend **by** Education," "Conversion Rate **by** Campaign." Agar tumhe pata na ho kaunsa column measure hai aur kaunsa dimension, toh galat column pe `GROUP BY` ya `SUM` laga doge.

**Chota example:** "Total Sales (measure) by Region (dimension)" — kisi bhi retail company ka sabse common report.

**Project mein use:**
- Measures: `Income`, `MntWines`...`MntGoldProds`, derived `TotalSpend`, `NumWebPurchases`, etc. (inko SUM/AVG karenge)
- Dimensions: `Education`, `Marital_Status`, `Kidhome`/`Teenhome` (as "has kids" segments), aur Phase 2 ke baad `Campaign_Name`, `Channel` (inke "by" hum group karenge)

**Common mistake:** Ek hi column context ke hisaab se dono ho sakta hai! Jaise `Kidhome` numeric hai (0,1,2) lekin hum ise usually **dimension** ki tarah use karte hain ("has kids?" segment), na ki measure ki tarah (`SUM(Kidhome)` ka koi real business meaning nahi banta). Toh dimension-vs-measure column ke **data type** se nahi, uske **business use-case** se decide hota hai.

**Interview questions:**
- *"Dimension aur measure mein kya farak hai? Example do."* → Upar wali definition + "Total Spend by Education" example.
- *"Ek aisa column batao jo dimension aur measure dono ho sakta hai."* → `Kidhome` — usually dimension, but agar business question ho "total number of kids across all customers" toh measure ban jaata hai.

---

### 11.4 Primary Key (PK)

**Kya hai:** Primary Key wo column hai jo **har row ko uniquely identify karta hai** — koi do rows ka PK same nahi ho sakta, aur PK kabhi khaali (NULL) nahi hota.

**Kyun zaroori hai:** Bina PK ke, hum kisi specific row ko reliably point/refer nahi kar sakte, aur duplicate rows detect nahi kar sakte.

**Chota example:** Aadhar Number — har individual ka unique hota hai, koi do logon ka same nahi ho sakta.

**Project mein use:** `ID` humara Primary Key hai. Humne explicitly verify kiya: `df['ID'].duplicated().sum()` → `0`. Isliye `ID` ek valid PK hai.

**Common mistake:** Kisi bhi "unique-looking" column ko bina verify kiye PK maan lena. Jaise agar by chance `Income` mein sab values unique nikal aayen, wo phir bhi conceptually PK nahi ban sakta (do customers ki income same ho sakti hai — koi rule nahi jo isse roke).

**Interview questions:**
- *"Primary key kya hota hai aur usse kaise verify karoge?"* → Uniqueness + non-null check karke.
- *"Kya Primary Key NULL ho sakta hai?"* → Nahi, kabhi nahi.

---

### 11.5 Foreign Key (FK)

**Kya hai:** Foreign Key ek column hai jo **ek table mein hota hai lekin dusre table ke Primary Key ko refer/point karta hai** — ye do tables ko **link** karne ka tareeka hai.

**Kyun zaroori hai:** Jab data ko multiple tables mein split (normalize) karte hain, FK hi unhe wapas SQL `JOIN` se jodne deta hai.

**Chota example:** "Orders" table mein `customer_id` column hota hai, jo "Customers" table ke `ID` (PK) ko refer karta hai — isse pata chalta hai ki konsa order kis customer ka hai.

**Project mein use:** Abhi raw file single wide table hai, isliye FK nahi hai. Lekin Phase 2 mein jab hum `fact_campaign_response` aur `fact_channel_purchases` banayenge, unme ek `customer_id` column hoga jo `dim_customers.ID` (PK) ko refer karega — **wahi humara Foreign Key banega**, aur usi ke through hum SQL `JOIN` likhenge.

**Common mistake:** FK ko khud hi ek doosra PK samajh lena (FK duplicate ho sakta hai — same customer ke multiple campaign-response rows honge, ye normal hai). Doosri common mistake: FK mein aisi value daal dena jo doosri table ke PK mein exist hi nahi karti (isse "referential integrity" toot jaati hai).

**Interview questions:**
- *"Foreign Key kya hota hai, Primary Key se kaise related hai?"* → FK ek table mein hota hai jo dusri table ke PK ko point karta hai.
- *"FK duplicate ho sakta hai ek table mein?"* → Haan, bilkul (e.g., ek customer ke 6 campaign-response rows, sabme same `customer_id`).

---

### 11.6 Fact vs Dimension Table (Star Schema)

**Kya hai:**
- **Dimension table** = "WHO / WHAT / WHERE" describe karta hai — descriptive, mostly-static attributes. Row count usually kam hota hai (ek row per entity).
- **Fact table** = "KYA HUA / measurable EVENT" record karta hai — usually bahut zyada rows hoti hain (ek row per event/transaction), aur usme numeric measures + FK columns (jo dimension tables ko point karte hain) hote hain.

**Kyun zaroori hai:** Ye pattern ("star schema") real data warehouses aur BI tools (Power BI included) mein sabse common design hai — kyunki ye data ko **clean, non-redundant, aur query-friendly** banata hai.

**Chota example:** E-commerce mein `Products` dimension table (product ka naam, category, price) aur `Sales` fact table (har row = ek sale transaction, jisme `product_id` aur `customer_id` FK ki tarah hote hain).

**Project mein use:** Hamara raw file ek customer-centric wide table hai. Phase 2 mein hum ise split karenge:
- `dim_customers` — **WHO**: demographics (Education, Income, Age, etc.) — 2,240 rows (ek row per customer)
- `fact_campaign_response` — **WHAT HAPPENED**: did customer X accept campaign Y? — 2,240 × 6 = 13,440 rows
- `fact_channel_purchases` — **WHAT HAPPENED**: customer X ne channel Y se kitni purchases ki? — 2,240 × 3 = 6,720 rows

**Common mistake:** Fact aur dimension ko sirf "size" se pehchan lena ("fact = bada table hai isliye fact hai"). Asli criterion ye hai ki **fact table events/measurements store karta hai, dimension descriptive attributes.** Size sirf ek side-effect hai, definition nahi.

**Interview questions:**
- *"Fact table aur dimension table mein kya farak hai?"* → Fact = events/measurements (transactional), Dimension = descriptive attributes.
- *"Humne wide campaign columns ko unpivot karke long fact table kyun banaya?"* → Taaki `GROUP BY campaign_name` se ek hi query mein sab campaigns compare ho sakein, 6 alag queries likhne ki jagah.

---

### 11.7 Why Understanding Schema Matters

**Kya hai:** "Schema samajhna" matlab pura data ka **structure/blueprint** samajhna — kaunsa column kya represent karta hai, kaunsa PK hai, kaunsa FK hai, kaunse columns measures hain aur kaunse dimensions, aur tables ke beech relationships kya hain.

**Kyun zaroori hai:** Agar schema clear nahi hai, toh galat `JOIN` ho sakta hai, galat column pe `SUM`/`GROUP BY` lag sakta hai, ya ek **galat business conclusion** nikal sakta hai jo interview mein turant pakda jaata hai.

**Chota real example (ye hume khud mila):** `NumWebVisitsMonth` ek **monthly snapshot** hai, jabki `NumWebPurchases` **2-saal ka cumulative total** hai. Agar hum bina soche `NumWebPurchases / NumWebVisitsMonth` ko seedha "conversion rate" bol dete, toh ye galat/misleading number hota — kyunki time windows hi match nahi karte. Isiliye Phase 0/1 mein itna time diya schema verify karne mein.

**Project mein use:** Yahi wajah hai ki humne code likhne se pehle poora Phase 0 + Phase 1 sirf "samajhne" mein laga diya — taaki aage Phase 4 (SQL) aur Phase 7 (Python EDA) mein koi galat calculation na ho.

**Common mistake:** Jaldbaazi mein bina schema samjhe seedha charts/queries shuru kar dena. Ye galat insights deta hai, aur jab interviewer poochta hai "ye number kaise aaya, kis assumption pe," tab jawab nahi ban paata.

**Interview questions:**
- *"Analysis start karne se pehle dataset schema samajhna kyun zaroori hai?"* → Galat joins/aggregations/conclusions avoid karne ke liye.
- *"Koi example do jaha data quality/schema issue ne aapka analysis approach change kiya."* → Perfect answer: humara `Z_CostContact`/`Z_Revenue` constant assumption + `NumWebVisitsMonth` vs `NumWebPurchases` time-window mismatch — dono clearly bata sakte ho.

---

## 12. Summary / What's Next

- Dataset verified: 2,240 customers, 29 columns, 0 duplicates, 1 column with missing values (`Income`, 24 rows), 4 categories of data-quality issues found (age outliers, income outlier, junk marital-status labels, text-typed date).
- Every column classified as measure, dimension, flag, or identifier.
- Planned fact/dimension split defined and justified.
- **Next: Phase 2 — `docs/02_data_cleaning.md`** — actually fixing the missing values, outliers, and inconsistent categories found above, with WHAT/WHY/HOW/WHY-this-approach reasoning for each decision, plus the reusable cleaning script that produces `dim_customers.csv`, `fact_campaign_response.csv`, and `fact_channel_purchases.csv`.
