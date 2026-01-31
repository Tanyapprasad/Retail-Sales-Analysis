--RETAIL SALES
create database Retail_sales;

drop table if exists retail_sales;

create table retail_sales(
          transactions_id int primary key,
          sale_date date,	
		  sale_time	time,
		  customer_id int,
		  gender varchar,
		  age int,
		  category varchar,
		  quantiy int,
		  price_per_unit float,	
		  cogs float,
		  total_sale float
);

select * from retail_sales;
select count(*) from retail_sales;

--Handling null values
-- Check for null values
select * from retail_sales where transactions_id = null;
select * from retail_sales where sale_date = null;
select * from retail_sales where age is null;

select * from retail_sales 
	where 
		customer_id is null 
		or 
		gender is null
		or
		age IS null
		or
		category is null
		or
		quantiy is null
		or
		price_per_unit is null
		or
		cogs is null
		or
		total_sale is null
	;
-- remove the null values
delete from retail_sales where 
customer_id is null 
		or 
		gender is null
		or
		age is null
		or
		category is null
		or
		quantiy is null
		or
		price_per_unit is null
		or
		cogs is null
		or
		total_sale is null
	;

--Data Exploration
-- 1)How many sales we have?
select count(*) as totalSales from retail_sales ;

--2)How many unique customers do we have?
select count(distinct customer_id) from retail_sales;

--3) How many Distinct categories we have? And, which are they?
select count( distinct category) from retail_sales;
select distinct category from retail_sales;

--Data analysis & Business key problems
--1)Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * 
from retail_sales
where sale_date = '2022-11-05' 
order by transactions_id;

--2)Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 2 in the month of Nov-2022:
select *
from retail_sales
where 	quantiy > 2
	and category ='Clothing'
	and sale_date >= '2022-11-01' 
	and sale_date <= '2022-11-30';
	
--3)Write a SQL query to calculate the total sales (total_sale) for each category.:
--Option 1 
select category , 
	sum(total_sale) as Total_Sales ,
	count(*) as Total_No_Orders
from retail_sales
group by category;

--4)Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select round(avg(age),0) as AvgAge
from retail_sales
where category = 'Beauty';

--5)Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * 
from retail_sales 
where total_sale > 1000;

--6)Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select category,
	   gender, 
	   count(*) 
from retail_sales
group by category, gender;

--7)Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select extract( year from sale_date) as Year, 
       extract (month from sale_date) as Month,
	   avg(total_sale)
from retail_sales
group by month, year
order by year, month; -- calculates the average sale for each month.

select  year, 
		month, 
		avg 
from (select extract( year from sale_date) as Year,
			 extract (month from sale_date) as Month,
	         avg(total_sale) as AVG
      from retail_sales
	  group by month, year
	  order by year, month) 
order by avg desc 
limit 2; -- best selling month 

--or using a window function
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY year, month
) 
WHERE rank = 1


--8)Write a SQL query to find the top 5 customers based on the highest total sales 

select distinct customer_id,
	   sum(total_sale)
from retail_sales 
group by customer_id
order by sum desc 
limit 5;

--9)Write a SQL query to find the number of unique customers who purchased items from each category.:
select category,
       count(distinct customer_id)
from retail_sales
group by category
order by count desc;

--10)Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with cte as
		   (select *,
			   case 
				  when extract(hour from sale_time) < 12 then 'morning'
				  when extract( hour from sale_time) > 17 then 'evening'
				  else 'Afternoon'
			   end as shift
		    from retail_sales) 
select shift,
       count(*) as total_orders
from cte
group by shift;

