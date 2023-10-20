-- 1. Simple Query:
-- Problem Statement: Retrieve a list of all the products with their respective product categories.


USE [AdventureWorks2017]
SELECT 
    DISTINCT(p.Name) AS ProductName,
    pc.Name AS ProductCategoryName
FROM 
    Production.Product AS p
JOIN 
    Production.ProductSubcategory AS ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN 
    Production.ProductCategory AS pc ON ps.ProductCategoryID = pc.ProductCategoryID
-- FOR JSON AUTO;
