-- Table for product details
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Description TEXT,
    ProductImage VARCHAR(255),
    ProductCategory VARCHAR(100),
    ModelNumber VARCHAR(100),
    SerialNumber VARCHAR(100) UNIQUE,
    StockLevel INT,
    ReorderPoint INT
);

-- Table for suppliers
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(255) NOT NULL,
    SupplierMail VARCHAR(255),
    SupplierContact VARCHAR(15)
);

-- Table for orders
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    SupplierID INT,
    OrderDate DATE,
    Quantity INT,
    OrderStatus VARCHAR(50),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);
