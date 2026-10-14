-- ============================================================
-- 06_conversion_analysis.sql
-- Business question: What share of customers convert at all, and
-- who are the "serial responders" vs "never responders"?
-- Concepts used: subquery, GROUP BY + HAVING, CASE WHEN, JOIN
-- ============================================================

-- Query 1: Overall conversion -- % of customers who accepted AT LEAST ONE campaign.
-- (a customer-level subquery collapses the 6 campaign rows per customer first)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN campaigns_accepted > 0 THEN 1 ELSE 0 END) AS converted_customers,
    ROUND(100.0 * SUM(CASE WHEN campaigns_accepted > 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS conversion_rate_pct
FROM (
    SELECT customer_id, SUM(accepted) AS campaigns_accepted
    FROM fact_campaign_response
    GROUP BY customer_id
);

-- Query 2: "Serial responders" -- customers who accepted 2 or more campaigns.
SELECT customer_id, SUM(accepted) AS campaigns_accepted
FROM fact_campaign_response
GROUP BY customer_id
HAVING SUM(accepted) >= 2
ORDER BY campaigns_accepted DESC
LIMIT 10;

-- Query 3: Does recency (days since last purchase) relate to conversion?
SELECT
    CASE
        WHEN d.recency < 25 THEN '1) 0-24 days (very recent)'
        WHEN d.recency < 50 THEN '2) 25-49 days'
        WHEN d.recency < 75 THEN '3) 50-74 days'
        ELSE '4) 75-99 days (least recent)'
    END AS recency_band,
    COUNT(DISTINCT d.customer_id) AS num_customers,
    ROUND(100.0 * SUM(f.accepted) / COUNT(*), 2) AS avg_acceptance_rate_pct
FROM dim_customers d
JOIN fact_campaign_response f ON d.customer_id = f.customer_id
GROUP BY recency_band
ORDER BY recency_band;
