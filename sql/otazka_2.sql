-- Otázka č. 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období?
WITH yearly_averages AS (
    SELECT 
        year,
        food_name,
        ROUND(AVG(wage)::numeric, 0) AS avg_wage,
        ROUND(AVG(food_price)::numeric, 2) AS avg_price
    FROM t_michael_zelinka_project_SQL_primary_final
    WHERE food_name IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
      AND year IN (2006, 2018)
    GROUP BY year, food_name
)
SELECT 
    year,
    food_name,
    avg_wage,
    avg_price,
    ROUND((avg_wage / avg_price)::numeric, 0) AS units_purchased
FROM yearly_averages
