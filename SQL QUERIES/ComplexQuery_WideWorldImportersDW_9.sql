-- Problem Statement 3: Complex
-- Proposition: List the suppliers,
-- the total number of Transactions they had, 
-- and the average value of their [Transaction]s. 
-- Filter this list to include only suppliers with more than 10 [Transaction]s.
USE[WideWorldImportersDW]
GO
-- Using CTE, Subquery, Custom Scalar Function, and Group By
WITH [Average Transaction] AS (
    SELECT [Supplier Key], AVG([Total Excluding Tax]) as AvgValue  -- Adjusted column to [Total Excluding Tax]
    FROM Fact.[Transaction] 
    GROUP BY [Supplier Key]
)

, [Total Transactions] AS (
    SELECT [Supplier Key], COUNT(*) as TotalTrans
    FROM Fact.[Transaction]
    GROUP BY [Supplier Key]
)

SELECT 
    s.Supplier,
    t.TotalTrans,
    a.AvgValue
FROM Dimension.Supplier AS s
JOIN [Total Transactions] AS t 
ON s.[Supplier Key] = t.[Supplier Key]
JOIN [Average Transaction] AS a  
ON s.[Supplier Key] = a.[Supplier Key]
WHERE t.TotalTrans > 10
ORDER BY t.TotalTrans
-- JSON Output
-- FOR JSON PATH;
