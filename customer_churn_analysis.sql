CREATE DATABASE bank_churn;
USE bank_churn;
SELECT * FROM `bank customer churn prediction` LIMIT 10;
RENAME TABLE `bank customer churn prediction` TO customers;
SELECT COUNT(*) FROM customers;
SELECT * 
FROM customers;


SELECT 
ROUND(SUM(churn) / COUNT(*) * 100,2) AS churn_rate_percent FROM customers;

SELECT 
    country,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(SUM(churn) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customers
GROUP BY country
ORDER BY churn_rate_percent DESC;

SELECT 
    active_member,
    COUNT(*) AS total_customers,
    ROUND(SUM(churn) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customers
GROUP BY active_member;

SELECT 
    products_number,
    COUNT(*) AS total_customers,
    ROUND(SUM(churn) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customers
GROUP BY products_number
ORDER BY products_number;

SELECT 
    country,
    active_member,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned,
    ROUND(SUM(churn) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customers
GROUP BY country, active_member
ORDER BY churn_rate_percent DESC;

SELECT * FROM customers;