# Marketing Intelligence & Campaign Optimization

A reproducible data analytics portfolio project using the iFood Customer Personality dataset. It investigates campaign acceptance, customer segments, sales channels, and customer engagement with Python, SQL, and Power BI.

## Project status

| Area | Status |
|---|---|
| Data cleaning and feature engineering | Implemented and re-run successfully |
| Customer segmentation | Implemented and re-run successfully |
| SQLite star schema and SQL analysis | Implemented; all 24 SQL queries validated |
| Python EDA notebook | Implemented; all 9 code cells execute successfully |
| Power BI report | Build specification is ready; the `.pbix` and exported screenshots still need to be created in Power BI Desktop |
| Optional web presentation | Not in scope |

The Power BI report is the remaining portfolio deliverable. Do not describe it as built until `dashboard/marketing_campaign_dashboard.pbix` and its screenshots exist. Follow [the Power BI build specification](docs/10_powerbi_learning.md).

## Dataset and key findings

- 2,240 source customers; 2,212 remain after documented cleaning.
- The cleaned customer dimension has 2,212 rows; the campaign and channel fact tables have 13,272 and 6,636 rows.
- Six campaigns are analyzed. Campaign costs and campaign revenue use the dataset's `Z_CostContact` and `Z_Revenue` assumption constants; they are estimates, not observed transaction-level ROI.
- Sales channels mean Web, Catalog, and Store purchases—not advertising channels.
- The engagement funnel is explicitly a proxy: monthly website visits and two-year web purchases have different time windows.
- Currency is unspecified by the source; spend is reported in monetary units.

See [the project blueprint](docs/00_project_blueprint.md) for dataset provenance, scope, assumptions, and limitations, and [the business insights](docs/09_business_insights.md) for findings and recommendations.

## Project structure

```text
data/raw/          Source dataset
data/processed/    Cleaned CSVs and SQLite database (generated)
scripts/           Cleaning, segmentation, and SQLite loading scripts
sql/               Eight SQL analysis files
notebooks/         Python EDA notebook
dashboard/         Destination for the Power BI .pbix (not built yet)
screenshots/       Destination for exported dashboard pages (not built yet)
docs/              Project phases, specifications, and learning notes
```

## Reproduce the analysis

From the project root, install the dependencies and run the scripts in order:

```powershell
python -m pip install -r requirements.txt
python scripts/clean_data.py
python scripts/segment_customers.py
python scripts/load_to_sqlite.py
```

This regenerates the processed customer/fact CSVs and `data/processed/marketing_analytics.db`. Run the SQL files against that SQLite database with a SQLite client.

The notebook's data paths are relative to its own folder. Launch it from `notebooks/`:

```powershell
Set-Location notebooks
jupyter notebook 01_marketing_eda.ipynb
```

## Build the Power BI report

Use Power BI Desktop to import the three processed CSVs, create the two customer-to-fact relationships, add the DAX measures, and build the report pages described in [docs/10_powerbi_learning.md](docs/10_powerbi_learning.md). Save the report as `dashboard/marketing_campaign_dashboard.pbix` and export page images to `screenshots/`.

## Documentation

- [Project blueprint](docs/00_project_blueprint.md)
- [Business insights](docs/09_business_insights.md)
- [Power BI build specification](docs/10_powerbi_learning.md)
- [Learning guide index](docs/learning/00_START_HERE.md)
