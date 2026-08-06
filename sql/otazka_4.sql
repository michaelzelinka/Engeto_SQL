-- Otázka č. 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (> 10 %)?
WITH yearly_overall AS (
    SELECT 
        year,
        AVG(wage) AS overall_wage,
        AVG(food_price) AS overall_price
    FROM t_michael_zelinka_project_SQL_primary_final
    GROUP BY year
),
growth_calc AS (
    SELECT 
        year,
        overall_wage,
        LAG(overall_wage) OVER (ORDER BY year) AS prev_wage,
        overall_price,
        LAG(overall_price) OVER (ORDER BY year) AS prev_price
    FROM yearly_overall
)
SELECT 
    year,
    ROUND(((overall_wage - prev_wage) / prev_wage * 100)::numeric, 2) AS wage_growth_pct,
    ROUND(((overall_price - prev_price) / prev_price * 100)::numeric, 2) AS price_growth_pct,
    ROUND((((overall_price - prev_price) / prev_price * 100) - ((overall_wage - prev_wage) / prev_wage * 100))::numeric, 2) AS diff_price_minus_wage
FROM growth_calc
WHERE prev_wage IS NOT NULL AND prev_price IS NOT NULL
ORDER BY year;
