-- 2. Medium Query:
-- Problem Statement:
-- Determine the total sales price for each stock code, 
--- listing the stock's color, and the average line item discount provided for that stock.
WITH SalesSummary AS (
    SELECT s.StockCode, s.Color, SUM(sd.SalePrice) as TotalSales, AVG(sd.LineItemDiscount) as AvgDiscount
    FROM Data.Stock s
    JOIN Data.SalesDetails sd ON s.StockCode = sd.StockID
    GROUP BY s.StockCode, s.Color
)

SELECT ss.StockCode, 
    ss.Color,
    ss.TotalSalePrice,
    ss.AvgDiscount, 
    (
        SELECT 
            SalesSummary.StockCode AS 'StockCode', 
            SalesSummary.Color AS 'color', 
            SalesSummary.TotalSalePrice, AS 'totalSalePrice', 
            SalesSummary.AvgDiscount AS 'avgDiscount'
        FOR JSON PATH
    ) AS JSONOutput
FROM SalesSummary 





