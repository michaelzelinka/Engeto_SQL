-- Otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

WITH wage_by_industry AS (
    SELECT 
        year,
        industry_name,
        ROUND(AVG(wage)::numeric, 0) AS average_wage
    FROM t_michael_zelinka_project_SQL_primary_final
    WHERE industry_name IS NOT NULL
      AND wage IS NOT NULL
    GROUP BY year, industry_name
),
wage_growth AS (
    SELECT 
        year,
        industry_name,
        average_wage,
        LAG(average_wage) OVER (PARTITION BY industry_name ORDER BY year) AS prev_year_wage
    FROM wage_by_industry
)
SELECT 
    year,
    industry_name,
    average_wage,
    prev_year_wage,
    ROUND(((average_wage - prev_year_wage) / prev_year_wage * 100)::numeric, 2) AS yoy_growth_pct
FROM wage_growth
WHERE prev_year_wage IS NOT NULL
ORDER BY yoy_growth_pct ASC;
