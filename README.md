# Energy Grid Analytics & Data Modeling

An end-to-end SQL and Power BI project analyzing energy consumption, cost, and solar efficiency across a simulated portfolio of commercial facilities.

## Business Context

A portfolio of facilities draws power from two sources: the National Grid and on-site Solar Arrays. Grid prices fluctuate daily. This project analyzes raw meter readings, calculates financial costs, and transforms the data into a reporting layer for a BI team to build dashboards on.

## What This Project Covers

- **Database design** — built the schema and relationships in MySQL (facilities, grid pricing, daily readings)
- **Exploratory SQL analysis** — total consumption, top consumer identification, solar efficiency by facility
- **Window functions** — used `AVG() OVER()` to calculate a 3-day rolling average of energy consumption, smoothing daily volatility into a clearer trend
- **CTEs** — used to join and pre-aggregate readings with daily grid pricing before calculating cost
- **Data modeling** — created a consolidated SQL view (`vw_daily_energy_financials`) with a `CASE`-based flag, ready for BI tools to connect to
- **Power BI dashboard** — recreated the analysis visually, including rebuilding the rolling average using DAX (`AVERAGEX` + `DATESINPERIOD`)

## Key Findings

- **Kano Plant** is the largest energy consumer in the portfolio (4,685 kWh) but has the lowest solar efficiency (3.3%) — the facility spending the most is also benefiting least from solar.
- **Abuja Branch**, despite using far less total energy, has the highest solar efficiency at 40%.
- Total grid cost across the portfolio was **≈₦745,350** over the recorded period, with Kano Plant responsible for over 40% of that spend.
- The 3-day rolling average for Lagos HQ smoothed daily swings of 430–480 kWh into a steady band of roughly 451–465 kWh, revealing a clearer underlying baseline than the raw daily numbers show.

- Recommendation

Kano Plant should be the priority target for solar investment. It is both the largest energy consumer and the largest single driver of grid cost in the portfolio, yet has the lowest solar utilization at just 3.3%. Even a modest increase in solar capacity here — closer to the levels already achieved at Abuja Branch (40%) — would likely produce the largest absolute cost savings of any facility in the portfolio, simply because of the scale of its consumption. Facilities like Abuja Branch, by contrast, have already captured most of their available solar upside and offer less room for incremental gains.

## A Note on Debugging

While rebuilding the rolling average in Power BI, the DAX measure initially returned raw daily values instead of an actual rolling average. The root cause was that DAX time-intelligence functions like `DATESINPERIOD` require a dedicated Date table with one row per date — the fact table's date column had multiple rows per date (one per facility), which was silently breaking the calculation. Fixing this required creating a proper `CALENDAR()`-based Date table, marking it as a date table, and relating it to the fact table.

## Files

- `create_table.sql` — schema and sample data setup
- `analysis.sql` — all SQL queries across Phases 1–3, with corrections applied
- Dashboard screenshot included below

## Tools Used

MySQL, SQL (CTEs, Window Functions, Views), Power BI, DAX
