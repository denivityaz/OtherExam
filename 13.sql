-- Check if the Menu_sad Database exists and drop if it does
IF DB_ID('Menu_sad') IS NOT NULL
BEGIN
    ALTER DATABASE Menu_sad SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Menu_sad;
    PRINT 'Existing Menu_sad database dropped.';
END

-- Create the Menu_sad Database with specified file sizes
CREATE DATABASE Menu_sad
ON (NAME = Menu_sad_Data,
    FILENAME = 'C:\SQLData\Menu_sadData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Menu_sad_Log,
        FILENAME = 'C:\SQLData\Menu_sadLog.ldf',
    SIZE = 2MB);
PRINT 'Menu_sad database created successfully.';

-- Use the Menu_sad Database
USE Menu_sad;

-- Create table zavtrak_menu
CREATE TABLE zavtrak_menu (
    DishID INT PRIMARY KEY IDENTITY(1,1),
    DishName NVARCHAR(100),
    Type NVARCHAR(50),
    IsForAllergics BIT
);

-- Insert sample data into zavtrak_menu
INSERT INTO zavtrak_menu (DishName, Type, IsForAllergics) VALUES
('Oatmeal', 'Porridge', 0),
('Rice Porridge', 'Porridge', 1),
('Corn Porridge', 'Porridge', 0),
('Buckwheat Porridge', 'Porridge', 1),
('Wheat Porridge', 'Porridge', 0),
('Tea', 'Drink', 0),
('Coffee', 'Drink', 1),
('Juice', 'Drink', 0),
('Cocoa', 'Drink', 1),
('Water', 'Drink', 0),
('Croissant', 'Bakery', 0),
('Bagel', 'Bakery', 1),
('Muffin', 'Bakery', 0),
('Bread', 'Bakery', 1),
('Pancake', 'Bakery', 0);

-- Create table products
CREATE TABLE products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100),
    ContainsFat BIT
);

-- Insert sample data into products
INSERT INTO products (ProductName, ContainsFat) VALUES
('Milk', 1),
('Apple', 0),
('Flour', 0),
('Sugar', 0),
('Butter', 1),
('Eggs', 1),
('Salt', 0),
('Honey', 0),
('Nuts', 1),
('Berries', 0);

-- Create table diet_menu
CREATE TABLE diet_menu (
    MenuID INT PRIMARY KEY IDENTITY(1,1),
    ChildLastName NVARCHAR(100),
    ChildGroup NVARCHAR(100),
    DishID INT,
    FOREIGN KEY (DishID) REFERENCES zavtrak_menu(DishID)
);

-- Create user Cook who can modify and add dishes to zavtrak_menu
CREATE LOGIN Cook WITH PASSWORD = 'SecurePassword1';
CREATE USER Cook FOR LOGIN Cook;
GRANT INSERT, UPDATE ON zavtrak_menu TO Cook;

-- Backup the database
BACKUP DATABASE Menu_sad TO DISK = 'C:\Backup\Menu_sad.bak' WITH INIT, NAME = 'Full Backup of Menu_sad';

-- Display database file information
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Menu_sad');
