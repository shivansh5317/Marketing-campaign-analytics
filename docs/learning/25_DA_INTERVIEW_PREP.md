# 25 — General Data Analyst Interview Prep

🟡 GOOD TO KNOW (beyond-the-project, general fresher DA prep)

## MUST KNOW

| Topic | What to be fluent in |
|---|---|
| SQL | SELECT, WHERE, GROUP BY, HAVING, JOIN types, CASE WHEN, basic subqueries |
| Pandas | DataFrame basics, filtering, groupby, merge, missing values |
| Data Cleaning | Missing values, duplicates, outliers, data types |
| Business Metrics | Conversion rate, revenue vs. profit, CAC, basic ROI |
| Visualization | When to use bar/line/histogram/scatter/pie |
| Business Thinking | Translating a vague business question into an analyzable one |

## GOOD TO KNOW

| Topic | What to know |
|---|---|
| SQL | CTEs, basic window functions (RANK, NTILE) |
| Statistics | Mean/median/mode, std dev, percentile, correlation |
| Power BI / Excel | Basic dashboard concepts, pivot-table-equivalent thinking |
| Segmentation | RFM or similar rule-based segmentation logic |

## OPTIONAL (for a fresher)

| Topic | Why optional |
|---|---|
| Advanced window functions (LAG/LEAD), recursive CTEs | Rarely needed at entry-level, good to mention you know *when* you'd use them |
| Hypothesis testing / p-values | More common in analytics-with-experiments roles, less common for descriptive/dashboard-focused DA roles |
| Machine Learning | Not a core DA skill — a plus if the role is "DA with light ML," not expected otherwise |

## Fresher-Level General Questions (not project-specific)

| Question | Strong Short Answer |
|---|---|
| "SQL aur Excel mein kab konsa use karoge?" | "Excel chhoti, ad-hoc, visual-manipulation-heavy cheez ke liye; SQL bade, repeatable, precise queries ke liye jo versioned/re-runnable hona chahiye." |
| "Aap data quality kaise verify karte ho naye dataset mein?" | "Shape check, dtypes check, missing-value %, duplicate check, category value_counts, aur obvious range sanity checks (negative ages, impossible dates)." |
| "Dashboard design karte waqt sabse important principle?" | "Ek clear business question per page/section, headline KPI upar, detail niche, consistent color-coding, aur har assumption explicitly labeled." |
| "Agar stakeholder ek metric maange jo data mein available nahi, kya karoge?" | "Openly bataunga ki wo metric is data se calculate nahi ho sakti, aur agar possible ho ek closest valid alternative suggest karunga — kabhi number invent nahi karunga." |

## INTERVIEW

**Q: "Aap khud ko kaise differentiate karoge dusre fresher candidates se?"**
> "Mera ek real, end-to-end project hai jaha maine khud galtiyan pakड़ी aur fix ki (jaise funnel ka time-window mismatch), har decision ko justify kar sakta hoon, aur hedged/honest business language use karta hoon (causation claim nahi karta bina evidence ke) — ye exactly wo cheez hai jo junior se mid-level analyst ko differentiate karti hai."

## Common Mistakes (general, fresher-level)

- Sirf tools/syntax ratna, "why" na samajhna.
- Har sawaal ka ek hi "correct" technical answer samajh lena — business context hamesha matter karta hai.
- Apne project ke numbers yaad na hona (interviewers real numbers poochte hain).

## What I Should Remember

1. MUST KNOW list is non-negotiable for any fresher DA interview — SQL, pandas, cleaning, core metrics, basic viz, business thinking.
2. My project genuinely covers almost everything in the MUST + GOOD lists — I should map each general topic back to a concrete example from it.

---
*Next: [26_SQL_INTERVIEW_PREP.md](26_SQL_INTERVIEW_PREP.md)*
