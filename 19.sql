-- Check if the Комп Database exists and drop if it does
IF DB_ID('Комп') IS NOT NULL
BEGIN
    ALTER DATABASE Комп SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Комп;
    PRINT 'Existing Комп database dropped.';
END

-- Create the Комп Database with specified file sizes
CREATE DATABASE Комп
ON (NAME = Комп_Data,
    FILENAME = 'C:\SQLData\КомпData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Комп_Log,
        FILENAME = 'C:\SQLData\КомпLog.ldf',
        SIZE = 2MB);
PRINT 'Комп database created successfully.';

-- Use the Комп Database
USE Комп;

-- Create sa user with a specified password
CREATE LOGIN sa WITH PASSWORD = 'De_05';

-- Create table Товары
CREATE TABLE Товары (
    ItemID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    ProductCode INT,
    Quantity INT,
    Price DECIMAL(10,2),
    Stock INT
);

-- Create table Склад
CREATE TABLE Склад (
    WarehouseID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    ProductCode INT,
    Quantity INT,
    Price DECIMAL(10,2),
    Stock INT,
    NeededAmount INT
);

-- Insert sample data into Товары
INSERT INTO Товары (Name, ProductCode, Quantity, Price, Stock) VALUES
('Product A', 1001, 20, 500.00, 15),
('Product B', 1002, 15, 1500.00, 10),
('Product C', 1003, 25, 750.00, 20),
('Product D', 1004, 10, 250.00, 5),
('Product E', 1005, 30, 950.00, 25);

-- Insert sample data into Склад
INSERT INTO Склад (Name, ProductCode, Quantity, Price, Stock, NeededAmount) VALUES
('Warehouse A', 1001, 10, 500.00, 5, 5),
('Warehouse B', 1002, 5, 1500.00, 2, 3),
('Warehouse C', 1003, 15, 750.00, 10, 5),
('Warehouse D', 1004, 7, 250.00, 2, 3),
('Warehouse E', 1005, 20, 950.00, 15, 5);

-- Create role Ревизор and user Менеджер
CREATE LOGIN Менеджер WITH PASSWORD = 'Manager123';
CREATE USER Менеджер FOR LOGIN Менеджер;
CREATE ROLE Ревизор;
GRANT SELECT, UPDATE ON Склад TO Ревизор;
ALTER ROLE Ревизор ADD MEMBER Менеджер;

-- Query for selecting data from Склад
SELECT * FROM Склад;

-- Query to add data to Склад
-- Syntax: INSERT INTO Склад (Name, ProductCode, Quantity, Price, Stock, NeededAmount) VALUES ('New Warehouse', 1010, 50, 450.00, 25, 10);

-- Query to find available products in stock
SELECT * FROM Склад WHERE Stock > 0;

-- Backup the database
BACKUP DATABASE Комп TO DISK = 'D:\Backup\Комп.bak' WITH INIT, NAME = 'Full Backup of Комп';

-- Display database file information
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Комп');


-- Create 10 users with random passwords
DECLARE @i INT = 1;
WHILE @i <= 10
BEGIN
    DECLARE @password NVARCHAR(12) = LEFT(NEWID(), 5);
    DECLARE @sql NVARCHAR(MAX) = CONCAT('CREATE LOGIN user', @i, ' WITH PASSWORD = ''', @password, '''');
    EXEC sp_executesql @sql;
    SET @i = @i + 1;
END

-- Create 10 databases BD1 to BD10
DECLARE @j INT = 1;
WHILE @j <= 10
BEGIN
    DECLARE @sql2 NVARCHAR(MAX) = CONCAT('CREATE DATABASE BD', @j);
    EXEC sp_executesql @sql2;
    SET @j = @j + 1;
END
