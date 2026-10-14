-- ============================================================
-- 02_channel_performance.sql
-- Business question: Which sales channel (Web/Catalog/Store) is
-- doing the most work, and how efficient is each one?
-- Concepts used: GROUP BY, aggregate functions, ROUND, subquery
-- for percentage-of-total, ORDER BY
-- ============================================================

-- Query 1: Total purchases and share % by channel.
SELECT
    channel,
    SUM(num_purchases) AS total_purchases,
    ROUND(100.0 * SUM(num_purchases) / (SELECT SUM(num_purchases) FROM fact_channel_purchases), 1) AS channel_share_pct
FROM fact_channel_purchases
GROUP BY channel
ORDER BY total_purchases DESC;

-- Query 2: Average purchases per customer, by channel (efficiency per customer touched).
SELECT
    channel,
    ROUND(AVG(num_purchases), 2) AS avg_purchases_per_customer,
    SUM(CASE WHEN num_purchases = 0 THEN 1 ELSE 0 END) AS customers_with_zero_purchases
FROM fact_channel_purchases
GROUP BY channel
ORDER BY avg_purchases_per_customer DESC;
