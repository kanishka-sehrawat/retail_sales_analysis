# Retail Sales Analysis SQL Project

## Project Overview
This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

# Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_db
(
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

``` sql
select * from retail_sales;

select COUNT(*) as total_rows FROM retail_sales;

query for: ** unique customers we have.
SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales;

query for: **unique category we have.
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
where  transactions_id is NULL
OR sale_date is NULL
OR sale_time is NULL
OR customer_id is NULL
OR gender is NULL
OR age is NULL
OR category is NULL
OR quantity is NULL;

DELETE FROM retail_sales 
where transactions_id is NULL
OR sale_date is NULL
OR sale_time is NULL
OR customer_id is NULL
OR gender is NULL
OR age is NULL
OR category is NULL
OR quantity is NULL;
```

### 3.Data Analysis and Findings
**query for:Retrieving all columns for sales made on '2022-11-05'**
``` sql
SELECT * from retail_sales WHERE sale_date ='2022-11-05';
```

**query for:Retrieving all transactions where the category is clothing and the quantity sold is more than and equal to 4 in the month of Nov-2022**
``` sql
SELECT * from retail_sales WHERE category='clothing' AND quantity >= 4 AND sale_date like '2022-11%';
```

**query for: Calculating the total sales(total_sales) for each category*
``` sql
SELECT category,SUM(total_sale) as total_sales from retail_sales GROUP BY category;
```

query for:**Finding the average age of customers who purchased items from the 'Beauty' category
``` sql
SELECT category,ROUND(AVG(age),2) as avg_age from retail_sales WHERE category ='Beauty';
```

query for:**Finding all transactions where the total_sale is greater than 1000
``` sql
SELECT * from retail_sales WHERE total_sale>1000;
```

query for:**Finding the total number of transactions(transaction_id) made by each gender in each category
``` sql
SELECT category,gender,count(transactions_id) as total_transaction from retail_sales GROUP BY  category,gender ORDER BY category;
```

query for:**Calculating the average monthly sales for each year and to identify the best-performing (highest average sales) month in each year.
``` sql
SELECT extract(year from sale_date) as year,extract(month from sale_date) as month,avg(total_sale) as avg_sale_per_month,
RANK() OVER(PARTITION BY extract(year from sale_date) ORDER BY avg(total_sale) desc) as rank_
from retail_sales GROUP BY extract(year from sale_date) ,extract(month from sale_date);
```

query for:**Finding the top 5 customers based on the highest total sale
``` sql
SELECT customer_id,SUM(total_sale) as total_sale from retail_sales GROUP BY customer_id ORDER BY sum(total_sale) desc LIMIT 5;
```

query for:**Finding the number of unique customers who purchased items from each category
``` sql
SELECT category, COUNT(DISTINCT customer_id) as total_customers from retail_sales GROUP BY category;
```

query for:**Creating shifts and calculating number of orders wrt shifts(Morning<12 , Afternoon between 12 &17 ,evening >17)
``` sql
with hourly_sale 
as
(SELECT *,CASE WHEN extract(hour from sale_time)<12 THEN'morning'
WHEN extract(hour from sale_time) between 12 and 17 THEN'afternoon'
WHEN extract(hour from sale_time)>17 THEN 'evening' 
END as shift from retail_sales)
SELECT count(*) as _shiftwise_total_orders,shift from hourly_sale GROUP BY shift;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

