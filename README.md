# 🏦 Bank Customer Churn Analysis

**An end-to-end data analytics project using SQL, Python, and Power BI to uncover why customers leave a bank — and what to do about it.**

!\[SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?style=flat-square\&logo=mysql\&logoColor=white)
!\[Python](https://img.shields.io/badge/Python-Pandas%20%7C%20SciPy-3776AB?style=flat-square\&logo=python\&logoColor=white)
!\[Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=flat-square\&logo=powerbi\&logoColor=black)
!\[Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat-square)

\---

## 📌 Business Question

> \\\*Why are bank customers churning, and where should retention efforts be focused?\\\*

Customer churn directly impacts revenue and acquisition cost. This project analyzes \~10,000 customer records to identify **who** is churning, **why**, and to deliver a **data-backed recommendation** a retention team could act on immediately.

\---

## 🧰 Tech Stack

|Layer|Tool|Purpose|
|-|-|-|
|Data storage \& aggregation|**MySQL**|Business-question-driven SQL queries|
|Statistical validation|**Python** (pandas, scipy)|Chi-Square tests to confirm findings are real, not random|
|Visualization|**Matplotlib / Seaborn**|Exploratory churn-rate charts|
|Dashboard|**Power BI**|Interactive, stakeholder-facing dashboard|

\---

## 🗂️ Dataset

* **Source:** Bank Customer Churn Dataset (Kaggle)
* **Size:** 10,000 customer records, 12 columns
* **Key fields:** `country`, `age`, `balance`, `products\\\_number`, `active\\\_member`, `credit\\\_score`, `estimated\\\_salary`, `churn`

\---

## 🔍 Methodology

### 1️⃣ SQL — Business-Question Analysis (MySQL)

Started with the strongest signal in the data and worked outward.

```sql
-- Overall churn rate: the baseline every other number is compared against
SELECT 
    ROUND(SUM(churn) / COUNT(\\\*) \\\* 100, 2) AS churn\\\_rate\\\_percent
FROM customers;
-- Result: 20.37%
```

```sql
-- Churn rate by country
SELECT 
    country,
    COUNT(\\\*) AS total\\\_customers,
    SUM(churn) AS churned\\\_customers,
    ROUND(SUM(churn) / COUNT(\\\*) \\\* 100, 2) AS churn\\\_rate\\\_percent
FROM customers
GROUP BY country
ORDER BY churn\\\_rate\\\_percent DESC;
```

```sql
-- Churn rate by activity status
SELECT 
    active\\\_member,
    COUNT(\\\*) AS total\\\_customers,
    ROUND(SUM(churn) / COUNT(\\\*) \\\* 100, 2) AS churn\\\_rate\\\_percent
FROM customers
GROUP BY active\\\_member;
```

```sql
-- Churn rate by number of products held
SELECT 
    products\\\_number,
    COUNT(\\\*) AS total\\\_customers,
    ROUND(SUM(churn) / COUNT(\\\*) \\\* 100, 2) AS churn\\\_rate\\\_percent
FROM customers
GROUP BY products\\\_number
ORDER BY products\\\_number;
```

```sql
-- Compound risk segment: country + activity status combined
SELECT 
    country,
    active\\\_member,
    COUNT(\\\*) AS total\\\_customers,
    SUM(churn) AS churned,
    ROUND(SUM(churn) / COUNT(\\\*) \\\* 100, 2) AS churn\\\_rate\\\_percent
FROM customers
GROUP BY country, active\\\_member
ORDER BY churn\\\_rate\\\_percent DESC;
-- Highest-risk segment found: Inactive customers in Germany → 41.08% churn
```

### 2️⃣ Python — Statistical Validation

A pattern in a bar chart isn't proof. Every SQL finding was tested with a **Chi-Square test of independence** to confirm it wasn't due to chance.

```python
import pandas as pd
from scipy.stats import chi2\\\_contingency

df = pd.read\\\_csv('bank\\\_customer.csv')

# Country vs Churn
contingency\\\_country = pd.crosstab(df\\\['country'], df\\\['churn'])
chi2, p\\\_value, dof, expected = chi2\\\_contingency(contingency\\\_country)
print(f"Chi-square: {chi2:.2f}, P-value: {p\\\_value:.10f}")
# Chi-square: 301.26, p < 0.001 → statistically significant

# Products held vs Churn
contingency\\\_products = pd.crosstab(df\\\['products\\\_number'], df\\\['churn'])
chi2\\\_p, p\\\_value\\\_p, dof\\\_p, expected\\\_p = chi2\\\_contingency(contingency\\\_products)
print(f"Chi-square: {chi2\\\_p:.2f}, P-value: {p\\\_value\\\_p:.10f}")
# Chi-square: 1503.63, p < 0.001 → statistically significant (strongest predictor tested)
```

Visualized with Matplotlib/Seaborn:

```python
import matplotlib.pyplot as plt
import seaborn as sns

fig, axes = plt.subplots(1, 2, figsize=(14,5))

country\\\_churn = df.groupby('country')\\\['churn'].mean() \\\* 100
sns.barplot(x=country\\\_churn.index, y=country\\\_churn.values, ax=axes\\\[0])
axes\\\[0].set\\\_title('Churn Rate by Country (%)')

product\\\_churn = df.groupby('products\\\_number')\\\['churn'].mean() \\\* 100
sns.barplot(x=product\\\_churn.index, y=product\\\_churn.values, ax=axes\\\[1])
axes\\\[1].set\\\_title('Churn Rate by Number of Products (%)')

plt.tight\\\_layout()
plt.savefig('churn\\\_charts.png', dpi=150)
plt.show()
```

!\[Churn Charts](churn\_charts.png)

### 3️⃣ Power BI — Stakeholder Dashboard

An interactive dashboard built for a non-technical retention team, featuring live filtering by activity status.

!\[Dashboard](dashboard\_screenshot.png)

**Includes:**

* KPI cards — Total Customers, Overall Churn Rate
* Churn Rate by Country
* Churn Rate by Number of Products
* Active Member slicer (live filter)
* Written recommendation embedded directly on the dashboard

\---

## 📊 Key Findings

|Finding|Detail|
|-|-|
|🇩🇪 **Germany churns highest**|32.4% vs. \~16% in Spain and France — nearly **2x** the rate|
|🎯 **Compound risk segment**|Inactive customers in Germany churn at **41.08%** — the single highest-risk group|
|📦 **Product count is the strongest predictor**|Churn drops to **7.6%** at 2 products, but spikes to **83–100%** at 3–4 products — a counterintuitive pattern worth deeper investigation|
|✅ **Statistically validated**|Both relationships confirmed significant via Chi-Square test (country: χ² = 301.26; products: χ² = 1503.63; both **p < 0.001**)|

\---

## 💡 Recommendation

1. **Prioritize retention campaigns on inactive customers in Germany** — the highest-risk segment identified (41% churn)
2. **Investigate the 3+ product segment** — despite deeper relationships, these customers churn at 83–100%, suggesting forced bundling, unresolved complaints, or a struggling product tier rather than genuine loyalty
3. **Use activity status as an early-warning signal** — inactive members churn \~2x more than active ones across every country

*Note: the 3–4 product segments have smaller sample sizes (266 and 60 customers respectively), so while the pattern is dramatic and statistically significant, it's flagged here as a priority for further investigation rather than a fully proven causal driver.*

\---

## 📁 Repository Structure

```
bank-churn-analysis/
├── README.md
├── sql/
│   └── churn\\\_analysis\\\_queries.sql
├── notebook/
│   └── Churn\\\_Analysis.ipynb
├── dashboard/
│   └── Bank\\\_Churn\\\_Dashboard.pbix
├── images/
│   ├── churn\\\_charts.png
│   └── dashboard\\\_screenshot.png
└── data/
    └── bank\\\_customer.csv
```

\---

## 🚀 What I Learned

This was my first end-to-end analytics project, and it taught me that the technical tools — SQL, Python, Power BI — are just the means. The actual skill of a data analyst is asking the right business question, proving an insight holds up statistically, and turning a number into a recommendation someone can act on.

\---

## 📬 Connect

Built by **Sakshi** — BCA graduate specializing in Data Analytics, currently pursuing Data Analyst \& Gen AI training at Coding Ninjas.

📧 [sakshibhati188@gmail.com](mailto:sakshibhati188@gmail.com)

