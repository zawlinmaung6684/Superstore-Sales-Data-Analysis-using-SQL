-- Drop an Unnecessary Column 
ALTER TABLE superstore
DROP COLUMN RowID;

-- Counting the Total Number of Rows in the Dataset after Data Cleaning
SELECT COUNT(*)
FROM superstore;

-- Total Orders and Total Sales Based on ShipMode
SELECT ShipMode, COUNT(OrderId) AS TotalOrders
FROM superstore
GROUP BY ShipMode;

SELECT ShipMode, CONCAT('$ ', SUM(Sales)) AS TotalOrders
FROM superstore
GROUP BY ShipMode;

-- Yearly Sales
SELECT 
	YEAR(OrderDate) AS Year, 
    	COUNT(OrderID) AS TotalOrders, 
    	CONCAT('$ ', SUM(Sales)) AS TotalSales
FROM superstore
GROUP BY Year WITH ROLLUP;

-- Analyzing Orders Based on Region
/*
    1. Count All Orders Based On Country, State, City, and Region.
    2. Create a New Column to Display Total Orders per State.
    3. Rank each State Based on their Total Orders.
*/
WITH OrderPerState AS (
	SELECT Country, State, City, Region, CONCAT('$ ', SUM(sales)) AS sales, COUNT(OrderID) AS count
	FROM superstore
	GROUP BY 1, 2, 3, 4
	ORDER BY 2, 3
)
SELECT *, 
    CONCAT('$ ', SUM(CONVERT(TRIM(LEADING '$' FROM sales), DECIMAL(10, 2))) OVER(PARTITION BY State)) AS total_sales, 
    DENSE_RANK() OVER(ORDER BY total_orders_per_state DESC) AS rank_by_state 
FROM (
	SELECT *, SUM(count) OVER (PARTITION BY State) AS total_orders_per_state
	FROM OrderPerState
) AS t;

-- Analyzing Segment
/*
    1. Count Orders from Each Segment.
    2. Calculate Percentage.
*/
WITH SegmentPercent AS (
	SELECT Segment, COUNT(OrderID) AS TotalOrders, SUM(Sales) AS TotalSales
	FROM superstore
	GROUP BY Segment
)
SELECT 
    Segment,
    TotalOrders, 
    CONCAT('$ ', TotalSales) AS TotalSales,
    CONCAT(ROUND((TotalSales / (SELECT SUM(TotalSales) FROM SegmentPercent)) * 100, 2), '%') AS SalesPercent
FROM SegmentPercent;

-- Analzying Category and Subcategory Orders
/*
    1. Count Subcategory Grouped by Category.
    2. Count Category using Windows Function.
    3. Calculate Percentages of Subcategory and Category.
*/
WITH Category AS (
	SELECT Category, SubCategory, COUNT(SubCategory) AS SubCategoryOrders
	FROM superstore
	GROUP BY 1, 2
	ORDER BY 1
)
SELECT *, 
    CONCAT(ROUND((SubCategoryOrders / CategoryOrders) * 100, 2), '%') AS SubCategoryPercent,
    CONCAT(ROUND((CategoryOrders / (SELECT SUM(SubCategoryOrders) FROM Category)) * 100, 2), '%') AS CategoryPercent
FROM (
	SELECT *, SUM(SubCategoryOrders) OVER (PARTITION BY Category) AS CategoryOrders
	FROM Category
) AS t;

-- Analyzing Category Sales
SELECT Category, CONCAT('$ ', FORMAT(SUM(sales), 2)) AS total_sales
FROM superstore
GROUP BY 1;

-- Analyzing Subcategory Sales
/*
	Total Sales of the Superstore
*/
SELECT CONCAT('$ ', SUM(sales)) AS total_revenue
FROM superstore;

/*
    1. Count SubCategory and Sum their Sales.
    2. Calculate Average Price of Each Subcategory.
*/
SELECT 
    SubCategory
    count,
    CONCAT('$ ', FORMAT(total_sales / count, 2)) AS average_price_per_item,
    CONCAT('$ ', total_sales) AS total_sales
FROM (
	SELECT 
	    SubCategory, 
	    COUNT(Subcategory) AS count,
            SUM(sales) AS total_sales
	FROM superstore
	GROUP BY 1
    ORDER BY total_sales DESC
) AS t;

-- Analzying Product Sales
/*
    1. Count Products Based on ProductName, and Sum Total Sales of Each Product.
    2. Calculate the Average Price of Each Product.
*/
SELECT 
    ProductName, 
    OrderCount, 
    CONCAT('$ ', FORMAT(total_sales / OrderCount, 2)) AS average_price_per_product,
    CONCAT('$ ', total_sales) AS total_sales
FROM (
	SELECT DISTINCT ProductName, COUNT(OrderId) AS OrderCount, SUM(sales) AS total_sales
	FROM superstore
	GROUP BY 1
    	ORDER BY 3
) AS t;

-- 5 Products with Highest Orders
SELECT ProductName, COUNT(OrderId) AS OrderCount
FROM superstore
GROUP BY ProductName
ORDER BY 2 DESC
LIMIT 5;

-- 5 Products with Highest Average Prices
SELECT 
    ProductName, 
    ROUND(total_sales / order_count, 2) AS average_price
FROM (
	SELECT ProductName, COUNT(OrderId) AS order_count, SUM(Sales) AS total_sales
	FROM superstore
	GROUP BY ProductName
) AS t
ORDER BY 2 DESC
LIMIT 5;

-- Date Difference Between OrderDate and ShipDate
SELECT 
    OrderDate, 
    COUNT(OrderID) AS OrderCount, 
    ShipDate,
    DATEDIFF(ShipDate, OrderDate) AS ShippingDelayTime
FROM superstore
GROUP BY OrderDate
ORDER BY 1;
