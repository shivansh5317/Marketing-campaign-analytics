# 19 — Power BI From Zero

🟡 GOOD TO KNOW

## 1. What Is Power BI, And Why Use It?

**Kya hai:** Power BI ek Microsoft BI (Business Intelligence) tool hai jisse aap data ko **interactive dashboards/reports** mein convert kar sakte ho — bina coding ke, mostly drag-and-drop se.

**Why use it:** SQL/Python se insights milte hain, lekin ek non-technical business stakeholder SQL query ya Jupyter notebook nahi padhega. Power BI un insights ko **clickable, visual, self-service** report mein convert karta hai — stakeholder khud filter/slice karke apne sawaalon ke jawab dhoondh sakta hai.

## 2. Core Concepts (beginner-friendly)

| Term | Meaning |
|---|---|
| **Power BI Desktop** | The free Windows app where you build reports |
| **Data Source** | Where your data comes from (CSV, database, Excel, etc.) |
| **Dataset** | The data loaded into Power BI's own internal model |
| **Data Model** | The tables + relationships between them, inside Power BI |
| **Relationships** | How tables connect (like SQL's PK-FK, same concept) |
| **Report** | A file containing one or more pages of visuals |
| **Page** | One "screen" of the report, focused on a theme |
| **Visual** | A single chart/table/card on a page |
| **Filter** | Narrows down what data is shown (can apply to one visual, a page, or the whole report) |
| **Slicer** | An on-screen, clickable filter control (e.g., a list of segments to click) |
| **KPI Card** | A big single-number visual, usually for a headline metric |
| **Measure** | A calculation that recalculates dynamically based on filter/selection context |
| **Calculated Column** | A calculation computed once per row, stored in the table (not dynamic like a measure) |
| **DAX** | "Data Analysis Expressions" — the formula language Power BI uses for measures/calculated columns |

**Measure vs. Calculated Column (important distinction):** A measure recalculates based on *whatever is currently filtered/selected* (e.g., "Total Revenue" changes as you click different segments). A calculated column computes one fixed value **per row**, stored permanently (e.g., labeling each row's age band) — it does NOT change based on filters.

## 3. Basic DAX — Beginner Examples

```dax
Total Customers = DISTINCTCOUNT(customers[customer_id])

Total Revenue = SUM(customers[total_spend])

Acceptance Rate % = DIVIDE([Total Accepted], [Total Targeted], 0)
```

- `DISTINCTCOUNT` = count unique values (like SQL `COUNT(DISTINCT ...)`).
- `SUM` = add up a column (like SQL `SUM(...)`).
- `DIVIDE(numerator, denominator, default_if_error)` = safe division that returns a default (usually 0) instead of erroring if the denominator is 0 — this is DAX's built-in protection against divide-by-zero, which SQL/pandas don't have quite as conveniently built in.

## 4. INTERVIEW

**Q: "Power BI kis liye use karte hain, jab humare paas already SQL/Python se insights hain?"**
> "SQL/Python technical audiences (analysts, engineers) ke liye hain. Power BI un insights ko ek non-technical business stakeholder ke liye **interactive, self-service** bana deta hai — wo khud click karke apne sawaal ka jawab dhoondh sakta hai, bina query likhe."

**Q: "Measure aur Calculated Column mein farak?"**
> "Measure dynamically recalculate hota hai jo bhi currently filter/select kiya gaya ho uske against — jaise 'Total Revenue' automatically change ho jaata hai jab tum ek segment click karte ho. Calculated Column ek fixed value har row ke liye ek baar compute karke store kar deta hai — filters se change nahi hota."

**Q: "DAX ka `DIVIDE` function `/` operator se better kyun hai?"**
> "`DIVIDE(a, b, 0)` automatically 0 (ya jo default do) return karta hai agar `b` zero ho, bina error diye. Plain `/` operator divide-by-zero pe error de sakta hai jo poora visual break kar sakta hai."

## 5. Common Mistakes

- Calculated Column ko Measure ki jagah use karna jab dynamic filtering chahiye ho (result "stuck" dikhega).
- Plain `/` use karna jab denominator kabhi 0 ho sakta ho — `DIVIDE()` use karo.
- Bahut saare slicers/filters ek hi page pe daal dena — clutter ho jaata hai.

## 6. What I Should Remember

1. Power BI = data model (tables+relationships) + measures (DAX) + visuals (pages) + interactivity (slicers/filters).
2. Measures recalculate dynamically; calculated columns don't.
3. `DIVIDE()` is the safe-division pattern to always prefer over `/`.

---
*Next: [20_POWER_BI_IN_PROJECT.md](20_POWER_BI_IN_PROJECT.md)*
