-- ============================================================
-- 04_funnel_analysis.sql
-- Business question: Where does customer engagement drop off
-- between visiting the website and actually purchasing?
-- Concepts used: aggregate functions, GROUP BY + HAVING,
-- CASE WHEN (bucketing), JOIN
-- IMPORTANT CAVEAT: num_web_visits_month is a 1-month snapshot,
-- while purchase counts are 2-year cumulative totals. This is a
-- directional engagement proxy, NOT a precise same-window
-- conversion rate. Documented in docs/04_sql_learning.md.
-- ============================================================

-- Query 1: Aggregate visit vs. purchase totals (engagement proxy, caveat above applies).
SELECT
    (SELECT SUM(num_web_visits_month) FROM dim_customers) AS total_monthly_web_visits,
    (SELECT SUM(num_purchases) FROM fact_channel_purchases WHERE channel = 'Web') AS total_web_purchases_2yr;

-- Query 2: Customers with ZERO purchases across all 3 channels combined -- the
-- "fully dropped off" group. GROUP BY + HAVING filters on the aggregated total,
-- which a plain WHERE cannot do (WHERE can't filter on SUM()).
SELECT COUNT(*) AS customers_with_zero_purchases
FROM (
    SELECT customer_id, SUM(num_purchases) AS total_purchases
    FROM fact_channel_purchases
    GROUP BY customer_id
    HAVING SUM(num_purchases) = 0
);

-- Query 3: Does drop-off vary by income segment? (CASE WHEN bucketing + JOIN)
SELECT
    CASE
        WHEN d.income < 35000 THEN '1) Under 35k'
        WHEN d.income < 68000 THEN '2) 35k-68k'
        ELSE '3) 68k+'
    END AS income_band,
    COUNT(DISTINCT d.customer_id) AS num_customers,
    ROUND(AVG(d.num_web_visits_month), 2) AS avg_monthly_web_visits,
    ROUND(AVG(c.num_purchases), 2) AS avg_web_purchases_2yr
FROM dim_customers d
JOIN fact_channel_purchases c ON d.customer_id = c.customer_id AND c.channel = 'Web'
GROUP BY income_band
ORDER BY income_band;
