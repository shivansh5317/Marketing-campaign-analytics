# 20 — Power BI In My Project

🟡 GOOD TO KNOW

> ⚠️ **HONEST STATUS: PLANNED, NOT YET BUILT.** `dashboard/` and `screenshots/` are currently empty. Power BI Desktop is a GUI app that can't be driven from an automated coding session, so instead of a live dashboard, a **complete, exact build specification** was written: [docs/10_powerbi_learning.md](../10_powerbi_learning.md). This file teaches that spec page-by-page, as if walking through the finished dashboard — once you build it yourself in Power BI Desktop, update this file to describe the real thing.

## 1. Data Model (as specified)

```
dim_customers (1) ───< fact_campaign_response (many)
dim_customers (1) ───< fact_channel_purchases (many)
```

Same star schema as the SQLite database (Chapter 05) — imported directly from the 3 processed CSVs.

## 2. Planned Pages, Visual By Visual

### Page 1 — Campaign Overview

| Visual | Purpose |
|---|---|
| KPI Cards: Total Customers, Total Revenue, Overall Acceptance Rate | Headline numbers, 2-second read |
| Bar: Acceptance Rate % by campaign | "Which campaign worked?" |
| Bar: ROI % by campaign | Shows every campaign is a loss under the assumption constants |
| Slicer: campaign_name | Isolate one campaign |

**Why this page is first:** matches the "30-second explanation" — scale, then which campaigns work, before drilling deeper.

### Page 2 — Channel Performance

| Visual | Purpose |
|---|---|
| Donut: Channel share % | Store 46.2% / Web 32.5% / Catalog 21.3% |
| Table: avg purchases + zero-purchase count by channel | Surfaces the "26% never use Catalog" finding |

### Page 3 — Customer Segmentation (RFM)

| Visual | Purpose |
|---|---|
| KPI Cards (×4) | Segment sizes |
| Bar: avg spend by segment | Champions highest |
| Pie: revenue share by segment | 24.1% of customers = 49.1% of revenue |
| Bar: acceptance rate by segment | 15.14% vs. 1.43% |
| Scatter: income vs. total_spend, colored by segment | Visual segment separation |

### Page 4 — Funnel & Engagement

| Visual | Purpose |
|---|---|
| Funnel chart | Total → Purchase → Deal → Campaign-accept |
| Table: segment-wise funnel breakdown | Champions 47.8% vs. Lost 7.4% acceptance |

### Page 5 (optional) — Customer Demographics

Education/marital-status/age-band breakdowns.

## 3. Key DAX Measures (planned)

```dax
Total Customers = DISTINCTCOUNT(dim_customers[customer_id])
Total Revenue = SUM(dim_customers[total_spend])
Acceptance Rate % = DIVIDE([Total Campaigns Accepted], [Total Campaigns Targeted], 0)
Campaign Cost = COUNTROWS(fact_campaign_response) * 3      -- Z_CostContact assumption
Campaign Revenue = SUM(fact_campaign_response[accepted]) * 11  -- Z_Revenue assumption
Campaign ROI % = DIVIDE([Campaign Profit], [Campaign Cost], 0)
```

Full measure list (12+ measures) with explanations: [docs/10_powerbi_learning.md](../10_powerbi_learning.md) Section 3.

**Teaching note:** these are the exact same formulas as `sql/08_advanced_analysis.sql`'s CTE chain — DAX is just a different syntax for the identical business logic, recalculated automatically per filter context (e.g., per campaign, when `campaign_name` is on the visual's axis).

## 4. Design Decisions

1. One clear business question per page.
2. KPI cards at top, detail visuals below.
3. Consistent segment colors across pages (matches the notebook's color scheme).
4. Every assumption (like Z_CostContact/Z_Revenue) labeled directly on the visual, not hidden in a tooltip.

## 5. INTERVIEW

**Q: "Dikhao aapka Power BI dashboard."**
> "Abhi tak ye physically Power BI Desktop mein nahi bana hai — maine iska poora build specification likha hai (data model, relationships, 5 pages, har page ke visuals, saare DAX measures), kyunki Power BI Desktop ek Windows GUI app hai jo maine abhi tak khud banana start nahi kiya. Maine ye honestly bataya hai instead of claiming it exists — spec itna detailed hai ki isse follow karke actual dashboard banana ek clear, mechanical process hai."

**Q: "Agar aap ye dashboard abhi banate, sabse pehle kya karte?"**
> "3 processed CSVs import karta, relationships verify karta (Model view), phir Section 3 ke saare measures bana ke, Page 1 (Campaign Overview) se shuru karta — kyunki wahi sabse important business question answer karta hai."

**Q: "Power BI mein 'which campaign is best' kaise dikhaoge, jo SQL/Python se alag ho?"**
> "Underlying logic same hai (`accepted/targeted × 100`) — Power BI ka fayda ye hai ki ek stakeholder khud `campaign_name` slicer click karke, poore page ke saare visuals (KPI cards, bar charts) ko ek saath filter kar sakta hai — SQL query dobara likhne ki zaroorat nahi."

## 6. Common Mistakes

- Dashboard ko "already built" bol dena jab wo actually nahi bana — hamesha honest status batao.
- Har page pe har slicer daal dena — clutter.
- DAX measures ko calculated columns bana dena — dynamic filtering break ho jaati hai.

## 7. What I Should Remember

1. This is a **build spec**, not a built dashboard — always say so honestly if asked.
2. The 5-page plan directly mirrors the SQL/Python analyses already done — nothing new is being invented for Power BI, just re-presented visually.
3. All DAX measures mirror the exact SQL CTE logic from `sql/08_advanced_analysis.sql`.

---
*Next: [21_BUSINESS_INSIGHTS.md](21_BUSINESS_INSIGHTS.md)*
