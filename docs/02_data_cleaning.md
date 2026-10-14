# 02 — Data Cleaning

Is phase mein humne Phase 1 mein mile hue **4 real data-quality issues** ko fix kiya, kuch naye useful columns derive kiye, aur raw wide table ko ek chhote **star schema** (1 dimension + 2 fact tables) mein split kiya. Sab kuch [scripts/clean_data.py](../scripts/clean_data.py) mein hai — ek hi command se dobara reproduce ho sakta hai (`python scripts/clean_data.py`), koi manual/one-off step nahi hai.

**Before → After:** 2,240 rows → **2,212 rows** (28 rows dropped, 98.75% data retained), 29 raw columns → 24-column `dim_customers` + 2 clean fact tables.

---

## 1. Cleaning Decisions (WHAT → WHY → HOW → WHY-this-approach)

### Issue 1 — Impossible customer ages (`Year_Birth`)

- **WHAT was wrong:** 3 customers had `Year_Birth` of 1893, 1899, 1900 → implied age of 114–121 in 2014.
- **WHY it was a problem:** Koi bhi real customer 114+ saal ka nahi ho sakta — ye clearly ek data-entry glitch hai (shayad kisi ne form mein galat year daal diya, jaise birth-year dropdown ka pehla/last option accidentally select ho gaya). Agar isse chhoda jaata, toh Age-based segmentation (Phase 5) mein ek fake "100+ years old, high spender" group ban jaata jo business ke liye bilkul meaningless hota.
- **HOW we handled it:** In 3 rows ko drop kar diya (`implied_age <= 90` filter).
- **WHY this approach (not another one):** 3 rows sirf 0.13% data hain — itna chhota fraction hai ki drop karna imputation se zyada simple aur safe hai. Hum kisi bhi tarah "sahi" birth year guess nahi kar sakte the (impute karne ka koi reliable tareeka nahi tha), isliye drop karna hi sabse honest option tha.

### Issue 2 — Missing `Income` values (24 rows)

- **WHAT was wrong:** 24 customers (1.07% of data) ke `Income` field mein value hi nahi thi (NaN).
- **WHY it was a problem:** `Income` humara sabse important segmentation dimension hai (RFM/demographic segmentation mein core field, Phase 5). Missing value wale rows ko as-is chhodne se koi bhi `AVG(Income)` ya income-based filter automatically un rows ko galat tarike se handle karta (ya error deta, ya silently exclude karta bina hume pata chale).
- **HOW we handled it:** In 24 rows ko drop kar diya (`dropna(subset=['Income'])`).
- **WHY this approach (not imputation):** Humne pehle ye check kiya ki kahin missing-income wale customers "special" toh nahi (bias check) — unka **Response rate sirf 4.17%** nikla, jabki baaki sabka **15.03%**. Ye difference interesting hai, lekin sample itna chhota hai (sirf 24 rows) ki hum confidently kuch keh nahi sakte — bas itna nota kar rahe hain ki "ye group thoda differently behave karta dikhta hai" (transparency ke liye, chhupaya nahi). Given ki 1.07% hi data hai, humne **drop karna** choose kiya kyunki:
  1. Itna chhota % hai ki overall metrics par negligible impact hoga.
  2. Imputation (jaise median se fill karna) ek **assumption inject** karta — aur `Income` jaisa sensitive/high-variance field ko impute karna segmentation thresholds ko artificially distort kar sakta tha.
  3. "Drop when small %, impute when large %" — ek simple, defensible, interview-ready rule of thumb hai.

### Issue 3 — Extreme `Income` outlier (666,666)

- **WHAT was wrong:** Ek customer ka `Income` = 666,666 tha, jabki agla sabse bada value sirf 162,397 tha — 4x se zyada ka jump.
- **WHY it was a problem:** Ye value `AVG(Income)` ko akela hi bahut upar khींch deta (mean without this row: ~51,970 vs with it: ~52,247 — chhota shift lekin percentile-based segment cutoffs isse asaani se distort ho sakte hain). Aisi extreme values usually ya toh genuine rare outlier hoti hain ya data-entry error (jaise koi extra digit type ho gaya, "66,666" ki jagah "666,666").
- **HOW we handled it:** Is 1 row ko drop kar diya.
- **WHY this approach (not capping/winsorizing):** Sirf ek row thi (0.04% data) — itna chhota impact hai ki drop karna sabse simple, samajhne mein sabse aasan approach tha. Capping (jaise value ko 95th percentile pe cap karna) bhi valid technique hai, lekin ek single-row case ke liye extra complexity add karta bina meaningful benefit ke — is project ke scope ("avoid unnecessary complexity") ke against jaata.

### Issue 4 — Inconsistent `Marital_Status` categories

- **WHAT was wrong:** `Marital_Status` mein 5 valid categories (Married, Together, Single, Divorced, Widow) ke alawa 3 aur "categories" thi: `Alone` (3 rows), `Absurd` (2 rows), `YOLO` (2 rows) — total 7 rows.
- **WHY it was a problem:** Ye standard marital-status labels nahi hain. Agar hum `GROUP BY Marital_Status` karte bina fix kiye, toh humein 8 categories milti jisme se 3 meaningless/duplicate-ish hain — segment-wise reporting confusing ho jaati.
- **HOW we handled it:** Recode kiya (drop nahi kiya, kyunki demographic data still valid tha, sirf label ajeeb tha):
  - `Alone` → `Single` (semantically "akela rehna" ≈ single hi hai)
  - `Absurd`, `YOLO` → `Other` (ye clearly joke/test values hain, koi clean mapping nahi hai, isliye ek neutral "Other" bucket mein daal diya)
- **WHY this approach (not dropping these rows):** Baaki saara data (Income, spend, campaign response) in 7 customers ka bilkul valid tha — sirf ek label ajeeb tha. Poori row drop karna data waste karna hota jab sirf ek chhota fix chahiye tha. Recoding se hum data retain karte hain aur category bhi clean rehti hai.

### Issue 5 — `Dt_Customer` stored as text, not a date

- **WHAT was wrong:** `Dt_Customer` column pandas mein `object` (plain text) type mein tha, jaise `"2012-09-04"` — ek date ki tarah dikhta hai lekin technically string hai.
- **WHY it was a problem:** Text hone ki wajah se hum isper koi date arithmetic (jaise "customer kitne din se hai" nikalna) nahi kar sakte the — `"2014-01-01" - "2012-09-04"` string subtraction jaisa kuch valid nahi hai.
- **HOW we handled it:** `pd.to_datetime()` se real datetime type mein convert kiya.
- **WHY this approach:** Ye standard, single-line, zero-ambiguity fix hai — koi alternative approach discuss karne ki zaroorat nahi, ye seedha "text ko uske real type mein convert karna" hai.

---

## 2. Derived Features (new columns, computed from existing clean data — nothing invented)

| New column | Formula | Why we need it |
|---|---|---|
| `age` | `2014 - year_birth` (using our stated 2014-12-31 reference date) | Raw data only gives birth year; age is more directly useful for segmentation |
| `total_children` | `kidhome + teenhome` | Single "family size" dimension is easier to segment on than two separate columns |
| `customer_tenure_days` | `2014-12-31 − dt_customer` | "How long has this person been a customer" — useful for loyalty-style analysis |
| `total_spend` | sum of the 6 `mnt_*` columns | Our real Revenue/Monetary measure (used everywhere: KPIs, RFM, segmentation) |
| `total_purchases` | `num_web_purchases + num_catalog_purchases + num_store_purchases` | Our real Frequency measure (deliberately excludes `num_deals_purchases`, since deals purchases overlap with the other three rather than being a separate channel) |
| `num_campaigns_accepted` | sum of the 6 campaign accept flags | Engagement-depth measure: 0 = never responded, up to 5 = serial responder |

**Important, stated assumption:** we chose **2014-12-31** as the "as of" analysis date because the data's latest enrollment date is 2014-06-29 and no explicit "today" date exists in the source. This only affects `age` and `customer_tenure_days` — every other number in this project is a direct or summed value from the source data.

---

## 3. Building the Star Schema (unpivoting wide → long)

### Concept: Unpivot / Melt (wide format → long format)

**Kya hai:** "Wide" format mein ek hi row mein bahut saari related columns hoti hain (jaise humare `AcceptedCmp1`...`AcceptedCmp5`, `Response` — 6 columns). "Long"/"tidy" format mein wahi information **ek column ke multiple rows** mein spread hoti hai — jaise ek `campaign_name` column jisme 6 alag rows hongi per customer. Ye transformation **melt** ya **unpivot** kehlata hai.

**Kyun zaroori hai:** Wide format mein "which campaign performed best" jaise question ka jawab dene ke liye humein 6 alag `AVG(AcceptedCmpX)` calculate karne padte. Long format mein sirf ek `GROUP BY campaign_name` query se sab 6 campaigns compare ho jaate hain.

**Chota generic example:**
```
Wide:                          Long (after melt):
customer | Jan | Feb           customer | month | sales
   A     | 100 | 150    →         A     | Jan   | 100
                                   A     | Feb   | 150
```

**Project mein use:** `pandas.melt()` use karke humne:
- `AcceptedCmp1..5` + `Response` (6 wide columns) → `fact_campaign_response.csv` (customer_id, campaign_name, accepted) — **13,272 rows** (2,212 customers × 6 campaigns)
- `NumWebPurchases`, `NumCatalogPurchases`, `NumStorePurchases` (3 wide columns) → `fact_channel_purchases.csv` (customer_id, channel, num_purchases) — **6,636 rows** (2,212 customers × 3 channels)

**Common mistake:** Melt karte waqt `id_vars` (jo column SAME rehna chahiye, yahan `customer_id`) galat specify karna — isse data galat tarike se duplicate/misalign ho jaata hai.

**Interview questions:**
- *"Wide aur long/tidy data format mein kya farak hai, aur kab konsa use karte ho?"* → Wide = human-readable/spreadsheet-friendly; Long = database/BI-tool-friendly, easier GROUP BY.
- *"Pandas mein wide-to-long conversion kaise karte ho?"* → `df.melt(id_vars=..., var_name=..., value_name=...)`.

---

## 4. Reproducibility

Everything above happens in one script — no manual spreadsheet edits, no hidden steps:

```powershell
cd "DA2"
python scripts/clean_data.py
```

Output:
```
Raw shape: (2240, 29)
Shape after cleaning: (2212, 29) (28 rows dropped)
dim_customers.csv           -> (2212, 24)
fact_campaign_response.csv  -> (13272, 3)
fact_channel_purchases.csv  -> (6636, 3)
```

Anyone (including an interviewer asking "can you show me this runs") can re-run this script from scratch and get the identical result.

## 5. Final Processed Tables

| File | Rows | Columns | Grain (what one row means) |
|---|---|---|---|
| `data/processed/dim_customers.csv` | 2,212 | 24 | One customer |
| `data/processed/fact_campaign_response.csv` | 13,272 | 3 | One (customer, campaign) pair |
| `data/processed/fact_channel_purchases.csv` | 6,636 | 3 | One (customer, channel) pair |

## 6. What We Deliberately Did NOT Do

- Did **not** impute Income (explained in Issue 2 — small %, avoids injecting a false assumption into a core segmentation field).
- Did **not** cap/winsorize the income outlier (single row, dropping is simpler and equally defensible at this scale).
- Did **not** drop the `Marital_Status` junk rows — recoded instead, to preserve otherwise-valid customer data.
- Did **not** touch `Z_CostContact`/`Z_Revenue` — they're intentional constants from the source, not a data quality issue.

---
*Next: Phase 3 — `docs/03_marketing_kpis.md` (defining every KPI formula with Hinglish explanations, using only these cleaned/derived fields).*
