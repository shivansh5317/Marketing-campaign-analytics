# 28 — Power BI Interview Prep

🟢 OPTIONAL (go deep only on what's actually in the build spec)

## Power BI Basics

**Q: "Power BI Desktop vs. Power BI Service?"**
> Desktop = the free Windows app where you build reports (used for this project's spec). Service = the cloud platform for publishing/sharing — out of scope here (single local `.pbix` file only).

**Q: "Data import karne ke tareeke?"**
> Import mode (data copied into Power BI's own model — what this project's spec uses, via CSV) vs. DirectQuery (live connection, no copy, more complex) vs. Live Connection (for specific sources like Analysis Services).

## Relationships

**Q: "Power BI mein relationship SQL JOIN se kaise related hai?"**
> Same PK-FK concept — once defined in the Model view, Power BI auto-applies the "join" logic whenever a visual mixes fields from related tables, without writing any JOIN syntax yourself.

**Q: "One-to-many relationship kaise pehchante ho Power BI mein?"**
> The "1" side shows a single line end, the "many" side shows an asterisk/crow's-foot — in our model, `dim_customers` is the "1" side for both relationships.

## Filters & Slicers

**Q: "Filter aur Slicer mein farak?"**
> Filter = can be applied invisibly (page/report-level) or via the Filters pane; Slicer = a visible, clickable on-canvas control the end-user interacts with directly.

## Visual Selection

**Q: "Pie chart kab avoid karna chahiye?"**
> Jab categories zyada (8+) hon — slices itni chhoti/close ho jaati hain ki compare karna mushkil hota hai. Humne sirf 4-segment revenue-share ke liye use kiya.

## KPI Cards & Measures

**Q: "Measure vs. Calculated Column?"**
> Measure dynamically recalculates based on filter context (e.g., `Total Revenue` changes per clicked segment); Calculated Column is fixed per row, computed once.

## DAX Basics

**Q: "`DIVIDE()` kyun use karte ho `/` ki jagah?"**
> `DIVIDE(a, b, default)` safely handles division by zero by returning a default value instead of erroring — important for ratio measures like Acceptance Rate % where a denominator could theoretically be 0 in some filtered context.

**Q: "`CALCULATE` function kya karta hai?"**
> Changes the filter context for an expression — e.g., `CALCULATE(SUM(x), ALL(table[column]))` removes a filter to compute a grand total even inside a filtered visual (used in our `Channel Share %` and `Segment Revenue Share %` measures).

## Dashboard Design & Business Storytelling

**Q: "Ek achha dashboard design karte waqt kya principles follow karte ho?"**
> One clear business question per page; KPI cards at top, detail below; consistent color scheme across pages; every assumption labeled directly on the visual (see [20_POWER_BI_IN_PROJECT.md](20_POWER_BI_IN_PROJECT.md) Section 4).

## INTERVIEW (project-specific)

**Q: "Aapka dashboard abhi tak kyun nahi bana?"**
> "Power BI Desktop ek Windows GUI application hai jo ek automated coding session se directly operate nahi ki ja sakti. Maine iski jagah ek bilkul exact, page-by-page, measure-by-measure build specification likhi hai — taaki ise follow karke dashboard banana ek mechanical, error-free process ho."

**Q: "Agar aap abhi Power BI mein baithe ho, pehla kadam kya hoga?"**
> "3 processed CSVs import karna, Model view mein relationships verify karna, phir measures banake Page 1 (Campaign Overview) se shuru karna."

## Common Mistakes

- Measure ki jagah Calculated Column use karna jab dynamic filtering chahiye.
- Safe division (`DIVIDE`) ki jagah plain `/` use karna.
- Bahut saari categories wale pie chart banana.

## What I Should Remember

1. Power BI concepts here map directly to the actual build spec in [20_POWER_BI_IN_PROJECT.md](20_POWER_BI_IN_PROJECT.md) — not generic, memorized trivia.
2. `DIVIDE()` and `CALCULATE(..., ALL(...))` are the two DAX patterns most directly reused from this project's SQL logic.

---
*Next: [29_STATISTICS_INTERVIEW_PREP.md](29_STATISTICS_INTERVIEW_PREP.md)*
