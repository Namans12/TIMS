-- Query to fetch all products with low stock
SELECT ProductName, StockLevel, ReorderPoint
FROM Products
WHERE StockLevel <= ReorderPoint;

-- Query to get all orders with their supplier and product details
SELECT o.OrderID, p.ProductName, s.SupplierName, o.OrderDate, o.Quantity, o.OrderStatus
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
JOIN Suppliers s ON o.SupplierID = s.SupplierID;

-- Query to get supplier contact information for a specific product
SELECT p.ProductName, s.SupplierName, s.SupplierContact
FROM Products p
JOIN Suppliers s ON p.ProductID = s.SupplierID
WHERE p.ProductName = 'Cisco ISR 1101';
