-- Problem Statement 1 (Simple):
-- "Identify the top 3 suppliers based on the number of transactions they have completed."

USE [WideWorldImportersDW]
SELECT TOP 3 Supplier, TransactionCount
FROM 
(
    SELECT S.Supplier, COUNT(T.[Transaction Type Key]) AS TransactionCount
    FROM Dimension.Supplier AS S
    JOIN Fact.[Transaction] AS T
    ON S.[Supplier Key] = T.[Supplier Key]
    GROUP BY S.Supplier
) AS Result
ORDER BY TransactionCount DESC;
