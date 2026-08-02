CREATE TABLE t_michael_zelinka_project_SQL_primary_final AS
WITH payroll_yearly AS (
    SELECT 
        cp.payroll_year AS YEAR,
        cp.industry_branch_code,
        ib.name AS industry_name,
        ROUND(AVG(cp.value)::numeric, 0) AS average_wage
    FROM czechia_payroll cp
    LEFT JOIN czechia_payroll_industry_branch ib ON cp.industry_branch_code = ib.code
    WHERE cp.unit_code = 200     
      AND cp.value_type_code = 595 
      AND cp.calculation_code = 200 
      AND cp.payroll_year IS NOT NULL
    GROUP BY cp.payroll_year, cp.industry_branch_code, ib.name
),
price_yearly AS (
    SELECT 
        date_part('year', cp.date_from)::integer AS YEAR,
        cp.category_code,
        pc.name AS food_name,
        ROUND(AVG(cp.value)::numeric, 2) AS average_price,
        pc.price_value,
        pc.price_unit
    FROM czechia_price cp
    JOIN czechia_price_category pc ON cp.category_code = pc.code
    GROUP BY date_part('year', cp.date_from), cp.category_code, pc.name, pc.price_value, pc.price_unit
)
SELECT 
    COALESCE(p.year, pr.year) AS year,
    p.industry_branch_code,
    p.industry_name,
    p.average_wage,
    pr.category_code,
    pr.food_name,
    pr.average_price,
    pr.price_value,
    pr.price_unit
FROM payroll_yearly p
FULL OUTER JOIN price_yearly pr ON p.year = pr.year;
