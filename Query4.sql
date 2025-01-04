-- Load products data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Inventory_Product.csv'
INTO TABLE Products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProductName, Description, ProductImage, ProductCategory, ModelNumber, SerialNumber, StockLevel, ReorderPoint);

-- Load suppliers data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Inventory_Supplier.csv'
INTO TABLE Suppliers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(SupplierName, SupplierMail, SupplierContact);

-- Load orders data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Inventory_Order.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrderDate, Quantity, OrderStatus)
SET OrderDate = STR_TO_DATE(OrderDate, '%d-%m-%Y');
