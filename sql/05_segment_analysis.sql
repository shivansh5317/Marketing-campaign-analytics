-- ============================================================
-- 05_segment_analysis.sql
-- Business question: What simple, explainable customer segments
-- can we build from demographics (no ML/clustering)?
-- Concepts used: CASE WHEN, GROUP BY, aggregate functions
-- ============================================================

-- Query 1: Age-band segments.
SELECT
    CASE
        WHEN age < 35 THEN '1) Under 35'
        WHEN age < 50 THEN '2) 35-49'
        WHEN age < 65 THEN '3) 50-64'
        ELSE '4) 65+'
    END AS age_band,
    COUNT(*) AS num_customers,
    ROUND(AVG(total_spend), 0) AS avg_total_spend
FROM dim_customers
GROUP BY age_band
ORDER BY age_band;

-- Query 2: Family-size segment ("has kids at home" vs not).
SELECT
    CASE WHEN total_children = 0 THEN 'No kids at home' ELSE 'Has kids at home' END AS family_segment,
    COUNT(*) AS num_customers,
    ROUND(AVG(total_spend), 0) AS avg_total_spend,
    ROUND(AVG(num_deals_purchases), 2) AS avg_deal_purchases
FROM dim_customers
GROUP BY family_segment;

-- Query 3: Combined Income x Family segment -> average spend (a simple 2-dimension segment grid).
SELECT
    CASE WHEN income < 51500 THEN 'Lower Income' ELSE 'Higher Income' END AS income_segment,
    CASE WHEN total_children = 0 THEN 'No Kids' ELSE 'Has Kids' END AS family_segment,
    COUNT(*) AS num_customers,
    ROUND(AVG(total_spend), 0) AS avg_total_spend
FROM dim_customers
GROUP BY income_segment, family_segment
ORDER BY avg_total_spend DESC;
