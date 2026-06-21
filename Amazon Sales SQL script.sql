CREATE database amazon_analytics;
USE amazon_analytics;

SELECT * FROM amazon_sales;

-- Total Sales
SELECT COUNT(*) as Total_Sales
FROM amazon_sales;

-- Total Amount
SELECT ROUND(SUM(Amount)) as Total_amount
from amazon_sales;

-- Total Quantity Sold
select SUM(Qty) as Total_quantity_sold
from amazon_sales;

-- Total Sales By Category
SELECT 
	Category,
    COUNT(*) AS TOTAL_SALES
FROM amazon_sales
GROUP BY Category
ORDER BY TOTAL_SALES DESC
LIMIT 10;
-- Cancelation Rate
SELECT
	ROUND(SUM(
		CASE WHEN Status LIKE '%Cancelled%' THEN 1 ELSE 0
        END)*100.0/COUNT(*)
        ,2) as Cancellation_rate
FROM amazon_sales

-- Revenue By Category
SELECT 
    Category,
    ROUND(SUM(Amount),2) as Revenue
from amazon_sales
GROUP BY Category; 

-- Top States By Revenue
SELECT 
    ship_state,
    ROUND(SUM(Amount),2) as Revenue
from amazon_sales
GROUP BY ship_state
order by Revenue DESC
LIMIT 10;

-- Top States By orders
SELECT 
	ship_state,
    COUNT(*) as Total_orders
FROM amazon_sales
GROUP BY ship_state
Order BY Total_orders DESC
LIMIT 10;

-- Rank Categories
WITH Category_amount as
	(
    SELECT 
    Category,
    ROUND(SUM(Amount),2) as Revenue
	from amazon_sales
	GROUP BY Category
	) 
SELECT 
	*,
    DENSE_RANK() OVER(ORDER BY Revenue DESC) Rank_no
FROM Category_amount;

-- Revenue Contribution
SELECT 
	Category,
    ROUND(SUM(Amount)) as Revenue,
    ROUND(SUM(Amount)*100/    
		(SELECT SUM(Amount) FROM amazon_sales)
        ,1) Contribution
FROM amazon_sales
group by Category
ORDER BY Revenue DESC;

-- Promotion Impact
SELECT 
	promotion_used,
    COUNT(*) as Order_Count,
    ROUND(SUM(Amount),2) as Revenue
FROM amazon_sales
Group by promotion_used;

-- Monthly Revenue 
SELECT 
	Month,
    ROUND(SUM(Amount),2) as Revenue
FROM amazon_sales
GROUP BY Month
ORDER BY Revenue DESC;


-- Inventory Analasis
DESCRIBE inventory;
SELECT * FROM inventory;

-- STOCK BY CATEGORY
SELECT 
	Category,
    SUM(Stock) as Total_stock
FROM inventory
GROUP BY Category
ORDER BY Total_stock DESC;

-- LOW STOCK PRODUCTS
SELECT * FROM inventory
ORDER BY Stock ASC
LIMIT 20;

-- STOCK BY SIZE
SELECT 
	Size,
    SUM(Stock) as Total_stock
FROM inventory
GROUP BY Size
ORDER BY Total_stock DESC;

-- STOCK BY COLOR
SELECT 
	Color,
    SUM(Stock) as Total_stock
FROM inventory
GROUP BY Color
ORDER BY Total_stock DESC;

-- Revenue By Category and Stock
SELECT 
	i.Category,
    ROUND(SUM(a.Amount),2) as Revenue,
    SUM(i.Stock) as Total_stock
FROM amazon_sales a
JOIN inventory i
ON a.SKU = i.SKU_Code
GROUP BY i.Category
ORDER BY Revenue DESC;

-- HIGH SALES BUT LOW STOCK
SELECT
	a.SKU,
    i.Category,
	SUM(a.Qty) as Units_sold,
    i.Stock
from amazon_sales a
JOIN inventory i
ON a.SKU = i.SKU_Code
GROUP BY a.SKU,i.Category,i.Stock
ORDER BY Units_sold DESC;

-- Revenue by COLOR
SELECT 
	i.Color,
ROUND(SUM(a.Amount),2) as Revenue
FROM amazon_sales a
JOIN inventory i
ON a.SKU = i.SKU_Code
GROUP BY Color
ORDER BY Revenue DESC;

-- Revenue By Size
SELECT 
	i.Size,
ROUND(SUM(a.Amount),2) as Revenue
FROM amazon_sales a
JOIN inventory i
ON a.SKU = i.SKU_Code
GROUP BY Size
ORDER BY Revenue DESC;

-- Overstocked Products
SELECT 
	i.SKU_Code,
    i.Category,
    i.Stock
FROM inventory i
Order by i.stock DESC
LIMIT 20;
	

 
	
    

