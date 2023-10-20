-- 3. Complex Query:
-- Problem Statement: Calculate the total sales for each product category, 
-- and also retrieve the product with the highest sales in each category.

USE [AdventureWorks2017]

-- Drop the function if it already exists to avoid duplication or conflict.
DROP FUNCTION IF EXISTS dbo.GetTopSellingProduct;
GO

-- Create a new scalar function named 'GetTopSellingProduct'
CREATE FUNCTION dbo.GetTopSellingProduct(@CategoryID INT)
-- The function returns a NVARCHAR datatype (product name)
RETURNS NVARCHAR(50)
AS
BEGIN
    -- Declare a variable to store the top-selling product's name
    DECLARE @ProductName NVARCHAR(50)

    -- Start the query to fetch the top-selling product's name
    SELECT TOP 1 @ProductName = p.Name
    FROM 
        -- Use the 'Product' table as the main table
        Production.Product AS p

    -- Join the 'Product' table with 'SalesOrderDetail' to get sales data for each product
    JOIN 
        Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID

    -- Filter the products based on the category provided as a function parameter
    WHERE 
        p.ProductSubcategoryID IN 
        (
            -- This subquery fetches all subcategory IDs associated with the main category ID
            SELECT ProductSubcategoryID 
            FROM Production.ProductSubcategory 
            WHERE ProductCategoryID = @CategoryID
        )
    -- Order the products based on their total sales to get the top seller
    ORDER BY sod.LineTotal DESC

    -- Return the top-selling product's name
    RETURN @ProductName
END


GO
-- Use a Common Table Expression (CTE) named 'SalesCTE' 
WITH SalesCTE AS (
    -- Select relevant columns for calculation
    SELECT 
        -- Get the Product Category ID, used later for the custom scalar function
        pc.ProductCategoryID,

        -- Get the Product Category Name to group sales by
        pc.Name AS ProductCategoryName,

        -- Fetch the total of each sale line item for aggregation
        sod.LineTotal
    FROM 
        -- Start with the 'Product' table as the base
        Production.Product AS p

    -- Join the 'Product' table with the 'ProductSubcategory' table 
    -- on the shared ProductSubcategoryID to fetch subcategory details
    JOIN 
        Production.ProductSubcategory AS ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID

    -- Join the 'ProductSubcategory' table with the 'ProductCategory' table
    -- on the shared ProductCategoryID to fetch the main product category details
    JOIN 
        Production.ProductCategory AS pc ON ps.ProductCategoryID = pc.ProductCategoryID

    -- Join the 'Product' table with 'SalesOrderDetail' to get sales data for each product
    JOIN 
        Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
)

-- After the CTE definition, fetch the required data
SELECT 
    -- Group results by ProductCategoryName
    ProductCategoryName,

    -- Calculate the total sales for each Product Category
    ROUND(SUM(LineTotal), 2) AS TotalSales,

    -- Retrieve the product with the highest sales in each category
    -- Using the custom scalar function dbo.GetTopSellingProduct
    dbo.GetTopSellingProduct(ProductCategoryID) AS TopSellingProduct
FROM 
    -- Use the previously defined CTE for the data source
    SalesCTE

-- Group the result set by the product category to get aggregated sales
GROUP BY 
    ProductCategoryName, ProductCategoryID

--  order by Total Sales for better presentation
ORDER BY 
    TotalSales DESC;

