---- Create the Database
CREATE DATABASE  EcommerceProject;
USE EcommerceProject;

-- 1. Add a new column for the proper date format
ALTER TABLE ecommerce_sales_data ADD COLUMN format_date DATE;
set SQL_SAFE_UPDATES = 0;
-- 2. Convert the text dates to real Date objects
-- This uses TRIM to remove any hidden spaces from the CSV import
UPDATE ecommerce_sales_data
SET format_date = STR_TO_DATE(TRIM(`order date`), '%d-%m-%Y');
SET SQL_SAFE_UPDATES = 1;
-- 3.finding Total Revenue, Profit, and Margin
SELECT 
    SUM(sales) AS total_revenue, 
    SUM(profit) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM ecommerce_sales_data;
-- 4.finding Top 5 Best-Selling Products
SELECT 
    `product name`, 
    SUM(sales) AS total_sales
FROM ecommerce_sales_data
GROUP BY `product name`
ORDER BY total_sales DESC
LIMIT 5;
-- 5.finding Profitability by Category
SELECT 
    category, 
    SUM(sales) AS total_sales, 
    SUM(profit) AS total_profit
FROM ecommerce_sales_data
GROUP BY category
ORDER BY total_profit DESC;
-- 6.finding monthly trend
SELECT 
    DATE_FORMAT(format_date, '%Y-%m') AS sale_month, 
    SUM(sales) AS monthly_revenue
FROM ecommerce_sales_data
GROUP BY sale_month
ORDER BY sale_month;
-- 7.finding Regional Performance
SELECT 
    region, 
    SUM(sales) AS total_sales
FROM ecommerce_sales_data
GROUP BY region
ORDER BY total_sales DESC;
-- 8.dinding monthly sales trend
SELECT 
    DATE_FORMAT(format_date, '%Y-%m') AS sale_month, 
    SUM(sales) AS total_monthly_revenue,
    COUNT(`order date`) AS number_of_orders
FROM ecommerce_sales_data
GROUP BY sale_month
ORDER BY sale_month;