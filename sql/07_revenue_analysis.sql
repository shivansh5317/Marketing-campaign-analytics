-- ============================================================
-- 07_revenue_analysis.sql
-- Business question: Which segments drive the most revenue, and
-- do campaign responders actually spend more than non-responders?
-- Concepts used: GROUP BY, aggregate functions, ORDER BY + LIMIT,
-- subquery, JOIN
-- ============================================================

-- Query 1: Total and average revenue (total_spend) by Education segment.
SELECT
    education,
    COUNT(*) AS num_customers,
    SUM(total_spend) AS total_revenue,
    ROUND(100.0 * SUM(total_spend) / (SELECT SUM(total_spend) FROM dim_customers), 1) AS pct_of_total_revenue
FROM dim_customers
GROUP BY education
ORDER BY total_revenue DESC;

-- Query 2: Top 10 highest-spending customers (a real, simple ranking with ORDER BY + LIMIT).
SELECT customer_id, education, marital_status, income, total_spend
FROM dim_customers
ORDER BY total_spend DESC
LIMIT 10;

-- Query 3: Do campaign responders actually spend more than non-responders?
-- (real revenue comparison -- separate from the Z_Revenue campaign-cost assumption)
SELECT
    CASE WHEN sub.campaigns_accepted > 0 THEN 'Responder (1+ campaigns)' ELSE 'Never Responded' END AS responder_group,
    COUNT(*) AS num_customers,
    ROUND(AVG(d.total_spend), 0) AS avg_total_spend
FROM dim_customers d
JOIN (
    SELECT customer_id, SUM(accepted) AS campaigns_accepted
    FROM fact_campaign_response
    GROUP BY customer_id
) sub ON d.customer_id = sub.customer_id
GROUP BY responder_group;
