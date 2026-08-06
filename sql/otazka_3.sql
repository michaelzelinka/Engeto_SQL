-- Otázka č. 3: Která kategorie potravin zdražuje nejpomaleji (nejnižší percentuální meziroční nárůst)?
WITH food_prices_yearly AS (
    SELECT 
        year,
        food_name,
        ROUND(AVG(food_price)::numeric, 2) AS average_price
    FROM t_michael_zelinka_project_SQL_primary_final
    WHERE food_name IS NOT NULL
    GROUP BY year, food_name
),
price_growth AS (
    SELECT 
        year,
        food_name,
        average_price,
        LAG(average_price) OVER (PARTITION BY food_name ORDER BY year) AS prev_price
    FROM food_prices_yearly
)
SELECT 
    food_name,
    ROUND(AVG((average_price - prev_price) / prev_price * 100)::numeric, 2) AS avg_yoy_growth_pct
FROM price_growth
WHERE prev_price IS NOT NULL
GROUP BY food_name
ORDER BY avg_yoy_growth_pct ASC;
