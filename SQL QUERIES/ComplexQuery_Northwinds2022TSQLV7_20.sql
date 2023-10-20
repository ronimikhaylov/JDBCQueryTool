/**
(Complex)
Proposition: Find the top 5 products (based on total quantity ordered) that were discontinued but,
have had a significant sales impact (top 5 discontinued products based on the quantity ordered).
For these products, list down the customers who have ordered them 
the most, the total quantity they've ordered, and the corresponding supplier of the product.
**/

USE [Northwinds2022TSQLV7]  -- Set the context to the specified database.
GO  -- Execute the previous command.




-- CTE creation for identifying the top 5 discontinued products based on the quantity ordered.

WITH DiscontinuedTopProducts AS (
    SELECT TOP 5  -- Limit results to top 5 products.
        p.ProductID,  -- Select the ProductID for joining later.
        p.ProductName,  -- Select the product's name for display in the final result.
        SUM(d.Quantity) AS TotalQuantityOrdered  -- Aggregate the total quantity ordered per product.
    FROM 
        Production.Product p  -- Reference the Product table to get details about each product.
    JOIN 
        Sales.OrderDetail d ON p.ProductID = d.ProductID  -- Join with OrderDetail table on ProductID to get ordered quantities.
    WHERE 
        p.Discontinued = 1  -- Filter only the discontinued products.
    GROUP BY 
        p.ProductID, p.ProductName  -- Group by both ProductID and ProductName to get unique records per product.
    ORDER BY 
        TotalQuantityOrdered DESC  -- Sort by the total quantity ordered in descending order to get the top products first.
)

-- Main query to retrieve comprehensive details about the top 5 discontinued products, their customers, and associated suppliers.
SELECT 
    dt.ProductName,  -- Display the product's name.
    c.CustomerID,  -- Display the CustomerID for reference.
    c.CustomerCompanyName AS CustomerName,  -- Rename 'CustomerCompanyName' to 'CustomerName' for clarity.
    s.SupplierCompanyName AS SupplierName,  -- Rename 'SupplierCompanyName' to 'SupplierName' for clarity.
    SUM(od.Quantity) AS CustomerTotalQuantityOrdered  -- Aggregate the total quantity ordered by each customer for the product.
FROM 
    DiscontinuedTopProducts dt  -- Reference the CTE to get the top 5 discontinued products.
JOIN 
    Sales.OrderDetail od ON dt.ProductID = od.ProductID  -- Join with OrderDetail table on ProductID to get individual order details.
JOIN 
    Sales.[Order] o ON od.OrderID = o.OrderID  -- Join with Order table on OrderID to get details of the entire order.
JOIN 
    Sales.Customer c ON o.CustomerID = c.CustomerID  -- Join with Customer table on CustomerID to get customer details.
JOIN 
    Production.Product p ON od.ProductID = p.ProductID  -- Join with Product table to fetch product-related data (like the supplier ID).
JOIN 
    Production.Supplier s ON p.SupplierID = s.SupplierID  -- Join with Supplier table to get the name/details of the product's supplier.
GROUP BY
    dt.ProductName,  -- Group by the product's name to aggregate quantities per product.
    c.CustomerID,  -- Group by CustomerID to differentiate results for different customers.
    c.CustomerCompanyName,  -- Group by the company name of the customer to match with each specific product.
    s.SupplierCompanyName  -- Group by the company name of the supplier to ensure unique records per product, customer, and supplier.
ORDER BY 
    dt.ProductName,  -- First, order the results based on the product's name alphabetically.
    CustomerTotalQuantityOrdered DESC;  -- Then, within each product, order the results based on the quantity ordered by each customer in descending order.
