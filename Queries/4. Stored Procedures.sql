-- Creating a Procedure to Get Total Sales of a Product if Typed
DELIMITER $$ 
CREATE PROCEDURE GetTotalSalesOfProduct (
    IN pName VARCHAR(255),
    OUT total_sales INT
)
BEGIN 
    SELECT SUM(Sales)
    INTO total_sales
    FROM superstore
    WHERE ProductName = pName;
END $$
DELIMITER ;

CALL GetTotalSalesofProduct('High Speed Automatic Electric Letter Opener', @total_sales);
SELECT @total_sales;

-- Creating a Procedure to Get Number of Orders Based on Region
DELIMITER $$
CREATE PROCEDURE OrdersBasedOnRegion (
    IN pCountry VARCHAR(25),
    IN pState VARCHAR(50),
    IN pCity VARCHAR(50),
    OUT total_orders INT
)
BEGIN
    SELECT COUNT(OrderID)
    INTO total_orders
    FROM superstore
    WHERE Country = pCountry AND City = pCity AND State = pState;
END $$
DELIMITER ;

CALL OrdersBasedOnRegion('United States', 'California', 'Los Angeles', @total_orders);
SELECT @total_orders;
