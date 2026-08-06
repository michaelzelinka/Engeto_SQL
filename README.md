# Analýza mezd, cen potravin a HDP v České republice

Tento projekt je součástí datové akademie a zaměřuje se na komplexní analýzu vývoje průměrných mezd, cen vybraných potravin a jejich vztahu k HDP v České republice. Cílem je propojení databázových tabulek pomocí SQL a následná interpretace vybraných makroekonomických a sociálních ukazatelů.

---

## Struktura repozitáře

Projekt je pro lepší přehlednost a modularitu rozdělen do samostatných skriptů ve složce `sql/`:

* `sql/`
  * `01_create_primary_table.sql` – Skript pro vytvoření sjednocené primární tabulky mezd a cen potravin v ČR.
  * `02_create_secondary_table.sql` – Skript pro vytvoření sekundární tabulky makroekonomických ukazatelů evropských států.
  * `03_research_questions.sql` – Sada SQL dotazů odpovídajících na 5 výzkumných otázek (čerpajících výhradně z vytvořených tabulek).
* `README.md` – Průvodní dokumentace k projektu.

---

## Popis dat a výstupních tabulek

V databázi byly vytvořeny dvě hlavní tabulky splňující kritéria zadání:

1. **Primární tabulka (`t_michael_zelinka_project_SQL_primary_final`)**:
   * Obsahuje propojená data o mzdách v jednotlivých odvětvích a cenách potravin za Českou republiku.
   * Časové období je sjednoceno na společné roky **2006–2018**.
   * Díky detailnímu propojení (odvětví mezd × kategorie a regiony cen potravin) čítá tabulka **3 469 680 řádků**, což zajišťuje komplexní podklad pro analýzu kupní síly a vývoje cen.

2. **Sekundární tabulka (`t_michael_zelinka_project_SQL_secondary_final`)**:
   * Obsahuje doplňující makroekonomická data (HDP, GINI koeficient, populace) pro evropské státy.
   * Dle zadání je přísně omezena na stejné časové období **2006–2018** a obsahuje celkem **585 záznamů** (odpovídá evropským státům a 13 sledovaným letům).

---

## Výzkumné otázky a závěry

### 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
* **Závěr:** Mzdy nerostou rovnoměrně ve všech odvětvích lineárně. V průběhu sledovaného období (zejména v krizových letech nebo při korekcích trhu) lze v některých specifických odvětvích identifikovat meziroční poklesy (záporný `yoy_growth_pct`). Drtivá většina sektorů však dlouhodobě vykazuje stabilní mzdový růst.
* **SQL implementace:** Dotaz využívá okenní funkci `LAG()` nad primární tabulkou k výpočtu meziročního procentuálního růstu mezd pro každé odvětví zvlášť.

### 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
* **Závěr:** 
  * V roce **2006** si obyvatelé mohli za průměrnou mzdu pořídit přibližně **1 233 kg chleba** a **1 508 litrů mléka** (hodnoty se mírně liší dle průměrů konkrétních kategorií).
  * V roce **2018** se kupní síla zvýšila na **přes 1 300 kg chleba** a **více než 1 600 litrů mléka**, což dokazuje, že celkový růst mezd v tomto období předčil tempo růstu cen těchto dvou základních potravin.
* **SQL implementace:** Agregace průměrných mezd a cen vybraných potravin (`Chléb konzumní kmínový`, `Mléko polotučné pasterované`) pro roky 2006 a 2018 s následným podílem (`wage / price`).

### 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
* **Závěr:** Nejmenší průměrné meziroční tempo růstu (případně dlouhodobou stagnaci či pokles) vykazují položky zasažené silnými výkyvy na komoditních trzích, jako je např. **Cukr krystalový**, u kterého se po prudkých skocích objevovaly výrazné cenové korekce směrem dolů.
* **SQL implementace:** Výpočet meziročních rozdílů cen pro každou kategorii zvlášť a seřazení od nejnižšího průměrného tempa růstu (`ASC`).

### 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
* **Závěr:** Ano, ve sledovaném období lze identifikovat roky (např. v období kolem roku 2008), kdy ceny potravin zaznamenaly skokový nárůst, který dočasně výrazně převýšil růst mezd, což vedlo k dočasnému snížení reálné kupní síly obyvatelstva.
* **SQL implementace:** Srovnání celkových ročních průměrů mezd a cen potravin, výpočet meziročních nárůstů obou veličin a jejich vzájemného rozdílu pomocí `LAG()`.

### 5. Má výška HDP vliv na změny ve mzdách a cenách potravin?
* **Závěr:** Analýza potvrzuje, že vývoj HDP má zjevnou provázanost zejména s dynamikou růstu mezd (trh práce reaguje na celkový výkon ekonomiky s mírnou setrvačností). U cen potravin je vliv HDP méně přímočarý, protože ceny potravin jsou silně ovlivněny i externími faktory, globálními komoditními trhy a úrodou.
* **SQL implementace:** Propojení HDP z České republiky v sekundární tabulce s ročními průměry mezd a cen z primární tabulky pomocí `LEFT JOIN` a sledování meziročního růstu HDP (`gdp_growth_pct`).
