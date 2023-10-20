--Problem Statement 3 (Medium):
-- Proposition: List down the total number of products ordered per customer along with their respective details.
USE [Northwinds2022TSQLV7]
GO
-- Using a CTE to calculate the total quantity of products ordered by each customer
WITH CustomerOrders AS (
    SELECT 
        c.CustomerId,              -- Selecting the customer ID
        SUM(od.Quantity) AS TotalProductsOrdered -- Calculating total products ordered by each customer
    FROM 
        Sales.Customer c
    JOIN 
        Sales.[Order] o ON c.CustomerId = o.CustomerId  -- Joining Customer table with Order table to relate customers with their orders
    JOIN
        Sales.OrderDetail od ON o.OrderId = od.OrderId -- Joining OrderDetail table to get order quantity
    GROUP BY 
        c.CustomerId
)

-- Main query to fetch customer details along with total products ordered
SELECT 
    c.CustomerId,
    c.CustomerContactName,
    co.TotalProductsOrdered       -- Getting the total products ordered from our CTE
FROM 
    Sales.Customer c
JOIN
    CustomerOrders co ON c.CustomerId = co.CustomerId
ORDER BY
    CustomerId; -- Ordering the results by the customer id
