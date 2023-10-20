-- Set the database context to AdventureWorksDW2017
USE [AdventureWorksDW2017]
GO

--3. Complex Query Problem Statement:
-- Problem: For each sales territory, retrieve the total sales, the number of distinct customers,
-- and the most popular product (based on quantity sold).

-- Check if the custom scalar function already exists in the database.
-- If it does, we'll drop it to create our new version.
DROP FUNCTION IF EXISTS MostPopularProduct;
GO

-- Creating a scalar function named MostPopularProduct that will take a SalesTerritoryKey 
-- as an argument and return the most popular product name for that sales territory.
CREATE FUNCTION MostPopularProduct(@TerritoryKey INT) 
RETURNS NVARCHAR(255) 
AS
BEGIN
    -- Declare a variable to hold the most popular product's name
    DECLARE @ProductName NVARCHAR(255)
    
    -- Select the top product based on the order quantity for the given sales territory
    SELECT TOP 1 
        @ProductName = p.EnglishProductName
    FROM 
        dbo.FactInternetSales s
    JOIN 
        dbo.DimProduct p ON s.ProductKey = p.ProductKey  -- Join sales to product details
    WHERE 
        s.SalesTerritoryKey = @TerritoryKey  -- Filter sales data for the provided territory
    GROUP BY 
        p.EnglishProductName  -- Group by product name to aggregate order quantities
    ORDER BY 
        SUM(s.OrderQuantity) DESC;  -- Order in descending to get the product with the highest quantity sold

    -- Return the most popular product's name
    RETURN @ProductName
END;
GO

-- Defining a Common Table Expression (CTE) named SalesTerritoryCTE
-- The purpose of this CTE is to aggregate sales data per sales territory 
-- and join with customer details.
WITH SalesTerritoryCTE AS (
    -- Select necessary fields
    SELECT 
        st.SalesTerritoryRegion,  -- Sales region like 'North America'
        st.SalesTerritoryKey,     -- A unique identifier for each sales territory
        s.SalesAmount,            -- Amount from each sale
        c.CustomerKey             -- A unique identifier for each customer
    FROM 
        dbo.DimSalesTerritory st
    JOIN 
        dbo.FactInternetSales s ON st.SalesTerritoryKey = s.SalesTerritoryKey  -- Join sales to territory details
    JOIN 
        dbo.DimCustomer c ON s.CustomerKey = c.CustomerKey  -- Join sales to customer details
)
-- Main Query to utilize the above CTE and get aggregated results along with the most popular product
SELECT 
    SalesTerritoryRegion,    -- The name of the sales region like 'North America'
    SUM(SalesAmount) as TotalSales,  -- Aggregating total sales for each sales territory region
    COUNT(DISTINCT CustomerKey) as DistinctCustomers,  -- Counting distinct customers for each sales territory region
    dbo.MostPopularProduct(SalesTerritoryKey) as MostPopularProduct  -- Calling the scalar function to get the most popular product for each sales territory
FROM 
    SalesTerritoryCTE  -- The source of data for this query is the CTE defined above
GROUP BY 
    SalesTerritoryRegion, SalesTerritoryKey;  -- Grouping by sales region and key to aggregate data at the sales territory level


-- FOR JSON PATH;
