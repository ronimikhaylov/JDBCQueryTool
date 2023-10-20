USE [AdventureWorksDW2017];  -- This specifies which database to use, in this case, it's AdventureWorksDW2017

-- 2. Medium Query Problem Statement:
-- Problem: For each product category, find the total sales and the number of distinct products sold.

-- CTE (Common Table Expression) is used to simplify the main query and improve readability.
-- This CTE essentially joins a series of tables related to products, their categories, and sales.
WITH SalesCTE AS (
    -- Select relevant columns that will be used in the main query
    SELECT 
        pc.ProductCategoryKey,    -- Key for the product category
        pc.EnglishProductCategoryName,  -- The name of the product category in English
        s.SalesAmount,   -- The sales amount from the FactInternetSales table
        p.ProductKey     -- The key of the product, will be used to count distinct products
    FROM 
        dbo.DimProductSubcategory ps  -- Table that contains details about product subcategories
    -- Join the product subcategory with the product category on their common key
    JOIN 
        dbo.DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
    -- Join the product subcategory with the product on their common subcategory key
    JOIN 
        dbo.DimProduct p ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
    -- Join the product with its sales data on their common product key
    JOIN 
        dbo.FactInternetSales s ON p.ProductKey = s.ProductKey
)
-- The main query aggregates data at the product category level.
SELECT 
    EnglishProductCategoryName,  -- Grouping by product category name
    SUM(SalesAmount) as TotalSales,  -- Aggregate the total sales for each product category
    COUNT(DISTINCT ProductKey) as DistinctProductsSold  -- Count the number of unique products sold in each category
FROM 
    SalesCTE  -- Data source for this query is the CTE defined above
GROUP BY 
    EnglishProductCategoryName;  -- Aggregating results at the product category name level
