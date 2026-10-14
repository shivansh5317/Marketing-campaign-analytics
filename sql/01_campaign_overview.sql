-- ============================================================
-- 01_campaign_overview.sql
-- Business question: Which campaigns performed best/worst, and
-- what does our customer/campaign base look like overall?
-- Concepts used: SELECT, scalar subquery, GROUP BY, aggregate
-- functions, ROUND, ORDER BY, LIMIT
-- ============================================================

-- Query 1: Overall scale -- how many customers and campaigns exist?
SELECT
    (SELECT COUNT(*) FROM dim_customers) AS total_customers,
    (SELECT COUNT(DISTINCT campaign_name) FROM fact_campaign_response) AS total_campaigns;

-- Query 2: Acceptance count and rate per campaign, best to worst.
SELECT
    campaign_name,
    SUM(accepted) AS customers_accepted,
    COUNT(*) AS customers_targeted,
    ROUND(100.0 * SUM(accepted) / COUNT(*), 2) AS acceptance_rate_pct
FROM fact_campaign_response
GROUP BY campaign_name
ORDER BY acceptance_rate_pct DESC;

-- Query 3: The single best and single worst campaign by acceptance rate.
SELECT campaign_name, ROUND(100.0 * SUM(accepted) / COUNT(*), 2) AS acceptance_rate_pct
FROM fact_campaign_response
GROUP BY campaign_name
ORDER BY acceptance_rate_pct DESC
LIMIT 1;

SELECT campaign_name, ROUND(100.0 * SUM(accepted) / COUNT(*), 2) AS acceptance_rate_pct
FROM fact_campaign_response
GROUP BY campaign_name
ORDER BY acceptance_rate_pct ASC
LIMIT 1;
