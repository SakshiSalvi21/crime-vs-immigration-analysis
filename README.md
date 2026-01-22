# Crime vs Immigration Trend Analysis (Ontario)

## Overview
This project explores trends between reported crime incidents and immigration levels across five major regions in Ontario using publicly available datasets from Statistics Canada. The objective is to apply SQL-driven exploratory data analysis to identify patterns, regional differences, and year-over-year changes, while clearly distinguishing correlation from causation.

This project demonstrates end-to-end analytics skills including data cleaning, relational modeling, multi-table SQL querying, aggregation, and visualization for insight communication.

---

## Business & Analytical Objective
- Analyze reported crime volumes and immigration counts across selected Ontario cities
- Identify year-over-year trends in crime and immigration levels
- Compare regional crime distribution and contribution by city
- Normalize crime metrics using rate-per-100,000 population
- Explore potential relationships while documenting analytical limitations

---

## Data Sources
- **Crime Data:** Statistics Canada – Police-reported crime incidents by region and violation type  
- **Immigration Data:** Statistics Canada – Immigration counts by year and region  

All datasets were publicly available and were cleaned and standardized prior to analysis.

---

## Data Preparation & Modeling
- Cleaned raw datasets to remove nulls, special characters, and inconsistent data types
- Standardized column names for consistency and query performance
- Designed a relational schema to link crime, immigration, violation types, statistics, and city-level data
- Created parent-child table relationships to support scalable querying
- Built SQL views for reusable analysis and summary reporting

---

## Key Analytical Techniques
- Multi-table joins across crime, immigration, violation, and city tables
- Common Table Expressions (CTEs) for modular analysis
- Aggregations and groupings for city-level and year-level summaries
- CASE statements to categorize crime volume levels
- Window functions for cumulative trend analysis
- Normalization using rate-per-100,000 population metrics

---

## Key Findings (High-Level)
- Crime incidents increased modestly (~6%) year-over-year between 2022 and 2023
- Immigration levels increased significantly (~45%) over the same period
- Crime volume is highly concentrated in larger urban regions
- Normalized crime rates provide better comparison across regions than raw counts
- No direct causal relationship was identified; results reflect correlation-based trend analysis only

---

## Visualizations & Reporting
The project includes visualizations to support analytical findings:
- City-level crime contribution analysis
- Crime trends by violation type
- Year-over-year crime and immigration comparison
- Normalized crime rate analysis
- Cumulative crime trend reporting

Visuals were used to support stakeholder-style interpretation and executive-level summaries.

---

## Limitations & Assumptions
- Analysis is limited to available public datasets for 2022–2023
- Crime and immigration data may be influenced by reporting practices and classification changes
- Correlation analysis does not imply causation
- Population density, enforcement policies, and reporting standards may affect observed patterns

Future work could include regression modeling, additional years of data, and population-adjusted demographic analysis.

---

## Tools & Technologies
- SQL (PostgreSQL / ANSI SQL style)
- Relational database design & ERD
- Excel (data review & validation)
- Data visualization tools (for reporting outputs)

---

## Skills Demonstrated
- Exploratory data analysis (EDA)
- Relational data modeling
- Advanced SQL querying
- Trend and contribution analysis
- Data validation and normalization
- Insight communication and documentation
- Responsible interpretation of analytical results

---

## Project Structure
- `/ERD and Table`
- `/Queries` – SQL scripts and views
- `/Report` – Project documentation (Charts, reporting outputs, and schema)

---

## About
This project was completed as part of academic and portfolio development to demonstrate applied SQL analytics, data modeling, and insight generation using real-world public datasets.

## License
MIT License
