-- ============================================================
-- 08_advanced_analysis.sql
-- Business question: Which campaign is truly most profitable, and
-- who are our top-value customers?
-- Concepts used: CTE (WITH), window functions (RANK, NTILE) --
-- used only because they give a real analytical answer that a
-- plain GROUP BY cannot (ranking / percentile bucketing).
-- ============================================================

-- Query 1: Full campaign profitability using the dataset's cost/revenue
-- assumption constants (Z_CostContact=3, Z_Revenue=11), built with a
-- 2-step CTE for readability -- this reproduces the Phase 3 KPI table
-- entirely in SQL, as a cross-check against the Python numbers.
WITH campaign_stats AS (
    SELECT
        campaign_name,
        COUNT(*) AS customers_targeted,
        SUM(accepted) AS customers_accepted
    FROM fact_campaign_response
    GROUP BY campaign_name
),
campaign_financials AS (
    SELECT
        campaign_name,
        customers_accepted,
        customers_targeted * 3 AS cost,
        customers_accepted * 11 AS revenue
    FROM campaign_stats
)
SELECT
    campaign_name,
    customers_accepted,
    cost,
    revenue,
    revenue - cost AS profit,
    ROUND(100.0 * (revenue - cost) / cost, 1) AS roi_pct,
    ROUND(1.0 * cost / customers_accepted, 2) AS cac
FROM campaign_financials
ORDER BY roi_pct DESC;

-- Query 2: Rank campaigns by ROI using a window function (RANK does not
-- collapse rows like GROUP BY -- it keeps every row and just labels its rank).
WITH campaign_roi AS (
    SELECT
        campaign_name,
        ROUND(100.0 * (SUM(accepted) * 11 - COUNT(*) * 3) / (COUNT(*) * 3), 1) AS roi_pct
    FROM fact_campaign_response
    GROUP BY campaign_name
)
SELECT
    campaign_name,
    roi_pct,
    RANK() OVER (ORDER BY roi_pct DESC) AS roi_rank
FROM campaign_roi;

-- Query 3: Split customers into 10 equal-sized spend groups (deciles) with
-- NTILE, to find the top-10%-by-spend threshold for a VIP targeting list.
WITH ranked_customers AS (
    SELECT
        customer_id,
        total_spend,
        NTILE(10) OVER (ORDER BY total_spend DESC) AS spend_decile
    FROM dim_customers
)
SELECT
    spend_decile,
    COUNT(*) AS num_customers,
    MIN(total_spend) AS min_spend_in_decile,
    MAX(total_spend) AS max_spend_in_decile
FROM ranked_customers
GROUP BY spend_decile
ORDER BY spend_decile;
