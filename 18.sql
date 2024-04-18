-- Check if the Магазин Database exists and drop if it does
IF DB_ID('Магазин') IS NOT NULL
BEGIN
    ALTER DATABASE Магазин SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Магазин;
    PRINT 'Existing Магазин database dropped.';
END

-- Create the Магазин Database with specified file sizes
CREATE DATABASE Магазин
ON (NAME = Магазин_Data,
    FILENAME = 'C:\SQLData\МагазинData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Магазин_Log,
        FILENAME = 'C:\SQLData\МагазинLog.ldf',
        SIZE = 2MB);
PRINT 'Магазин database created successfully.';

-- Use the Магазин Database
USE Магазин;

-- Create Employees table
CREATE TABLE Сотрудники (
    ID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100),
    EmployeeNumber INT,
    Department NVARCHAR(50),
    Position NVARCHAR(50)
);

-- Create Products table
CREATE TABLE Товары (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    ProductCode INT,
    Quantity INT,
    Cost DECIMAL(10,2),
    Stock INT,
    Currency NVARCHAR(10) CONSTRAINT CHK_Currency CHECK (Currency = 'RUB') -- Currency constraint for Rubles only
);

-- Insert sample data into Employees
INSERT INTO Сотрудники (FullName, EmployeeNumber, Department, Position) VALUES
('Ivan Ivanov', 1001, 'Sales', 'Manager'),
('Maria Petrova', 1002, 'Sales', 'Assistant'),
('Sergey Sidorov', 1003, 'HR', 'Recruiter'),
('Olga Pavlova', 1004, 'IT', 'Developer'),
('Nikolay Nikolaev', 1005, 'Marketing', 'Director');

-- Insert sample data into Products
INSERT INTO Товары (Name, ProductCode, Quantity, Cost, Stock, Currency) VALUES
('Laptop', 101, 10, 50000.00, 5, 'RUB'),
('Smartphone', 102, 20, 30000.00, 10, 'RUB'),
('Tablet', 103, 15, 20000.00, 8, 'RUB'),
('Printer', 104, 5, 10000.00, 2, 'RUB'),
('Mouse', 105, 50, 500.00, 35, 'RUB');

-- Create a procedure to insert data into any table
CREATE PROCEDURE InsertData @tableName NVARCHAR(100), @data NVARCHAR(MAX)
AS
BEGIN
    DECLARE @DynamicSQL AS NVARCHAR(MAX);
    SET @DynamicSQL = 'INSERT INTO ' + @tableName + ' VALUES (' + @data + ');';
    EXEC sp_executesql @DynamicSQL;
END;

-- Create roles and assign permissions
CREATE ROLE storekeeper;
CREATE LOGIN salesman1 WITH PASSWORD = 'Password1';
CREATE LOGIN salesman2 WITH PASSWORD = 'Password2';
CREATE USER salesman1 FOR LOGIN salesman1;
CREATE USER salesman2 FOR LOGIN salesman2;
ALTER ROLE storekeeper ADD MEMBER salesman1;
ALTER ROLE storekeeper ADD MEMBER salesman2;
GRANT SELECT, UPDATE ON Товары TO storekeeper;
GRANT EXECUTE ON OBJECT::InsertData TO salesman2;

-- Backup the database
BACKUP DATABASE Магазин TO DISK = 'C:\Backup\Магазин.bak' WITH INIT, NAME = 'Full Backup of Магазин';

-- Display database file information
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Магазин');

-- Example to check input
SELECT * FROM Товары;
