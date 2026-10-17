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
**Overview:** 7,043 customers, 26.54% churn, $47.79K monthly revenue at risk.
<img width="800" alt="Overview" src="https://github.com/user-attachments/assets/9b7e96e7-c03a-4ce5-92ef-c354138efe2b" />

**Churn Drivers:** Month-to-month contracts churn at 42.7% vs 2.8% for two-year contracts (shown rounded on the dashboard as 0.43 vs 0.03).
<img width="800" alt="Churn drivers dashboard" src="https://github.com/user-attachments/assets/323b4545-7c1a-47b6-8b88-0d0eb74dc447" />

**Segmentation:** Churn rate and customer counts by senior citizen, dependents, partner and tenure.
<img width="800" alt="Segmentation" src="https://github.com/user-attachments/assets/b4617ad3-7662-4e9d-94ec-fb5a01654203" />

**Revenue Impact:** Churned revenue by tech support, payment method, contract and internet service.
<img width="800"  alt="Revenue Impact" src="https://github.com/user-attachments/assets/b1c44b96-e740-42d2-9953-605b6d32346f" />

970 high-risk customers, $47.79K monthly revenue at risk and the customer-level watchlist.
<img width="800"  alt="At Risk Watchlist" src="https://github.com/user-attachments/assets/530c2d47-ce30-4468-9722-d59795cd7086" />



## Repository contents
- `01_clean_data NEW PROJECT TELECOM.py`: data cleaning and feature engineering
- `TELECOM_CHURN.pbix`: Power BI report
- `CHURN.sql`: schema and queries

## Notes
- `SignupDate` is derived from tenure to support cohort analysis, because the raw data has no real dates.
- The high-risk flag marks active month-to-month customers with 12 months of tenure or less.

## Author
Abhay Hajare, [LinkedIn](https://www.linkedin.com/in/abhay-hajare-076ab5260)
