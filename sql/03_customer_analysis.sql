-- ============================================================
-- 03_customer_analysis.sql
-- Business question: How many customers do we have, and which
-- demographic segments respond better to campaigns?
-- Concepts used: GROUP BY, aggregate functions, JOIN, ROUND
-- ============================================================

-- Query 1: Customer count by Education level (basic GROUP BY, no join needed).
SELECT
    education,
    COUNT(*) AS num_customers,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM dim_customers), 1) AS pct_of_base
FROM dim_customers
GROUP BY education
ORDER BY num_customers DESC;

-- Query 2: Average spend and average income by Marital Status.
SELECT
    marital_status,
    COUNT(*) AS num_customers,
    ROUND(AVG(income), 0) AS avg_income,
    ROUND(AVG(total_spend), 0) AS avg_total_spend
FROM dim_customers
GROUP BY marital_status
ORDER BY avg_total_spend DESC;

-- Query 3: Campaign acceptance rate by Education segment (JOIN across the star schema).
-- NOTE: after the JOIN, COUNT(*) counts (customer x campaign) pairs -- 6 rows per
-- customer, not 1 -- because fact_campaign_response has one row per campaign per
-- customer. This is a classic JOIN "fan-out": always check what COUNT(*) really
-- counts after a one-to-many join, not just what it counted before the join.
SELECT
    d.education,
    COUNT(DISTINCT d.customer_id) AS num_customers,
    SUM(f.accepted) AS total_accepts,
    ROUND(100.0 * SUM(f.accepted) / COUNT(*), 2) AS avg_acceptance_rate_pct
FROM dim_customers d
JOIN fact_campaign_response f ON d.customer_id = f.customer_id
GROUP BY d.education
ORDER BY avg_acceptance_rate_pct DESC;
