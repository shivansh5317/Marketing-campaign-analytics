# 08 — Python From Zero

🟡 GOOD TO KNOW (foundation for Pandas, which is 🔴 MUST)

Ye sirf wahi Python concepts cover karta hai jo is project ke liye zaroori hain — software-engineering-level Python nahi, **Data Analyst-level** Python.

## 1. Variables

- **What:** Ek naam jisme ek value store hoti hai.
- **Example:** `total_customers = 2212`
- **Project usage:** `RAW_PATH = "data/raw/ifood_marketing_campaign_raw.csv"` in `scripts/clean_data.py`.

## 2. Data Types

| Type | Example | Project usage |
|---|---|---|
| `int` | `2212` | Row counts |
| `float` | `607.3` | Averages, income |
| `str` | `"Champions"` | Category labels |
| `bool` | `True`/`False` | Filter conditions |

## 3. Lists

- **What:** An ordered collection of values, `[item1, item2, ...]`.
- **Example:** `MNT_COLUMNS = ["MntWines", "MntFruits", "MntMeatProducts", ...]`
- **Project usage:** `scripts/clean_data.py` uses `MNT_COLUMNS` (a list) to sum 6 spend columns at once: `df[MNT_COLUMNS].sum(axis=1)`.

## 4. Dictionaries

- **What:** Key-value pairs, `{key: value}` — used for lookups/renaming/mapping.
- **Example:** `{"AcceptedCmp1": "Cmp1", "Response": "Cmp6"}`
- **Project usage:** `CAMPAIGN_COLUMNS` dict in `scripts/clean_data.py` maps raw column names to clean campaign names, used later for `.map()`.

## 5. Loops

- **What:** Repeating an action for each item in a collection.
- **Example:** `for col in numeric_cols: print(col)`
- **Project usage:** the Phase 7 notebook loops over `numeric_cols` to build 6 histogram subplots without repeating code 6 times.

## 6. Conditions (if/elif/else)

- **What:** Branching logic based on a condition.
- **Example:**
```python
def assign_segment(rfm_score):
    if rfm_score >= 10:
        return "Champions"
    if rfm_score >= 7:
        return "Loyal Customers"
    if rfm_score >= 5:
        return "At Risk"
    return "Lost / Hibernating"
```
This is copied directly from `scripts/segment_customers.py` — the actual segment-assignment logic.

## 7. Functions

- **What:** A reusable, named block of code that takes inputs and returns an output.
- **Why:** Avoids repeating code; makes each step of a pipeline testable/readable on its own.
- **Project usage:** `scripts/clean_data.py` is built entirely as small functions — `load_raw_data()`, `clean_customers()`, `derive_features()`, `build_dim_customers()`, `build_fact_campaign_response()`, `build_fact_channel_purchases()`, chained together in `main()`. Each function does ONE clear job — a real, working example of clean function decomposition, not a giant single script.

## 8. Importing Libraries

- **What:** Bringing in pre-built code (someone else already wrote it, tested it, published it).
- **Syntax:** `import pandas as pd` (`pd` is just a short alias, by convention).
- **Project usage:** every script/notebook starts with `import pandas as pd`, plus `numpy`, `matplotlib.pyplot`, `seaborn`, `sqlite3` where needed.

## 9. Reading Files

- **What:** Loading external data into memory.
- **Project usage:** `pd.read_csv(path)` — used everywhere in this project to load CSVs into DataFrames.

## 10. `if __name__ == "__main__":`

- **What:** A Python idiom meaning "only run this block if the file is executed directly (not imported)."
- **Project usage:** every script (`clean_data.py`, `segment_customers.py`, `load_to_sqlite.py`) ends with:
```python
if __name__ == "__main__":
    main()
```
This lets each script be run standalone (`python scripts/clean_data.py`) while still being safely importable elsewhere if needed.

## 11. INTERVIEW

**Q: "Aapko Python OOP (classes) aapke project mein kahin dikhi?"**
> "Nahi — ye ek Data Analyst-scope project hai, function-based scripts use kiye hain (`clean_data.py`, `segment_customers.py`), classes ki zaroorat nahi thi. Har script chhoti, single-purpose functions mein tuta hua hai."

**Q: "Aapka code reusable/reproducible kaise hai?"**
> "Har script ek command se poora pipeline reproduce kar sakta hai (`python scripts/clean_data.py`) — koi manual/one-off step nahi hai. Functions ko clearly named steps mein toda gaya hai taaki koi bhi dobara-run kar sake aur same result mile."

## 12. What I Should Remember

1. This project uses Python at a **Data Analyst level** — variables, lists, dicts, loops, conditions, functions, file I/O. No classes/OOP, no advanced software-engineering patterns needed.
2. Every script is idempotent (re-runnable) and produces the exact documented output.

---
*Next: [09_PANDAS_FROM_ZERO.md](09_PANDAS_FROM_ZERO.md)*
