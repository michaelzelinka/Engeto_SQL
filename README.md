# Engeto_SQL

# Analýza mezd, cen potravin a HDP v České republice

Tento projekt je součástí datové akademie a zaměřuje se na komplexní analýzu vývoje průměrných mezd, cen vybraných potravin a jejich vztahu k HDP v České republice v průběhu let.

---

## Struktura repozitáře

* `sql/`
  * `01_create_primary_table.sql` – Skript pro vytvoření primární tabulky (`t_michael_zelinka_project_SQL_primary_final`).
  * `02_create_secondary_table.sql` – Skript pro vytvoření sekundární tabulky (`t_michael_zelinka_project_SQL_secondary_final`).
  * `03_research_questions.sql` – Kompletní SQL dotazy pro zodpovězení všech 5 výzkumných otázek.
* `README.md` – Průvodní dokumentace k projektu.

---

## Popis dat a tabulek

Projekt pracuje s dvěma hlavními výstupními tabulkami:
1. **Primární tabulka (`t_michael_zelinka_project_SQL_primary_final`)**: Obsahuje propojená data o mezdních odvětvích a cenách potravin za společná srovnatelná období.
2. **Sekundární tabulka (`t_michael_zelinka_project_SQL_secondary_final`)**: Obsahuje doplňující makroekonomická data (HDP, GINI koeficient, populace) pro jednotlivé evropské státy včetně České republiky.

---

## Výzkumné otázky a závěry

### 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
* **Závěr:** Ne, mzdy neklesají ve všech odvětvích rovnoměrně, ale v určitých letech a specifických sektorech dochází k meziročním poklesům (např. vlivem ekonomických cyklů nebo krizí). Drtivá většina odvětví však vykazuje stabilní růst.
* **SQL skript:** Viz část `Otázka č. 1` v souboru `03_research_questions.sql`.

### 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
* **Závěr:** V prvním srovnatelném roce (2006) si obyvatelé mohli za průměrnou mzdu pořídit **1 176 kg chleba** a **1 313 litrů mléka**. V posledním srovnatelném roce (2018) tato kupní síla vzrostla na **1 233 kg chleba** a **1 508 litrů mléka**, což značí, že růst mezd celkově předčil růst cen těchto základních potravin.
* **SQL skript:** Viz část `Otázka č. 2` v souboru `03_research_questions.sql`.

### 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
* **Závěr:** Nejpomaleji zdražující položkou (s nejnižším, případně záporným průměrným ročním tempem růstu) je **Cukr krystalový**, u kterého se v datech projevily výrazné cenové výkyvy a korekce směrem dolů.
* **SQL skript:** Viz část `Otázka č. 3` v souboru `03_research_questions.sql`.

### 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
* **Závěr:** Ano, v průběhu sledovaného období lze identifikovat roky, kdy ceny potravin rostly výrazně rychleji než průměrné mzdy, což dočasně snižovalo reálnou kupní sílu obyvatelstva.
* **SQL skript:** Viz část `Otázka č. 4` v souboru `03_research_questions.sql`.

### 5. Má výška HDP vliv na změny ve mzdách a cenách potravin?
* **Závěr:** Vývoj HDP vykazuje zjevnou provázanost zejména s dynamikou růstu mezd (trh práce reaguje na celkovou výkonnost ekonomiky), zatímco u cen potravin je vliv méně lineární a silněji ovlivněný globálními trhy či zemědělskými faktory ve stejném či následujícím období.
* **SQL skript:** Viz část `Otázka č. 5` v souboru `03_research_questions.sql`.
