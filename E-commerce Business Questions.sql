-- The finance team of “ShopMaster” wants a quarterly breakdown of revenue to see seasonal patterns. 

with Qtras as( Select quarter(orderdate) as Quarters , Sum(revenue) as Total_Revenu from orders
group by Quarters)
select case when Quarters in (1,2,3) then "Fall"
when Quarters in (4,5,6) then "Summer"
when Quarters in (7,8,9) then "Spring"
when Quarters in (10,11,12)  then "Winter" end  As Sessions_Names , Total_Revenu from Qtras;
