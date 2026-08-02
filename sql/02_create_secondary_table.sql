CREATE TABLE t_michael_zelinka_project_SQL_secondary_final AS
WITH payroll_years AS (
    SELECT 
        MIN(payroll_year) AS min_year, 
        MAX(payroll_year) AS max_year 
    FROM czechia_payroll
)
SELECT 
    c.country,
    e.year,
    e.gdp,
    e.gini,
    e.population
FROM economies e
JOIN countries c ON e.country = c.country
CROSS JOIN payroll_years py
WHERE c.continent = 'Europe' 
  AND e.year BETWEEN py.min_year AND py.max_year;
