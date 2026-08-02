-- Otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
WITH wage_by_industry AS (
    SELECT 
        cp.payroll_year AS year,
        ib.name AS industry_name,
        ROUND(AVG(cp.value)::numeric, 0) AS average_wage
    FROM czechia_payroll cp
    JOIN czechia_payroll_industry_branch ib ON cp.industry_branch_code = ib.code
    WHERE cp.payroll_year IS NOT NULL
      AND ib.name IS NOT NULL
    GROUP BY cp.payroll_year, ib.name
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



--Otázka č. 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
WITH yearly_wages AS (
    SELECT 
        payroll_year AS year,
        ROUND(AVG(value)::numeric, 0) AS avg_wage
    FROM czechia_payroll
    WHERE payroll_year IN (2006, 2018)
    GROUP BY payroll_year
),
yearly_prices AS (
    SELECT 
        EXTRACT(YEAR FROM cp.date_from)::integer AS year,
        pc.name AS food_name,
        ROUND(AVG(cp.value)::numeric, 2) AS avg_price
    FROM czechia_price cp
    JOIN czechia_price_category pc ON cp.category_code = pc.code
    WHERE pc.name IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
      AND EXTRACT(YEAR FROM cp.date_from) IN (2006, 2018)
    GROUP BY EXTRACT(YEAR FROM cp.date_from), pc.name
)
SELECT 
    p.year,
    p.food_name,
    w.avg_wage,
    p.avg_price,
    ROUND((w.avg_wage / p.avg_price)::numeric, 0) AS units_purchased
FROM yearly_prices p
JOIN yearly_wages w ON p.year = w.year
ORDER BY p.food_name, p.year;

--Otázka č. 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
WITH food_prices_yearly AS (
    SELECT DISTINCT 
        EXTRACT(YEAR FROM cp.date_from)::integer AS year,
        pc.name AS food_name,
        ROUND(AVG(cp.value)::numeric, 2) AS average_price
    FROM czechia_price cp
    JOIN czechia_price_category pc ON cp.category_code = pc.code
    WHERE pc.name IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM cp.date_from), pc.name
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

--Otázka č. 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
WITH yearly_wages AS (
    SELECT 
        payroll_year AS year,
        AVG(value) AS overall_wage
    FROM czechia_payroll
    GROUP BY payroll_year
),
yearly_prices AS (
    SELECT 
        EXTRACT(YEAR FROM date_from)::integer AS year,
        AVG(value) AS overall_price
    FROM czechia_price
    GROUP BY EXTRACT(YEAR FROM date_from)
),
combined_yearly AS (
    SELECT 
        COALESCE(w.year, p.year) AS year,
        w.overall_wage,
        p.overall_price
    FROM yearly_wages w
    FULL OUTER JOIN yearly_prices p ON w.year = p.year
),
growth_calc AS (
    SELECT 
        year,
        overall_wage,
        LAG(overall_wage) OVER (ORDER BY year) AS prev_wage,
        overall_price,
        LAG(overall_price) OVER (ORDER BY year) AS prev_price
    FROM combined_yearly
)
SELECT 
    year,
    ROUND(((overall_wage - prev_wage) / prev_wage * 100)::numeric, 2) AS wage_growth_pct,
    ROUND(((overall_price - prev_price) / prev_price * 100)::numeric, 2) AS price_growth_pct,
    ROUND((((overall_price - prev_price) / prev_price * 100) - ((overall_wage - prev_wage) / prev_wage * 100))::numeric, 2) AS diff_price_minus_wage
FROM growth_calc
WHERE prev_wage IS NOT NULL AND prev_price IS NOT NULL
ORDER BY year;

--Otázka č. 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
WITH czech_gdp AS (
    SELECT 
        year, 
        gdp,
        LAG(gdp) OVER (ORDER BY year) AS prev_gdp
    FROM t_michael_zelinka_project_SQL_secondary_final
    WHERE country = 'Czech Republic'
),
yearly_averages AS (
    SELECT 
        payroll_year AS year,
        AVG(value) AS avg_wage
    FROM czechia_payroll
    GROUP BY payroll_year
),
yearly_prices AS (
    SELECT 
        EXTRACT(YEAR FROM date_from)::integer AS year,
        AVG(value) AS avg_price
    FROM czechia_price
    GROUP BY EXTRACT(YEAR FROM date_from)
)
SELECT 
    g.year,
    g.gdp,
    ROUND(((g.gdp - g.prev_gdp) / g.prev_gdp * 100)::numeric, 2) AS gdp_growth_pct,
    ROUND(ya.avg_wage::numeric, 0) AS avg_wage,
    ROUND(yp.avg_price::numeric, 2) AS avg_price
FROM czech_gdp g
LEFT JOIN yearly_averages ya ON g.year = ya.year
LEFT JOIN yearly_prices yp ON g.year = yp.year
ORDER BY g.year;
