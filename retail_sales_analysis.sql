## SQL retail sales analysis 
create database retail_db;
use retail_db;
-- Create Table
create table retail_sales(transactions_id int ,
						sale_date date ,
                        sale_time time ,
                        customer_id int,
                        gender varchar(12),
                        age	int,
                        category varchar(15),
                        quantity	int,
                        price_per_unit float,
                        cogs float ,
						total_sale float);

select * from retail_sales;

select count(*) as total_rows from retail_sales;

-- DATA CLEANING --
select * from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null;

delete  from retail_sales 
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null;

-- DATA EXPLORATION --

-- how many sales we have?
select count(*) as total_sales from retail_sales;

-- how many unique customers we have?
select count(distinct customer_id) as total_customers from retail_sales;

-- how many unique category we have?
select distinct category from retail_sales;

-- Data analysis and business key problems --

-- Q1. Write a query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date ='2022-11-05';

-- Q2.write a query to retrieve all transactions where the category is clothing and the quantity sold is more than and equal to 4 in the month of Nov-2022
select * from retail_sales where category='clothing' and quantity >= 4 and sale_date like '2022-11%';

-- Q3. Write a query to calculate the total sales(total_sales) for each category
select category,sum(total_sale) as total_sales from retail_sales group by category;

-- Q4. Write a query to find the average age of customers who purchased items from the 'Beauty' category
select category,round(avg(age),2) as avg_age from retail_sales where category ='Beauty';

-- Q5.Write a query to find all transactions where the total_sale is greater than 1000
select * from retail_sales where total_sale>1000;

-- Q6.Write the query to find the total number of transactions(transaction_id) made by each gender in each category
select category,gender,count(transactions_id) as total_transaction from retail_sales group by category,gender order by category;

-- Q7. Write a query to calculate the average sale for each month.Find out the best selling month in each year
select extract(year from sale_date) as year,extract(month from sale_date) as month,avg(total_sale) as avg_sale_per_month,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank_
from retail_sales group by extract(year from sale_date) ,extract(month from sale_date);

-- Q8.Write a query to find the top 5 customers based on the highest total sale
select customer_id,sum(total_sale) as total_sale from retail_sales group by customer_id order by sum(total_sale) desc limit 5;

-- Q9. Write a query to find the number of unique customers who purchased items from each category
select category, count(distinct customer_id) as total_customers from 	retail_sales group by category;

-- Q10. Write a query to create each shift and number of orders (example Morning<12 , Afternoon between 12 &17 ,evening >17)
with hourly_sale 
as
(select *,case when extract(hour from sale_time)<12 then 'morning'
when extract(hour from sale_time) between 12 and 17 then 'afternoon'
when extract(hour from sale_time)>17 then 'evening' 
end as shift from retail_sales)
select count(*) as _shiftwise_total_orders,shift from hourly_sale group by shift;

-- END of the project
