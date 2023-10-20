-- Problem Statement 2 (Medium):
-- Proposition: Retrieve the total sum of orders made by each employee and their respective details.

-- Using a CTE to calculate total order values for each employee
WITH EmployeeOrders AS (
    SELECT 
        e.EmployeeId,              -- Selecting the employee ID
        SUM(od.Quantity * od.UnitPrice) AS TotalSales -- Calculating total sales for each employee
    FROM 
        HumanResources.Employee e
    JOIN 
        Sales.[Order] o ON e.EmployeeId = o.EmployeeId  -- Joining Employee table with Order table to relate employees with their orders
    JOIN
        Sales.OrderDetail od ON o.OrderId = od.OrderId -- Joining OrderDetail table to get order quantity and unit price
    GROUP BY 
        e.EmployeeId
)

-- Main query to fetch employee details along with total sales
SELECT 
    e.EmployeeId,
    e.EmployeeFirstName,
    e.EmployeeLastName,
    eo.TotalSales                -- Getting the total sales from our CTE
FROM 
    HumanResources.Employee e
JOIN
    EmployeeOrders eo ON e.EmployeeId = eo.EmployeeId
ORDER BY
    eo.TotalSales DESC;          -- Ordering the results by the total sales in descending order




