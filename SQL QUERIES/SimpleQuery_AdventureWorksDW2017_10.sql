-- 1. Simple Query Problem Statement:
-- Problem: Retrieve a list of all customers and their recent purchase product details. We want to get the customer's full name and the product name of their most recent purchase.




USE [AdventureWorksDW2017]

SELECT 
    c.FirstName + ' ' + c.LastName as FullName, 
    p.EnglishProductName
FROM 
    dbo.DimCustomer c
JOIN 
    dbo.FactInternetSales s ON c.CustomerKey = s.CustomerKey
JOIN 
    dbo.DimProduct p ON s.ProductKey = p.ProductKey
ORDER BY 
    s.OrderDate DESC;

-- Formatted as JSON:
-- FOR JSON PATH;
