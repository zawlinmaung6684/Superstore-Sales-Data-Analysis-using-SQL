-- Delete Leading and Trailing Double Quotes("") in ProductName
SELECT *
FROM superstore
WHERE ProductName LIKE '"%"';

UPDATE superstore
SET ProductName = TRIM(BOTH '"' FROM ProductName);

-- Checking and Cleaning Rows with Sales = 0
/* Check all the rows where their sales are zeros. */
SELECT *
FROM superstore 
WHERE sales = 0;

/* 
	1. Check all the rows with zero sales after grouping them with ProductName.
    2. Delete those rows.
*/
SELECT ProductName, ROUND(SUM(sales), 2) AS total_sales
FROM superstore
GROUP BY 1
HAVING total_sales = 0;
        
DELETE  
FROM superstore
WHERE ProductName IN (
	SELECT t.ProductName
	FROM (
		SELECT ProductName, COUNT(OrderID), ROUND(SUM(sales), 2) AS total_sales
		FROM superstore
		GROUP BY 1
		HAVING total_sales = 0
	) AS t
);

-- Checking Date Difference Between OrderDate and ShipDate
SELECT * 
FROM (
	SELECT 
		*,
		DATEDIFF(ShipDate, OrderDate) AS ShippingDelayTime
	FROM superstore
	ORDER BY 1
) AS t
WHERE ShippingDelayTime < 0;
