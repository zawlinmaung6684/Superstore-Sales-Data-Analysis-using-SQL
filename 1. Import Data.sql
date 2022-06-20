CREATE TABLE superstore (
	RowID INT, 
    OrderID	VARCHAR(25),
    OrderDate DATE,	
    ShipDate DATE,
    ShipMode VARCHAR(25),
    CustomerID VARCHAR(25),
    CustomerName VARCHAR(100),	
    Segment	VARCHAR(25),
    Country	VARCHAR(25),
    City VARCHAR(50),
    State VARCHAR(50),
    PostalCode INT,
	Region VARCHAR(25),	
    ProductID VARCHAR(50),
    Category VARCHAR(50),
    SubCategory VARCHAR(50),	
    ProductName	VARCHAR(225),
    Sales DECIMAL(10, 2)
);

DROP TABLE IF EXISTS superstore;

SET GLOBAL LOCAL_INFILE = 1;

-- Importing Data
LOAD DATA LOCAL INFILE 'D:/Zaw Lin Maung/Practice/Superstore Sales Data Analysis/SuperstoreSales.csv'
INTO TABLE superstore
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(RowId, OrderId, @order_date, @ship_date, ShipMode, 
CustomerID, CustomerName, Segment, Country, City, State, 
PostalCode, Region, ProductID, Category, SubCategory, ProductName, Sales)
SET OrderDate = STR_TO_DATE(@order_date, '%d/%m/%Y'),
	ShipDate = STR_TO_DATE(@ship_date, '%d/%m/%Y');

-- Taking a quick view at the data
SELECT * 
FROM superstore;