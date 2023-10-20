-- 1. Simple Query:
-- Problem Statement:
-- Retrieve all stock codes and their respective colors along with the sales details,
--  including the sale price and line item discount for each line item.
USE [PrestigeCars]

SELECT s.StockCode, s.Color, sd.SalePrice, sd.LineItemDiscount
FROM Data.Stock s
JOIN Data.SalesDetails sd ON s.StockCode = sd.StockID;

-- JSON Component
-- SELECT s.StockCode, s.Color, sd.SalePrice, sd.LineItemDiscount
-- FROM Data.Stock s
-- JOIN Data.SalesDetails sd ON s.StockCode = sd.StockID
-- FOR JSON AUTO;