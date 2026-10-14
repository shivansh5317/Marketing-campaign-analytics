# 10 — Power BI Build Specification

> ⚠️ **STATUS: PLANNED, NOT YET BUILT.** `dashboard/` and `screenshots/` are currently empty — no `.pbix` file exists yet. Power BI Desktop is a Windows GUI application that cannot be driven from this coding session, so instead of a fabricated "here's our dashboard" writeup, this document is an **exact, page-by-page, visual-by-visual, measure-by-measure build specification** for you to follow yourself in Power BI Desktop. Once built, save the file to `dashboard/marketing_campaign_dashboard.pbix` and export page screenshots into `screenshots/`, then `docs/learning/20_POWER_BI_IN_PROJECT.md` can honestly describe the real, finished dashboard.

Everything in this spec is derived directly from KPIs/logic already verified in Phases 3–9 (nothing new is invented) — Power BI here is just a **new presentation layer** on top of already-correct numbers.

---

## 1. Data Source Setup

1. Open Power BI Desktop → **Get Data → Text/CSV**.
2. Import all 3 processed files (not the raw file):
   - `data/processed/dim_customers.csv`
   - `data/processed/fact_campaign_response.csv`
   - `data/processed/fact_channel_purchases.csv`
3. In **Power Query Editor**, verify data types: `dt_customer` → Date, `income`/`total_spend` → Decimal Number, flags (`complain`, `accepted`) → Whole Number. Power BI usually auto-detects these correctly from the clean CSVs, but always verify — this is the same "check your dtypes" discipline from Phase 1/2.
4. Click **Close & Apply**.

*(Alternative, more advanced option: connect directly to `data/processed/marketing_analytics.db` via an ODBC SQLite driver, so Power BI reads the same database the SQL phase used. Simpler for a first build: just import the 3 CSVs directly, as above.)*

## 2. Data Model — Relationships

Go to the **Model** view and create 2 relationships (Power BI may auto-detect them from matching column names — verify, don't assume):

```
dim_customers[customer_id]  1 ────< many  fact_campaign_response[customer_id]
dim_customers[customer_id]  1 ────< many  fact_channel_purchases[customer_id]
```

Both are **one-to-many**, single direction (dim → fact), same star-schema design already used in SQLite (Phase 4). `dim_customers` is the "1" side (one row per customer, verified unique in Phase 1), the fact tables are the "many" side.

**Common mistake to avoid:** if a relationship shows as inactive (dashed line) or many-to-many, the join column likely has a data-type mismatch (e.g., one side text, one side number) — fix the type in Power Query, not by forcing the relationship.

## 3. DAX Measures to Create

Create these as **Measures** (not calculated columns — measures recalculate dynamically per filter/slicer context, calculated columns don't). Right-click `dim_customers` → **New Measure** for the ones based on it, similarly for the fact tables.

### 3.1 Scale / Overview Measures

```dax
Total Customers = DISTINCTCOUNT(dim_customers[customer_id])

Total Revenue = SUM(dim_customers[total_spend])

Avg Spend per Customer = AVERAGE(dim_customers[total_spend])

Total Campaigns Targeted = COUNTROWS(fact_campaign_response)

Total Campaigns Accepted = SUM(fact_campaign_response[accepted])
```

### 3.2 Campaign Performance Measures (matches `docs/03_marketing_kpis.md` exactly)

```dax
Acceptance Rate % =
DIVIDE([Total Campaigns Accepted], [Total Campaigns Targeted], 0)

Campaign Cost =
COUNTROWS(fact_campaign_response) * 3        -- Z_CostContact = 3 (dataset assumption constant)

Campaign Revenue =
SUM(fact_campaign_response[accepted]) * 11   -- Z_Revenue = 11 (dataset assumption constant)

Campaign Profit = [Campaign Revenue] - [Campaign Cost]

Campaign ROI % = DIVIDE([Campaign Profit], [Campaign Cost], 0)

Customer Acquisition Cost (CAC) =
DIVIDE([Campaign Cost], [Total Campaigns Accepted], 0)
```

**Teaching note:** notice these are the *exact same formulas* as `sql/08_advanced_analysis.sql`'s CTE — just written in DAX instead of SQL. When `Campaign Cost`/`Campaign Revenue`/etc. are placed on a visual grouped by `campaign_name`, Power BI automatically recalculates each measure **per campaign** because of *filter context* — this is DAX's version of `GROUP BY`.

### 3.3 Channel Measures

```dax
Total Channel Purchases = SUM(fact_channel_purchases[num_purchases])

Channel Share % =
DIVIDE(
    [Total Channel Purchases],
    CALCULATE([Total Channel Purchases], ALL(fact_channel_purchases[channel]))
)
```

**Teaching note (important DAX concept):** `ALL(fact_channel_purchases[channel])` removes any existing filter on `channel`, so the `CALCULATE(...)` inside computes the **grand total across all channels** — even while the outer visual is sliced by one channel at a time. This is the DAX equivalent of the subquery-in-denominator pattern from `sql/02_channel_performance.sql` Query 1 (`SELECT SUM(...) FROM fact_channel_purchases` with no `GROUP BY`, used as the % denominator).

### 3.4 Segmentation Measures

```dax
Segment Revenue Share % =
DIVIDE(
    SUM(dim_customers[total_spend]),
    CALCULATE(SUM(dim_customers[total_spend]), ALL(dim_customers[segment]))
)

Segment Acceptance Rate % =
DIVIDE(
    CALCULATE(SUM(fact_campaign_response[accepted])),
    CALCULATE(COUNTROWS(fact_campaign_response))
)
```

(`Segment Acceptance Rate %` relies on the `dim_customers → fact_campaign_response` relationship to filter the fact table by whatever `segment` is on the visual/slicer — same "JOIN then GROUP BY" logic as `sql/03_customer_analysis.sql` Query 3, just automatic via the model relationship instead of an explicit `JOIN`.)

### 3.5 Funnel Measures

```dax
Made Purchase Count = CALCULATE(DISTINCTCOUNT(dim_customers[customer_id]), dim_customers[total_purchases] >= 1)

Used Deal Count = CALCULATE(DISTINCTCOUNT(dim_customers[customer_id]), dim_customers[num_deals_purchases] >= 1)

Accepted Campaign Count = CALCULATE(DISTINCTCOUNT(dim_customers[customer_id]), dim_customers[num_campaigns_accepted] >= 1)
```

---

## 4. Page-by-Page Plan

### Page 1 — Campaign Overview (landing page)

| Visual | Fields | Purpose |
|---|---|---|
| KPI Card | `[Total Customers]` | Baseline scale |
| KPI Card | `[Total Revenue]` | Headline business size |
| KPI Card | `[Acceptance Rate %]` (overall) | Headline campaign performance |
| Clustered Bar Chart | Axis = `campaign_name`, Value = `[Acceptance Rate %]`, sorted descending | Answers "which campaign worked best/worst" (mirrors `sql/01_campaign_overview.sql` Query 2) |
| Clustered Bar Chart | Axis = `campaign_name`, Value = `[Campaign ROI %]` | Shows every campaign is currently a loss under the assumption constants (Insight 2, `docs/09_business_insights.md`) |
| Slicer | `campaign_name` | Lets a viewer isolate one campaign across all visuals on the page |

**Why this page first:** matches the "30-second project explanation" — a stakeholder opening the dashboard should immediately see scale + which campaigns work, before drilling into channels/segments.

### Page 2 — Channel Performance

| Visual | Fields | Purpose |
|---|---|---|
| KPI Card | `[Total Channel Purchases]` | Scale |
| Donut/Pie Chart | Legend = `channel`, Value = `[Total Channel Purchases]` | Visual channel-share-of-total (Store 46.2% / Web 32.5% / Catalog 21.3%) |
| Table | `channel`, `AVERAGE(num_purchases)`, count of zero-purchase customers | Surfaces the "26% never use Catalog" finding (Insight 5) — a table is better than a chart here because 2 different numeric facts need to sit side-by-side per row |
| Slicer | none needed (only 3 channels, visible on one page) | |

### Page 3 — Customer Segmentation (RFM)

| Visual | Fields | Purpose |
|---|---|---|
| KPI Cards (x4) | One per segment, `[Total Customers]` filtered by segment | Segment sizes at a glance |
| Bar Chart | Axis = `segment` (custom sort order: Champions, Loyal, At Risk, Lost), Value = `AVERAGE(total_spend)` | Spend comparison across segments |
| Pie Chart | Legend = `segment`, Value = `[Segment Revenue Share %]` | The "24.1% of customers = 49.1% of revenue" headline (Insight 3) |
| Bar Chart | Axis = `segment`, Value = `[Segment Acceptance Rate %]` | Shows the 15.14% vs 1.43% gap |
| Scatter Chart | X = `income`, Y = `total_spend`, Legend = `segment` | The same scatter built in the Phase 7 notebook, now interactive |
| Slicer | `segment` | Lets the viewer isolate one segment across the whole page |

### Page 4 — Funnel & Engagement

| Visual | Fields | Purpose |
|---|---|---|
| Funnel Chart (built-in Power BI visual) | Stages = `[Total Customers]` → `[Made Purchase Count]` → `[Used Deal Count]` → `[Accepted Campaign Count]` | Direct visual of the 4-stage funnel from `docs/06_funnel_analysis.md` |
| Table | `segment`, `[Made Purchase Count]`, `[Accepted Campaign Count]` (as %) | The segment-wise funnel breakdown (Champions 47.8% vs. Lost 7.4% acceptance) |
| Stacked Bar Chart | `channel`, count of zero-purchase customers vs. active customers | Channel-wise funnel view |

### Page 5 (optional) — Customer Demographics

| Visual | Fields | Purpose |
|---|---|---|
| Bar Chart | `education`, count | Demographic composition |
| Bar Chart | `marital_status`, count | Demographic composition |
| Bar Chart | Age band (needs a calculated column — see below), `AVERAGE(total_spend)` | Age-based spend pattern (Phase 4 SQL finding: 65+ spends most) |

**Note on age bands:** SQL used `CASE WHEN` for this; in Power BI, replicate it with a **calculated column** (not a measure, since it's a per-row label, not an aggregation):
```dax
Age Band =
SWITCH(
    TRUE(),
    dim_customers[age] < 35, "1) Under 35",
    dim_customers[age] < 50, "2) 35-49",
    dim_customers[age] < 65, "3) 50-64",
    "4) 65+"
)
```
This is the direct DAX equivalent of SQL's `CASE WHEN` bucketing (`sql/05_segment_analysis.sql` Query 1) and pandas' manual `pd.cut`/`np.select` approach.

---

## 5. Slicers & Filters — General Guidance

- Put **`segment`** and **`campaign_name`** slicers on the pages where they're relevant, not on every page (avoid clutter — the brief explicitly warns against "overloading dashboards," see `docs/learning/34_COMMON_MISTAKES.md`).
- Use **Sync Slicers** (Power BI feature) if you want one slicer (e.g., segment) to filter multiple pages consistently.
- Prefer **slicers over many small KPI cards** for anything with more than ~4 categories.

## 6. Design Principles to Follow

1. **One clear business question per page** — Page 1 = "which campaigns work," Page 2 = "which channel," Page 3 = "which customers," Page 4 = "where's the drop-off."
2. **KPI cards at the top, detail visuals below** — a viewer should get the headline number in 2 seconds, then drill in.
3. **Consistent color per segment** across every page (e.g., Champions = blue, Loyal = green, At Risk = red, Lost = purple) — matches the color scheme already used in the Phase 7 notebook, for visual consistency between notebook and dashboard.
4. **Label every assumption on the visual itself** — e.g., a text box near the ROI chart noting "*based on dataset's Z_CostContact/Z_Revenue assumption constants*" — do not let a viewer assume these are observed real financials.

---

## 7. What This Spec Deliberately Excludes

- No advanced DAX (time intelligence, `LASTDATE`, complex `CALCULATE` filter stacking) — the dataset has no real campaign-launch dates, so time-series DAX genuinely isn't applicable here (consistent with the blueprint's Section 3.4 limitation).
- No Power BI Service / cloud publishing steps — scope is a local `.pbix` file for a portfolio screenshot, not a deployed report.
- No row-level security — not relevant for a single-analyst portfolio project.

---

## 8. Build Checklist (do this yourself in Power BI Desktop)

- [ ] Import the 3 processed CSVs
- [ ] Verify column data types in Power Query
- [ ] Create the 2 relationships (Model view)
- [ ] Create all measures listed in Section 3
- [ ] Create the `Age Band` calculated column (Section 4, Page 5)
- [ ] Build Pages 1–4 (Page 5 optional) per the tables above
- [ ] Apply consistent segment colors across pages
- [ ] Save as `dashboard/marketing_campaign_dashboard.pbix`
- [ ] Export each page as PNG into `screenshots/`
- [ ] Once done, tell me so `docs/learning/20_POWER_BI_IN_PROJECT.md` can be updated to describe the real, finished dashboard instead of this plan

---
*This completes the Phase 7–10 gap-filling. Next: the full `docs/learning/00_START_HERE.md` → `36_GLOSSARY.md` beginner-to-interview learning notes, grounded in everything verified across Phases 0–9.*
