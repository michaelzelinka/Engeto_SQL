CREATE TABLE t_michael_zelinka_project_SQL_primary_final AS
SELECT 
    cp.payroll_year AS year,
    ib.name AS industry_name,
    cp.value AS wage,
    cp.calculation_code,
    pc.name AS food_name,
    cpr.value AS food_price,
    cpr.date_from
FROM czechia_payroll cp
LEFT JOIN czechia_payroll_industry_branch ib 
    ON cp.industry_branch_code = ib.code
CROSS JOIN czechia_price cpr
JOIN czechia_price_category pc 
    ON cpr.category_code = pc.code
WHERE EXTRACT(YEAR FROM cpr.date_from) = cp.payroll_year
  AND cp.payroll_year BETWEEN 2006 AND 2018;
