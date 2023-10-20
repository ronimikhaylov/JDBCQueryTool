-- 5
-- Medium Query:
-- Find out the total quantity of products ordered for each customer.
--  Also, retrieve the average invoice amount for these orders.




WITH InvoiceTotal AS (
    SELECT i.CustomerID, SUM(il.ExtendedPrice) AS TotalInvoiceAmount
    FROM Sales.Invoices AS i
    JOIN Sales.InvoiceLines AS il ON i.InvoiceID = il.InvoiceID
    GROUP BY i.CustomerID
)

SELECT c.CustomerName, SUM(ol.Quantity) AS TotalQuantity, AVG(it.TotalInvoiceAmount) AS AvgInvoiceAmount
FROM Sales.Customers AS c
JOIN Sales.Orders AS o ON c.CustomerID = o.CustomerID
JOIN Sales.OrderLines AS ol ON o.OrderID = ol.OrderID
JOIN InvoiceTotal AS it ON c.CustomerID = it.CustomerID
GROUP BY c.CustomerName, it.TotalInvoiceAmount

ORDER BY CustomerName, TotalQuantity, AvgInvoiceAmount;