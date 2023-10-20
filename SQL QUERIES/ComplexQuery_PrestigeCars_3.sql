
-- Problem:

-- Determine the total sales for each car make for the year 2018.
--  Alongside, calculate the average sale price for each car make, 
-- as well as identify the most expensive car sold for each make.

USE [PrestigeCars]
GO
WITH CarSales AS (
    SELECT 
        s.SalesID, 
        sd.SalePrice, 
        st.ModelID
    FROM Data.Sales s
    JOIN Data.SalesDetails sd ON s.SalesID = sd.SalesID
    JOIN Data.Stock st ON sd.StockID = st.StockCode
    WHERE YEAR(s.SaleDate) = 2018
)

, CarSalesWithMake AS (
    SELECT 
        cs.SalesID, 
        cs.SalePrice, 
        m.MakeName
    FROM CarSales cs
    JOIN Data.Model mo ON cs.ModelID = mo.ModelID
    JOIN Data.Make m ON mo.MakeID = m.MakeID
)

SELECT 
    MakeName, 
    COUNT(SalesID) as TotalSales, 
    AVG(SalePrice) as AverageSalePrice, 
    MAX(SalePrice) as MaxSalePrice
FROM CarSalesWithMake
GROUP BY MakeName
ORDER BY MaxSalePrice DESC;
