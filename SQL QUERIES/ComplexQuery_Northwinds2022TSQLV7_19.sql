USE [Northwinds2022TSQLV7]

-- Problem Statement 4 (Complex):
-- Proposition: Find the customer who has spent the most on orders.
-- For this top customer, list down the products they've purchased, 
-- the respective suppliers of those products, and the total amount spent on each product.

-- Check if a function named 'TotalPrice' exists. If it does, drop it to ensure the script can be re-run without errors.
DROP FUNCTION IF EXISTS TotalPrice;
GO

-- Define a scalar function named 'TotalPrice' to compute the total price of an item based on its quantity and unit price.
CREATE FUNCTION TotalPrice(@quantity INT, @unitPrice DECIMAL(10, 2))
RETURNS DECIMAL(10, 2) -- The function returns a decimal value with a precision of 10 and scale of 2.
AS
BEGIN
    -- The total price is computed by multiplying the quantity with the unit price.
    RETURN @quantity * @unitPrice;
END;
GO

-- Declare an integer variable named '@TopSpenderCustomerID' to store the ID of the customer who has spent the most.
DECLARE @TopSpenderCustomerID INT;

-- Determine and store the 'CustomerID' of the top spender in the '@TopSpenderCustomerID' variable.
-- This is achieved by grouping orders by 'CustomerID' and summing the total amounts spent by each customer.
-- The customer with the highest total spend is then selected.
SELECT TOP 1 @TopSpenderCustomerID = o.CustomerID
FROM Sales.[Order] o
JOIN Sales.OrderDetail d ON o.OrderID = d.OrderID -- Join 'Order' and 'OrderDetail' tables on 'OrderID' to get details of each order.
GROUP BY o.CustomerID -- Group the results by 'CustomerID'.
ORDER BY SUM(d.Quantity * d.UnitPrice) DESC; -- Order the results in descending order based on the total spend.

-- Main query to retrieve detailed information for the top-spending customer.
SELECT 
    c.CustomerID, -- Customer's ID.
    p.ProductName, -- Name of the product the customer purchased.
    s.SupplierCompanyName AS SupplierName, -- Company name of the supplier who supplies the product.
    d.Quantity, -- Quantity of the product the customer purchased.
    dbo.TotalPrice(d.Quantity, d.UnitPrice) AS TotalAmountSpentOnProduct  -- Use the 'TotalPrice' function to compute the total amount spent on each product.
FROM 
    Sales.Customer c -- Select from the 'Customer' table in the 'Sales' schema.
JOIN Sales.[Order] o ON c.CustomerID = o.CustomerID -- Join with the 'Order' table to get the orders associated with each customer.
JOIN Sales.OrderDetail d ON o.OrderID = d.OrderID -- Join with the 'OrderDetail' table to get detailed information about each order.
JOIN Production.Product p ON d.ProductID = p.ProductID -- Join with the 'Product' table to get names and details of products.
JOIN Production.Supplier s ON p.SupplierID = s.SupplierID -- Join with the 'Supplier' table to get supplier information for each product.
WHERE c.CustomerID = @TopSpenderCustomerID -- Filter results to only show records associated with the top spender, as determined above.
ORDER BY dbo.TotalPrice(d.Quantity, d.UnitPrice) DESC; -- Order the results based on the total amount spent on each product, in descending order.
