
import java.sql.*;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

public class project1 {
    // Data structure to hold the queries, databases and their descriptions
    static class QueryData {
        String databaseName;
        String query;
        String description;

        public QueryData(String databaseName, String query, String description) {
            this.databaseName = databaseName;
            this.query = query;
            this.description = description;
        }
    }

    // List of all queries, databases and descriptions
    static final QueryData[] QUERIES = {

            new QueryData("Northwinds2022TSQLV7",
                    "WITH DiscontinuedTopProducts AS (\n" + //
                            "    SELECT TOP 5 p.ProductID, p.ProductName, SUM(d.Quantity) AS TotalQuantityOrdered \n" + //
                            "    FROM Production.Product p JOIN Sales.OrderDetail d ON p.ProductID = d.ProductID \n" + //
                            "    WHERE p.Discontinued = 1 \n" + //
                            "    GROUP BY p.ProductID, p.ProductName \n" + //
                            "    ORDER BY TotalQuantityOrdered DESC\n" + //
                            ") \n" + //
                            "SELECT dt.ProductName, c.CustomerID, c.CustomerCompanyName AS CustomerName, s.SupplierCompanyName AS SupplierName, SUM(od.Quantity) AS CustomerTotalQuantityOrdered \n"
                            + //
                            "FROM DiscontinuedTopProducts dt JOIN Sales.OrderDetail od ON dt.ProductID = od.ProductID \n"
                            + //
                            "JOIN Sales.[Order] o ON od.OrderID = o.OrderID \n" + //
                            "JOIN Sales.Customer c ON o.CustomerID = c.CustomerID \n" + //
                            "JOIN Production.Product p ON od.ProductID = p.ProductID \n" + //
                            "JOIN Production.Supplier s ON p.SupplierID = s.SupplierID \n" + //
                            "GROUP BY dt.ProductName, c.CustomerID, c.CustomerCompanyName, s.SupplierCompanyName \n" + //
                            "ORDER BY dt.ProductName, CustomerTotalQuantityOrdered DESC;",
                    "Find the top 5 products (based on total quantity ordered) that were discontinued but have had a significant sales impact. For these products, list down the customers who have ordered them the most, the total quantity they've ordered, and the corresponding supplier of the product."),

            new QueryData("WideWorldImporters",
                    "SELECT c.CustomerName, ct.CityName \n" + //
                            "FROM Sales.Customers AS c \n" + //
                            "JOIN Application.Cities AS ct ON c.DeliveryCityID = ct.CityID;",
                    "Retrieve the names of customers and the cities they reside in."),

            new QueryData("AdventureWorks2017",
                    "WITH ProductCTE AS (\n" + //
                            "    SELECT pc.Name AS ProductCategoryName, p.ListPrice\n" + //
                            "    FROM Production.Product AS p\n" + //
                            "    JOIN Production.ProductSubcategory AS ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID\n"
                            + //
                            "    JOIN Production.ProductCategory AS pc ON ps.ProductCategoryID = pc.ProductCategoryID\n"
                            + //
                            ")\n" + //
                            "SELECT ProductCategoryName, AVG(ListPrice) AS AverageListPrice, COUNT(ProductCategoryName) AS NumberOfProducts\n"
                            + //
                            "FROM ProductCTE\n" + //
                            "GROUP BY ProductCategoryName;",
                    "Calculate the average list price for products within each product category and find out how many products exist in each category."),

            new QueryData("PrestigeCars",
                    "WITH CarSales AS (\n" + //
                            "    SELECT s.SalesID, sd.SalePrice, st.ModelID\n" + //
                            "    FROM Data.Sales s\n" + //
                            "    JOIN Data.SalesDetails sd ON s.SalesID = sd.SalesID\n" + //
                            "    JOIN Data.Stock st ON sd.StockID = st.StockCode\n" + //
                            "    WHERE YEAR(s.SaleDate) = 2018\n" + //
                            "), CarSalesWithMake AS (\n" + //
                            "    SELECT cs.SalesID, cs.SalePrice, m.MakeName\n" + //
                            "    FROM CarSales cs\n" + //
                            "    JOIN Data.Model mo ON cs.ModelID = mo.ModelID\n" + //
                            "    JOIN Data.Make m ON mo.MakeID = m.MakeID\n" + //
                            ")\n" + //
                            "SELECT MakeName, COUNT(SalesID) as TotalSales, AVG(SalePrice) as AverageSalePrice, MAX(SalePrice) as MaxSalePrice\n"
                            + //
                            "FROM CarSalesWithMake\n" + //
                            "GROUP BY MakeName\n" + //
                            "ORDER BY MaxSalePrice DESC;",
                    "Determine the total sales for each car make for the year 2018. Alongside, calculate the average sale price for each car make, as well as identify the most expensive car sold for each make."),

            new QueryData("WideWorldImportersDW",
                    "WITH [Average Transaction] AS (\n" + //
                            "    SELECT [Supplier Key], AVG([Total Excluding Tax]) as AvgValue\n" + //
                            "    FROM Fact.[Transaction]\n" + //
                            "    GROUP BY [Supplier Key]\n" + //
                            "), [Total Transactions] AS (\n" + //
                            "    SELECT [Supplier Key], COUNT(*) as TotalTrans\n" + //
                            "    FROM Fact.[Transaction]\n" + //
                            "    GROUP BY [Supplier Key]\n" + //
                            ")\n" + //
                            "SELECT s.Supplier, t.TotalTrans, a.AvgValue\n" + //
                            "FROM Dimension.Supplier AS s\n" + //
                            "JOIN [Total Transactions] AS t ON s.[Supplier Key] = t.[Supplier Key]\n" + //
                            "JOIN [Average Transaction] AS a ON s.[Supplier Key] = a.[Supplier Key]\n" + //
                            "WHERE t.TotalTrans > 10\n" + //
                            "ORDER BY t.TotalTrans;",
                    "List the suppliers, the total number of Transactions they had, and the average value of their Transactions. Filter this list to include only suppliers with more than 10 Transactions."),

            new QueryData("AdventureWorksDW2017",
                    "DROP FUNCTION IF EXISTS MostPopularProduct;\n" + //
                            "GO\n" + //
                            "CREATE FUNCTION MostPopularProduct(@TerritoryKey INT) RETURNS NVARCHAR(255) AS\n" + //
                            "BEGIN\n" + //
                            "    DECLARE @ProductName NVARCHAR(255);\n" + //
                            "    SELECT TOP 1 @ProductName = p.EnglishProductName\n" + //
                            "    FROM dbo.FactInternetSales s\n" + //
                            "    JOIN dbo.DimProduct p ON s.ProductKey = p.ProductKey\n" + //
                            "    WHERE s.SalesTerritoryKey = @TerritoryKey\n" + //
                            "    GROUP BY p.EnglishProductName\n" + //
                            "    ORDER BY SUM(s.OrderQuantity) DESC;\n" + //
                            "    RETURN @ProductName;\n" + //
                            "END;\n" + //
                            "GO\n" + //
                            "WITH SalesTerritoryCTE AS (\n" + //
                            "    SELECT st.SalesTerritoryRegion, st.SalesTerritoryKey, s.SalesAmount, c.CustomerKey\n" + //
                            "    FROM dbo.DimSalesTerritory st\n" + //
                            "    JOIN dbo.FactInternetSales s ON st.SalesTerritoryKey = s.SalesTerritoryKey\n" + //
                            "    JOIN dbo.DimCustomer c ON s.CustomerKey = c.CustomerKey\n" + //
                            ")\n" + //
                            "SELECT SalesTerritoryRegion, SUM(SalesAmount) as TotalSales, COUNT(DISTINCT CustomerKey) as DistinctCustomers, dbo.MostPopularProduct(SalesTerritoryKey) as MostPopularProduct\n"
                            + //
                            "FROM SalesTerritoryCTE\n" + //
                            "GROUP BY SalesTerritoryRegion, SalesTerritoryKey;",
                    "For each sales territory, retrieve the total sales, the number of distinct customers, and the most popular product (based on quantity sold)."),

            new QueryData("Northwinds2022TSQLV7",
                    "WITH CustomerOrders AS (\n" + //
                            "    SELECT c.CustomerId, SUM(od.Quantity) AS TotalProductsOrdered\n" + //
                            "    FROM Sales.Customer c\n" + //
                            "    JOIN Sales.[Order] o ON c.CustomerId = o.CustomerId\n" + //
                            "    JOIN Sales.OrderDetail od ON o.OrderId = od.OrderId\n" + //
                            "    GROUP BY c.CustomerId\n" + //
                            ")\n" + //
                            "SELECT c.CustomerId, c.CustomerContactName, co.TotalProductsOrdered\n" + //
                            "FROM Sales.Customer c\n" + //
                            "JOIN CustomerOrders co ON c.CustomerId = co.CustomerId\n" + //
                            "ORDER BY CustomerId;",
                    "List down the total number of products ordered per customer along with their respective details."),

            new QueryData("PrestigeCars",
                    "SELECT s.StockCode, s.Color, sd.SalePrice, sd.LineItemDiscount\n" + //
                            "FROM Data.Stock s\n" + //
                            "JOIN Data.SalesDetails sd ON s.StockCode = sd.StockID;",
                    "Retrieve all stock codes and their respective colors along with the sales details, including the sale price and line item discount for each line item."),

            new QueryData("Northwinds2022TSQLV7",
                    "WITH CustomerOrders AS (\n" + //
                            "    SELECT c.CustomerId, COUNT(o.OrderId) AS TotalOrders\n" + //
                            "    FROM Sales.Customer c\n" + //
                            "    LEFT JOIN Sales.[Order] o ON c.CustomerId = o.CustomerId\n" + //
                            "    GROUP BY c.CustomerId\n" + //
                            ")\n" + //
                            "SELECT c.CustomerId, c.CustomerContactName, co.TotalOrders\n" + //
                            "FROM Sales.Customer c\n" + //
                            "JOIN CustomerOrders co ON c.CustomerId = co.CustomerId\n" + //
                            "ORDER BY TotalOrders DESC;",
                    "List down the total number of orders per customer, and sort the results based on the highest number of orders.")
    };

    public static void main(String[] args) {
        // Prompt user for database selection

        // boolean value for playagain
        boolean pl = true;
        while (pl) {
            String[] databases = {
                    "Northwinds2022TSQLV7", "WideWorldImporters", "AdventureWorks2017", "PrestigeCars",
                    "WideWorldImportersDW", "AdventureWorksDW2017", "Northwinds2022TSQLV7"
            };
            String selectedDb = (String) JOptionPane.showInputDialog(null, "Choose a database", "Database Selection",
                    JOptionPane.QUESTION_MESSAGE, null, databases, databases[0]);

            // Display queries related to the chosen database
            String[] descriptions = java.util.Arrays.stream(QUERIES)
                    .filter(q -> q.databaseName.equals(selectedDb))
                    .map(q -> q.description)
                    .toArray(String[]::new);
            String selectedDescription = (String) JOptionPane.showInputDialog(null, "Choose a query", "Query Selection",
                    JOptionPane.QUESTION_MESSAGE, null, descriptions, descriptions[0]);

            // Fetch the selected query
            String selectedQuery = java.util.Arrays.stream(QUERIES)
                    .filter(q -> q.description.equals(selectedDescription))
                    .findFirst()
                    .get().query;

            // Connection string
            String connectionString = "jdbc:sqlserver://localhost:13001;databaseName=" + selectedDb
                    + ";user=sa;password=PH@123456789;encrypt=true;trustServerCertificate=true";

            try (Connection conn = DriverManager.getConnection(connectionString)) {
                StringBuilder jsonOutput = new StringBuilder("[\n");
                if (selectedQuery.contains("GO")) {
                    String[] commands = selectedQuery.split("\\bGO\\b", -1);
                    for (String command : commands) {
                        if (command != null && !command.trim().isEmpty()) {
                            executeAndAppendToJson(command.trim(), conn, jsonOutput);
                        }
                    }
                } else {
                    executeAndAppendToJson(selectedQuery, conn, jsonOutput);
                }

                jsonOutput.append("]\n");

                // Display results in a scrollable pane
                JTextArea textArea = new JTextArea(20, 50);
                textArea.setText(jsonOutput.toString());
                textArea.setWrapStyleWord(true);
                textArea.setLineWrap(true);
                textArea.setCaretPosition(0);
                textArea.setEditable(false);
                JScrollPane scrollPane = new JScrollPane(textArea);
                JOptionPane.showMessageDialog(null, scrollPane, "Query Results", JOptionPane.INFORMATION_MESSAGE);
            } catch (SQLException e) {
                JOptionPane.showMessageDialog(null, "Error executing the query: " + e.getMessage());
            }

            // Prompt user to play again
            int playagain = JOptionPane.showConfirmDialog(null, "Would you like to play again?", "Play Again?",
                    JOptionPane.YES_NO_OPTION);
            if (playagain == JOptionPane.NO_OPTION) {
                pl = false;
            }
        }
    }

    private static void executeAndAppendToJson(String query, Connection conn, StringBuilder jsonOutput)
            throws SQLException {
        try (Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY)) {
            if (stmt.execute(query)) {
                ResultSet rs = stmt.getResultSet();
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();
                while (rs.next()) {
                    jsonOutput.append("  {\n");
                    for (int i = 1; i <= columnCount; i++) {
                        jsonOutput.append("    \"").append(metaData.getColumnName(i)).append("\": \"")
                                .append(rs.getString(i)).append("\"");
                        if (i < columnCount) {
                            jsonOutput.append(",");
                        }
                        jsonOutput.append("\n");
                    }
                    jsonOutput.append(rs.isLast() ? "  }\n" : "  },\n");
                }
            }
        }
    }

}
