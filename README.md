# Nashville Housing Data Cleaning Project 🏠🧹

### Project Overview
This project involves a comprehensive data cleaning process of a raw housing dataset containing over 56,000 records. Using **SQL Server (T-SQL)**, I transformed a messy, unformatted dataset into a structured and reliable database ready for analysis.

### Key Technical Challenges & Solutions
* **Data Imputation:** Performed **Self-Joins** and used `ISNULL` to populate missing property addresses based on matching ParcelIDs.
* **Address Parsing:** Utilized `PARSENAME` and `REPLACE` to split multi-part address strings into separate columns (Street, City, State).
* **Data Integrity:** Developed a **CTE** (Common Table Expression) using `ROW_NUMBER()` and `PARTITION BY` to identify and isolate duplicate entries.
* **Standardization:** Normalized boolean values ('Y'/'N' to 'Yes'/'No') and standardized date formats for consistency across the dataset.

### Skills Demonstrated
* Advanced SQL (CTEs, Window Functions, Self-Joins)
* Data Transformation & ETL Logic
* Database Integrity & Quality Control

---
*Created by: Bimal Shahi*
