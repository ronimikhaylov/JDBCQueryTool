
-- Problem Statement 2: Medium
-- Proposition: For each supplier, calculate the total number of days they
--  usually take for payment and categorize them based on their primary contact.



-- Using Subquery and Group By
SELECT 
    s.Supplier, 
    s.[Primary Contact],
    SUM(s.[Payment Days]) as TotalPaymentDays
FROM Dimension.Supplier AS s
JOIN (
    SELECT [Supplier Key], COUNT(*) as NumberOfTransactions
    FROM Fact.[Transaction]
    GROUP BY [Supplier Key]
) AS t
ON s.[Supplier Key] = t.[Supplier Key]
GROUP BY s.Supplier, s.[Primary Contact]

-- JSON Output
-- FOR JSON PATH;
