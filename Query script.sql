-- Creating Customers table with all the attributes
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(20),
    LastName VARCHAR(20),
    Email VARCHAR(30),
    Phone VARCHAR(10),
    Address VARCHAR(200),
    State VARCHAR(25),
    PostalCode VARCHAR(10)
);

-- Creating Suppliers table with all the attributes
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(50),
    PhoneNumber VARCHAR(10)
);

-- Creating Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    ProductDescription TEXT,
    Price DECIMAL(8, 2),
    StockQuantity INT,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Creating Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    ShippingAddress VARCHAR(200),
    TotalAmount DECIMAL(8, 2),
    PaymentMethod VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Creating OrderDetails table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(8, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
-- Inserting records  into Suppliers
INSERT INTO Suppliers (SupplierID, SupplierName, PhoneNumber)
VALUES
(1, 'ABC Electronics', '022-40012345'),
(2, 'XYZ Supplies', '011-23456789'),
(3, 'TechCorp India', '080-98765432'),
(4, 'Gadget World', '040-66554433'),
(5, 'SuperTech Pvt Ltd', '033-24453322');

-- Inserting records  into Customers
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address, State, PostalCode)
VALUES
(1, 'Amit', 'Sharma', 'amit.sharma@gmail.com', '9876543210', '123 MG Road, Bangalore', 'Karnataka', '560001'),
(2, 'Priya', 'Desai', 'priya.desai@yahoo.com', '9998887777', '456 Banjara Hills, Hyderabad', 'Telangana', '500034'),
(3, 'Ravi', 'Patel', 'ravi.patel@rediffmail.com', '8899776655', '789 Lajpat Nagar, Delhi', 'Delhi', '110024'),
(4, 'Neha', 'Gupta', 'neha.gupta@outlook.com', '8222333444', '101 Marine Drive, Mumbai', 'Maharashtra', '400002'),
(5, 'Rahul', 'Singh', 'rahul.singh123@gmail.com', '9555667788', '202 Sector 14, Gurgaon', 'Haryana', '122018');

-- Inserting Records  into Products
INSERT INTO Products (ProductID, ProductName, ProductDescription, Price, StockQuantity, SupplierID)
VALUES
(1, 'Smartphone', 'Latest model smartphone with 128GB storage and 12MP camera', 25999.99, 150, 1),
(2, 'Laptop', '15.6-inch laptop with Intel i7 processor and 512GB SSD', 65999.99, 100, 2),
(3, 'Wireless Mouse', 'Ergonomic wireless mouse with rechargeable battery', 999.99, 500, 3),
(4, 'Bluetooth Speaker', 'Portable Bluetooth speaker with waterproof feature', 2999.99, 200, 4),
(5, 'Smart Watch', 'Water-resistant smart watch with heart rate monitor', 8999.99, 120, 5);

-- Inserting Records  into Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, ShippingAddress, TotalAmount, PaymentMethod)
VALUES
(1, 1, '2025-02-10', '123 MG Road, Bangalore, Karnataka', 26999.99, 'Credit Card'),
(2, 2, '2025-02-11', '456 Banjara Hills, Hyderabad, Telangana', 68999.99, 'Debit Card'),
(3, 3, '2025-02-12', '789 Lajpat Nagar, Delhi', 999.99, 'Net Banking'),
(4, 4, '2025-02-13', '101 Marine Drive, Mumbai, Maharashtra', 3299.99, 'Credit Card'),
(5, 5, '2025-02-14', '202 Sector 14, Gurgaon, Haryana', 10999.99, 'UPI');

-- Inserting Records into OrderDetails
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 1, 1, 1, 25999.99),
(2, 2, 2, 1, 65999.99),
(3, 3, 3, 2, 999.99),
(4, 4, 4, 1, 2999.99),
(5, 5, 5, 1, 8999.99);
select   *  from customers;
select   *  from suppliers;
select   *  from Products;
select   *  from orders;
select   *  from orderdetails;

--Query to retrieve orders for a specific customer
SELECT 
    c.FirstName, 
    c.LastName, 
    p.ProductName, 
    o.OrderDate, 
    od.Quantity 
FROM 
    Orders o
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
JOIN 
    Products p ON od.ProductID = p.ProductID
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
WHERE 
    c.CustomerID = 1;  -- We Can take any Customer id as per records and need 

----name of the most purchased product along with the total quantity sold.

SELECT 
    p.ProductName, 
    SUM(od.Quantity) AS TotalQuantity
FROM 
    OrderDetails od
JOIN 
    Products p ON od.ProductID = p.ProductID
GROUP BY 
    p.ProductName
ORDER BY 
    TotalQuantity DESC----this order the results in descending order of total quantity, so the most purchased product will be at the top
LIMIT 1;----LIMIT 1: This ensures only the top product (most purchased) is returned.



---Update the Stock Quantity of a product after an order is placed.

UPDATE Products
SET StockQuantity = StockQuantity - od.Quantity
FROM OrderDetails od
WHERE od.ProductID = Products.ProductID
AND od.OrderID = 101;  -- Updating stock for OrderID 101



---Steps to Delete a Customer's Record:
--Delete related records from the Orders and OrderDetails tables where the CustomerID is used, since these tables depend on the Customers table.
--Delete the customer record from the Customers table after removing the dependent records to avoid violating foreign key constraints.

--Deleting  from OrderDetails first to maintain referential integrity
DELETE FROM OrderDetails
WHERE OrderID IN (SELECT OrderID FROM Orders WHERE CustomerID = 1);

-- Delete from Orders table now 
DELETE FROM Orders
WHERE CustomerID = 1;

