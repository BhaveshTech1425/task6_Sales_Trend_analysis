select *
from customers

select *
from orders

---Analyze Mnthly Revenue and Order Volume---

select 
      extract (year from order_date) as year,
	  extract (month from order_date) as month,
	  sum(total_amount) as total_revenue,
	  count(distinct order_id) as total_orders
from orders
group by  extract (year from order_date),
          extract (month from order_date)
order by  year , month


---filter by specific time period---

---for 2024 year

select 
      extract (year from order_date) as year,
	  extract (month from order_date) as month,
	  sum(total_amount) as total_revenue,
	  count(distinct order_id) as total_orders
from orders
where order_date >= '2024-01-01' and order_date <= '2024-12-31'
group by  extract (year from order_date),
          extract (month from order_date)
order by  year , month


---for 2025 year

select 
      extract (year from order_date) as year,
	  extract (month from order_date) as month,
	  sum(total_amount) as total_revenue,
	  count(distinct order_id) as total_orders
from orders
where order_date >= '2025-01-01' and order_date <= '2025-12-31'
group by  extract (year from order_date),
          extract (month from order_date)
order by  year , month


---Last 6 Months from Today


select 
      extract (year from order_date) as year,
	  extract (month from order_date) as month,
	  sum(total_amount) as total_revenue,
	  count(distinct order_id) as total_orders
from orders
where order_date >= current_date - INTERVAL'6 MONTHS'
group by  extract (year from order_date),
          extract (month from order_date)
order by  year , month


---Cumulative Revenue Over time

select 
      extract(month from order_date) as month,
	  sum(total_amount) as monthly_revenue,
	  sum(sum(total_amount))over(order by extract(month from order_date)) as cumulative_revenue
from orders
group by extract(month from order_date)
order by month


---Top 3 month from sales---

with monthly_sales as(
     select
	       extract(month from order_date) as month,
		   sum(total_amount) as total_revenue
	 from orders
	 group by extract(month from order_date)
),
ranked_sales as(
     select month,
	        total_revenue,
			rank()over(order by total_revenue desc) as revenue_rank
	 from monthly_sales
)
select month,
       total_revenue,
	   revenue_rank
from ranked_sales
where revenue_rank <= 3 
order by revenue_rank