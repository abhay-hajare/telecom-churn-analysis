"""
Telecom Churn - Data Cleaning & Feature Engineering (Python)
Input : Telco-Customer-Churn.csv (raw Kaggle download)
Output: telco_churn_clean.csv (ready to load into SQL / Power BI)
"""

import pandas as pd
import numpy as np

# ---------------------------------------------------------
# 1. Load raw data
# ---------------------------------------------------------
df = pd.read_csv("Telco-Customer-Churn.csv")

print("Raw shape:", df.shape)
print(df.dtypes)

# ---------------------------------------------------------
# 2. Fix TotalCharges (imported as text, blanks for tenure=0)
# ---------------------------------------------------------
df["TotalCharges"] = pd.to_numeric(df["TotalCharges"], errors="coerce")
# New customers (tenure = 0) will have NaN here -> fill with 0
df["TotalCharges"] = df["TotalCharges"].fillna(0)

# ---------------------------------------------------------
# 3. Standardize categorical noise
#    ("No internet service" / "No phone service" -> "No")
# ---------------------------------------------------------
cols_to_simplify = [
    "OnlineSecurity", "OnlineBackup", "DeviceProtection",
    "TechSupport", "StreamingTV", "StreamingMovies", "MultipleLines"
]
for col in cols_to_simplify:
    df[col] = df[col].replace(
        {"No internet service": "No", "No phone service": "No"}
    )

# ---------------------------------------------------------
# 4. Binary flags -> clean 0/1 columns (keep original text too)
# ---------------------------------------------------------
binary_map = {"Yes": 1, "No": 0}
df["Churn_Flag"] = df["Churn"].map(binary_map)
df["SeniorCitizen_Flag"] = df["SeniorCitizen"]  # already 0/1 in raw data
df["Partner_Flag"] = df["Partner"].map(binary_map)
df["Dependents_Flag"] = df["Dependents"].map(binary_map)
df["PaperlessBilling_Flag"] = df["PaperlessBilling"].map(binary_map)

# ---------------------------------------------------------
# 5. Feature engineering: tenure buckets (cohort analysis)
# ---------------------------------------------------------
def tenure_bucket(t):
    if t <= 12:
        return "0-12"
    elif t <= 24:
        return "13-24"
    elif t <= 48:
        return "25-48"
    elif t <= 60:
        return "49-60"
    else:
        return "60+"

df["TenureBucket"] = df["tenure"].apply(tenure_bucket)

# ---------------------------------------------------------
# 6. Feature engineering: simulate a signup date
#    (dataset has no real dates - derive one from tenure)
# ---------------------------------------------------------
TODAY = pd.Timestamp("2026-08-30")
df["SignupDate"] = TODAY - pd.to_timedelta(df["tenure"] * 30, unit="D")

# ---------------------------------------------------------
# 7. Feature engineering: CLV estimate + risk flag
# ---------------------------------------------------------
df["CLV_Estimate"] = df["MonthlyCharges"] * df["tenure"]

df["High_Risk_Flag"] = np.where(
    (df["Contract"] == "Month-to-month") &
    (df["tenure"] <= 12) &
    (df["Churn"] == "No"),
    1, 0
)

# ---------------------------------------------------------
# 8. Drop duplicates / sanity checks
# ---------------------------------------------------------
before = len(df)
df = df.drop_duplicates(subset="customerID")
print(f"Dropped {before - len(df)} duplicate customerID rows")

assert df["customerID"].is_unique, "customerID not unique after cleaning!"
assert df["TotalCharges"].isna().sum() == 0, "Nulls remain in TotalCharges!"

# ---------------------------------------------------------
# 9. Export clean file
# ---------------------------------------------------------
df.to_csv("telco_churn_clean.csv", index=False)
print("Cleaned shape:", df.shape)
print("Saved: telco_churn_clean.csv")
