-- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
WITH czech_gdp AS (
    SELECT 
        year, 
        gdp,
        LAG(gdp) OVER (ORDER BY year) AS prev_gdp
    FROM t_michael_zelinka_project_SQL_secondary_final
    WHERE country = 'Czech Republic'
),
czech_economy_averages AS (
    SELECT 
        year,
        AVG(wage) AS avg_wage,
        AVG(food_price) AS avg_price
    FROM t_michael_zelinka_project_SQL_primary_final
    GROUP BY year
)
SELECT 
    g.year,
    g.gdp,
    ROUND(((g.gdp - g.prev_gdp) / g.prev_gdp * 100)::numeric, 2) AS gdp_growth_pct,
    ROUND(e.avg_wage::numeric, 0) AS avg_wage,
    ROUND(e.avg_price::numeric, 2) AS avg_price
FROM czech_gdp g
LEFT JOIN czech_economy_averages e ON g.year = e.year
ORDER BY g.year;
