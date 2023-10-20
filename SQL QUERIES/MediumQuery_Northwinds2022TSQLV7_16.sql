-- Problem Statement 1 (Medium):
-- Proposition: Determine the total number of orders made by each customer, 
-- along with the company's details.

USE [Northwinds2022TSQLV7]
GO
-- CTE to count total orders for each customer
WITH CustomerOrders AS (
    SELECT 
        c.CustomerId,                 -- Selecting the customer ID
        COUNT(o.OrderId) AS TotalOrders -- Counting the number of orders associated with each customer
    FROM 
        Sales.Customer c            -- Starting with the Customer table as our main data source
    LEFT JOIN 
        Sales.[Order] o ON c.CustomerId = o.CustomerId -- Using a LEFT JOIN to ensure all customers are included, even if they have no orders
    GROUP BY
        c.CustomerId                -- Grouping by customer ID to aggregate order counts
)

-- Main query to fetch customer details along with order counts
SELECT 
    c.CustomerId,
    c.CustomerContactName,
    co.TotalOrders                 -- Getting the total order count from our CTE
FROM 
    Sales.Customer c
JOIN
    CustomerOrders co ON c.CustomerId = co.CustomerId -- Joining our CTE to get the total order counts for each customer
ORDER BY
    co.TotalOrders DESC;           -- Ordering the results by the number of orders in descending order to see customers with the most orders first
