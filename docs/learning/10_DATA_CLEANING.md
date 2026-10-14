# 10 — Data Cleaning

🔴 MUST KNOW

## 1. What Is Data Cleaning, And Why Is It Necessary?

### GENERAL CONCEPT

**Kya hai:** Data cleaning matlab raw data mein maujood **errors, inconsistencies, missing pieces** ko fix karna, taaki koi bhi analysis un problems ki wajah se galat na ho.

**Kyun zaroori hai:** "Garbage in, garbage out" — agar underlying data galat hai (impossible values, duplicate entries, inconsistent labels), toh chahe analysis kitna bhi sophisticated ho, result bhi galat hi hoga. Ek Analyst ka credibility isi pe depend karta hai ki wo apne numbers ko defend kar sake — aur wo tabhi possible hai jab cleaning decisions justified/documented hon.

### Common Cleaning Problems (general)

| Problem | Meaning |
|---|---|
| Missing values | Cell mein koi value hi nahi (NaN/NULL) |
| Duplicate rows | Same record multiple baar |
| Inconsistent categories | Same category multiple labels ke saath ("Alone" vs "Single") |
| Wrong data types | Number text ki tarah stored, ya date text ki tarah stored |
| Invalid/impossible values | Values jo logically possible hi nahi (age 121 saal) |
| Date issues | Text-typed dates, inconsistent formats |
| Outliers | Values jo baaki data se bahut door hain (error ho sakte hain, ya genuine extreme) |

## 2. MY PROJECT — Every Real Cleaning Decision

All code: [scripts/clean_data.py](../../scripts/clean_data.py). Reproduce: `python scripts/clean_data.py`. Result: **2,240 → 2,212 rows (28 dropped, 98.75% retained)**.

### Issue 1 — Impossible Customer Ages

- **PROBLEM:** `Year_Birth` had 3 customers with values 1893, 1899, 1900 → implied age 114-121 in 2014.
- **DETECTION:** Computed `implied_age = 2014 - Year_Birth`, then checked the max — found values that are biologically implausible.
- **WHY IT MATTERS:** If left in, age-based segmentation would create a fake "100+ years old, high spender" group — meaningless for business decisions.
- **ACTION:** Dropped the 3 rows (`df[implied_age <= 90]`).
- **WHY WE CHOSE IT:** Only 3 rows (0.13% of data) — dropping is simpler and safer than guessing a "correct" birth year, since there was no reliable way to impute it.
- **RESULT:** 3 rows removed, no other side effects.

### Issue 2 — Missing `Income` (24 rows)

- **PROBLEM:** 24 customers (1.07%) had no `Income` value (NaN).
- **DETECTION:** `df['Income'].isna().sum()` → 24.
- **WHY IT MATTERS:** `Income` is a core segmentation/correlation field — leaving NaNs in would silently break or bias any `AVG(Income)`/correlation calculation.
- **ACTION:** Dropped the 24 rows (`df.dropna(subset=["Income"])`).
- **WHY WE CHOSE IT (drop, not impute):** We first checked whether the missing-income group was "special" (bias check) — their campaign Response rate was only 4.17% vs. 15.03% for everyone else. Interesting, but the sample (24 rows) was too small to act on confidently. Given the tiny %, dropping avoids injecting an artificial assumption (like a median-fill) into a sensitive, high-variance field. **Rule of thumb used:** drop when the missing % is small, consider imputation only when it's large enough that dropping would meaningfully shrink the dataset.
- **RESULT:** 24 rows removed.

### Issue 3 — Extreme `Income` Outlier (666,666)

- **PROBLEM:** One customer's `Income` = 666,666, vs. the next-highest value of 162,397 — a 4x+ jump.
- **DETECTION:** Sorting `Income` descending and inspecting the top few values.
- **WHY IT MATTERS:** A single such value can visibly distort `AVG(Income)` and any percentile-based cutoff (like our RFM quartiles).
- **ACTION:** Dropped the single row.
- **WHY WE CHOSE IT (drop, not cap/winsorize):** Only 1 row (0.04%) — dropping is simplest and equally defensible at this scale; capping (e.g., to the 95th percentile) is a valid alternative technique but adds complexity with no meaningful benefit for a single-row case.
- **RESULT:** 1 row removed.

### Issue 4 — Inconsistent `Marital_Status` Categories

- **PROBLEM:** Besides 5 valid categories (Married/Together/Single/Divorced/Widow), the column also had `Alone` (3), `Absurd` (2), `YOLO` (2) — 7 non-standard labels.
- **DETECTION:** `.value_counts()` on `Marital_Status` surfaced the odd category names immediately.
- **WHY IT MATTERS:** Grouping by this column without fixing it would produce 8 categories instead of a clean 5-6, confusing any segment-level report.
- **ACTION:** Recoded (not dropped): `Alone` → `Single`; `Absurd`/`YOLO` → `Other`.
- **WHY WE CHOSE IT (recode, not drop):** The rest of each row's data (income, spend, campaign response) was perfectly valid — only the label was odd. Dropping the whole row would waste otherwise-good data for a small labeling issue.
- **RESULT:** 7 rows recoded, 0 rows lost.

### Issue 5 — `Dt_Customer` Stored as Text

- **PROBLEM:** The enrollment date column was `object` (text) type, e.g., `"2012-09-04"` — looks like a date, isn't one to pandas.
- **DETECTION:** `.dtypes` showed `object`, not `datetime64`.
- **WHY IT MATTERS:** Text dates can't be used for date arithmetic (e.g., computing tenure) — attempting subtraction on strings either errors or silently does the wrong thing.
- **ACTION:** `pd.to_datetime(df["Dt_Customer"], format="%Y-%m-%d")`.
- **WHY WE CHOSE IT:** Standard, unambiguous, single-line fix — no alternative approach genuinely needed here.
- **RESULT:** Column is now a real datetime; unlocked the `customer_tenure_days` derived field.

## 3. Where We Deliberately Did NOT Modify Data

- **Did not** impute `Income` (Issue 2) — explained above.
- **Did not** cap/winsorize the income outlier (Issue 3) — a single row, dropping was simpler and equally valid at this scale.
- **Did not** drop the `Marital_Status` junk rows — recoded instead, to preserve otherwise-valid data.
- **Did not** touch `Z_CostContact`/`Z_Revenue` — these are the dataset's own intentional constants, not a data-quality issue.
- **Did not** apply any outlier-removal rule to `total_spend`'s high-end values (the genuine big spenders) — those are valid, valuable customers, not errors (see [18_STATISTICS_FROM_ZERO.md](18_STATISTICS_FROM_ZERO.md) Section 6 for the "2 types of outliers" distinction).

## 4. INTERVIEW

**Q: "Aap kaise decide karte ho ki missing values drop karne hain ya fill karne hain?"**
> "Depend karta hai missing %, field ki importance, aur kya missing-ness khud ek pattern hai. Hamari `Income` sirf 1.07% thi — chhota % ho toh drop karna safe hai. Agar 20-30%+ hota, ya field itni critical na hoti, tab imputation (median/mode) consider karta — lekin hamesha ye document karke ki ye ek assumption hai."

**Q: "Aap har missing/outlier row ko kyun nahi delete kar dete safe side ke liye?"**
> "Kyunki har row genuinely valid data carry karti hai jo dusre fields mein use ho sakta hai. Jaise `Marital_Status` ki 7 junk-label rows — sirf ek column ka issue tha, poori row drop karna data waste karta. Hamesha problem ke scope ke hisaab se decide karo — pura-row-drop sirf tab jab problem itna fundamental ho ki row trust hi nahi ki ja sakti (jaise impossible age)."

**Q: "Outlier ko kaise detect karte ho, aur har outlier ko remove kar dena chahiye?"**
> "Humne domain-logic checks use kiye — implausible age (>90), aur ek extreme value jump (666,666 vs 162,397). Har outlier remove nahi karna chahiye — genuine high-value customers (jaise top-spend decile) bhi statistically outliers dikh sakte hain, lekin wo errors nahi, real valuable data hain. Humne unhe rakha."

**Q: "Date column ko convert karna kyun zaroori tha?"**
> "Bina convert kiye, `Dt_Customer` par koi date-arithmetic (tenure calculation) possible nahi thi — text subtraction meaningless/error-prone hota."

## 5. Common Mistakes

- Har missing-value row ko automatically drop kar dena bina % check kiye — bade dataset mein isse significant data loss ho sakta hai.
- Outlier ko "bad data" maan lena bina check kiye ki genuine extreme hai ya error.
- Category labels ko clean kiye bina seedha `GROUP BY`/segment report bana dena.

## 6. What I Should Remember

1. Every cleaning decision here follows PROBLEM → DETECTION → WHY IT MATTERS → ACTION → WHY WE CHOSE IT → RESULT — a reusable framework for any interview follow-up.
2. Net result: 2,240 → 2,212 rows (98.75% retained) — cleaning here was surgical, not aggressive.
3. "Drop when small %, impute/recode when the situation calls for it" — a simple, defensible rule of thumb, not a rigid law.

---
*Next: [11_EDA_AND_VISUALIZATION.md](11_EDA_AND_VISUALIZATION.md)*
