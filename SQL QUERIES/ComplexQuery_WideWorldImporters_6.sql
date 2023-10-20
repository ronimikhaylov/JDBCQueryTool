-- 6
-- Complex Query
-- Problem Statement:
-- Retrieve the total quantity of products ordered by customers from each state, 
-- and calculate the average delivery time in days using a custom scalar function.

-- Using the WideWorldImporters database
USE WideWorldImporters
GO

-- Checking if a function named fn_DeliveryDays exists and dropping it if it does
DROP FUNCTION IF EXISTS dbo.fn_DeliveryDays;
GO

-- Creating a new scalar function to calculate the difference in days between the order date and the expected delivery date
CREATE FUNCTION fn_DeliveryDays (@OrderDate DATE, @ExpectedDeliveryDate DATE)
RETURNS INT
AS
BEGIN
    -- Calculating the difference in days between two dates
    RETURN DATEDIFF(DAY, @OrderDate, @ExpectedDeliveryDate);
END;
GO

-- Using a Common Table Expression (CTE) to aggregate order quantities by state
WITH StateOrderAggregation AS (
    -- Selecting relevant columns for aggregation
    SELECT 
        c.CustomerID, -- Customer's ID is selected to later join with the Orders table
        sp.StateProvinceName, -- State name is selected to group results by state
        SUM(ol.Quantity) AS TotalQuantity -- Aggregating the total ordered quantity
    FROM Sales.Customers AS c
    -- Joining the Customers table with the Cities table based on the delivery city ID
    JOIN Application.Cities AS ct ON c.DeliveryCityID = ct.CityID 
    -- Joining the Cities table with the StateProvinces table to fetch the state name for each city
    JOIN Application.StateProvinces AS sp ON ct.StateProvinceID = sp.StateProvinceID 
    -- Joining the Customers table with the Orders table to fetch order details for each customer
    JOIN Sales.Orders AS o ON c.CustomerID = o.CustomerID
    -- Joining the Orders table with the OrderLines table to get the quantity of each order
    JOIN Sales.OrderLines AS ol ON o.OrderID = ol.OrderID
    -- Grouping the results by customer ID and state name to aggregate quantities
    GROUP BY c.CustomerID, sp.StateProvinceName
)

-- Selecting the final results
SELECT 
    StateProvinceName, -- State name
    SUM(TotalQuantity) AS TotalQuantity, -- Summing up the total quantity for each state
    -- Calculating the average delivery days using the created function
    AVG(dbo.fn_DeliveryDays(o.OrderDate, o.ExpectedDeliveryDate)) AS AvgDeliveryDays 
FROM StateOrderAggregation AS soa
-- Joining the aggregated results with the Orders table to fetch order and delivery dates for the average calculation
JOIN Sales.Orders AS o ON soa.CustomerID = o.CustomerID
-- Grouping the final results by state name to display aggregated quantities and average delivery days for each state
GROUP BY StateProvinceName;
