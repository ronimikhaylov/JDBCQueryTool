-- 2. Medium Query:
-- Problem Statement: Calculate the average list price for products 
-- within each product category and find out how many products exist in each category.


USE [AdventureWorks2017]
GO
WITH ProductCTE AS (
    SELECT 
        pc.Name AS ProductCategoryName,
        p.ListPrice
    FROM 
        Production.Product AS p
    JOIN 
        Production.ProductSubcategory AS ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN 
        Production.ProductCategory AS pc ON ps.ProductCategoryID = pc.ProductCategoryID
)
SELECT 
    ProductCategoryName, 
    AVG(ListPrice) AS AverageListPrice,
    COUNT(ProductCategoryName) AS NumberOfProducts
FROM 
    ProductCTE
GROUP BY 
    ProductCategoryName
-- FOR JSON AUTO;
