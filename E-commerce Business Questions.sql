-- Q1 The finance team of “ShopMaster” wants a quarterly breakdown of revenue to see seasonal patterns. 

with Qtras as( Select quarter(orderdate) as Quarters , Sum(revenue) as Total_Revenu from orders
group by Quarters)
select case when Quarters in (1,2,3) then "Fall"
when Quarters in (4,5,6) then "Summer"
when Quarters in (7,8,9) then "Spring"
when Quarters in (10,11,12)  then "Winter" end  As Sessions_Names , Total_Revenu from Qtras;

-- Q2  Management wants to compare quarter revenue vs. previous quarter to measure growth.


with Qtr_revenue as (
    select YEAR(OrderDate) AS year,QUARTER(OrderDate) AS quarter, SUM(Revenue) AS total_revenue
    from orders GROUP BY YEAR(OrderDate), QUARTER(OrderDate))
select 
    year,quarter,total_revenue,
    LAG(total_revenue) OVER (order by year, quarter) AS prev_revenue,
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year, quarter)) 
        / LAG(total_revenue) OVER (order BY year, quarter) * 100 AS QoQ_growth
FROM Qtr_revenue;


-- Q3 CRM team wants to know how often customers purchase again

select 
CustomerID,
orderdate ,
lag(orderdate) over(partition by customerid order by orderdate)as Pre_order_date,
datediff(orderdate,lag(orderdate) over(partition by customerid order by orderdate)) as order_gap
from orders;




-- Q4 Finance wants to track cumulative monthly revenue

with running_cte as (
select month(orderdate) as Monthwise, 
sum(revenue) as Total_revenue  
from orders
group by Monthwise
order by monthwise 
)
select 
	monthwise, 
	total_revenue, 
    lag(total_revenue) over(order by monthwise) as Running_revenue,
sum(tota


  

-- Q5 Detect Returns Occurring Within 7 Days of Purchase
select 
o.orderid,
o.orderdate,abs(datediff(r.Return_Date,o.orderdate)) as Date_difference
from orders as o join returns as r 
on o.orderid= r.Order_ID
where datediff(r.Return_Date,o.orderdate) <=7;



-- Q6 Quarter-wise Top Product by Revenue

with cte_rnk as (select 
productid, quarter(orderdate) as Quarters,
sum(revenue) as total_revenue , 
dense_rank() over(order by sum(revenue)) as rnk 
from orders 
group by productid, quarter(orderdate) 
order by Quarters)

select Quarters , productid, total_revenue,rnk from cte_rnk
order by rnk;
