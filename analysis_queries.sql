-- Retail Sales Analysis SQL Project
-- Author: Md Asifur Rahaman
-- Dataset and original guided project steps credit: Zero Analyst

CREATE DATABASE IF NOT EXISTS retail_sales_db;
USE retail_sales_db;

CREATE TABLE retail_sales (
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(10),
age INT,
category VARCHAR(35),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

-- 1. Total number of records
SELECT COUNT(*) AS total_records
FROM retail_sales;

-- 2. Number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales;

-- 3. Product categories
SELECT DISTINCT category
FROM retail_sales;

-- 4. Check missing values
SELECT *
FROM retail_sales
WHERE sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- 5. Remove records with missing values
DELETE FROM retail_sales
WHERE sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- 6. Sales made on a specific date
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 7. Clothing transactions with quantity of 4 or more in November 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND quantity >= 4;

-- 8. Total sales and total orders by category
SELECT
category,
SUM(total_sale) AS total_sales,
COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- 9. Average customer age for Beauty category
SELECT
ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';

-- 10. High-value transactions
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 11. Transactions by gender and category
SELECT
category,
gender,
COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;

-- 12. Best selling month in each year based on average sales
SELECT
sales_year,
sales_month,
average_sales
FROM (
SELECT
YEAR(sale_date) AS sales_year,
MONTH(sale_date) AS sales_month,
AVG(total_sale) AS average_sales,
RANK() OVER (
PARTITION BY YEAR(sale_date)
ORDER BY AVG(total_sale) DESC
) AS sales_rank
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
) ranked_sales
WHERE sales_rank = 1;

-- 13. Top 5 customers by total sales
SELECT
customer_id,
SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 14. Unique customers by category
SELECT
category,
COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;

-- 15. Orders by shift
WITH hourly_sales AS (
SELECT
*,
CASE
WHEN HOUR(sale_time) < 12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT
shift,
COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift
ORDER BY total_orders DESC;
