# Telecom Customer Churn Analysis

End-to-end analytics project on why telecom customers leave, using Python, MySQL, Power BI and DAX.

## Dataset
Telco Customer Churn dataset from Kaggle, 7,000+ customer records covering contract type, tenure, services and monthly charges.

## Approach
1. **Python (pandas):** cleaned the data and engineered features. Fixed `TotalCharges` (text with blanks for new customers), standardized categories, created 0/1 flags, tenure buckets, a CLV estimate and a rules-based high-risk flag, and ran sanity checks before export.
2. **MySQL:** modeled the clean data into a star schema (fact and dimension tables).
3. **Power BI and DAX:** built a 5-page interactive report with 17+ DAX measures covering churn rate, revenue impact, customer lifetime value and a retention watchlist.
4. **Validation:** checked key metrics across Python, SQL and DAX before publishing and fixed data-quality issues such as malformed values and type mismatches.

## Key findings
- Month-to-month contracts churn at 15x the rate of two-year contracts (42.7% vs 2.8%).
- Churned customers pay 21% more per month on average than retained customers, but have 67% lower lifetime value.
- The business is losing high-value customers too early, not low-value ones.

## Dashboard

## Repository contents
- `01_clean_data NEW PROJECT TELECOM.py`: data cleaning and feature engineering
- `TELECOM_CHURN.pbix`: Power BI report
- `CHURN.sql`: schema and queries

## Notes
- `SignupDate` is derived from tenure to support cohort analysis, because the raw data has no real dates.
- The high-risk flag marks active month-to-month customers with 12 months of tenure or less.

## Author
Abhay Hajare, [LinkedIn](https://www.linkedin.com/in/abhay-hajare-076ab5260)
