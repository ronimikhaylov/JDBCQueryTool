-- Simple Query for WideWorldImporters

-- 4 
-- Retrieve the names of customers and the cities they reside in.

USE [WideWorldImporters]
SELECT c.CustomerName, ct.CityName
FROM Sales.Customers AS c
JOIN Application.Cities AS ct ON c.DeliveryCityID = ct.CityID
-- FOR JSON PATH;
