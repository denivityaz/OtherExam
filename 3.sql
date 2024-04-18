-- Check if the Menu Database exists and drop if it does
IF DB_ID('Menu') IS NOT NULL
BEGIN
    ALTER DATABASE Menu SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Menu;
    PRINT 'Existing Menu database dropped.';
END

-- Create the Menu Database with specified file sizes
CREATE DATABASE Menu
ON (NAME = Menu_Data,
    FILENAME = 'C:\SQLData\MenuData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Menu_Log,
        FILENAME = 'C:\SQLData\MenuLog.ldf',
        SIZE = 2MB);
PRINT 'Menu database created successfully.';

-- Switch to the Menu database
USE Menu;

-- Create business_menu table
CREATE TABLE business_menu (
    ID INT PRIMARY KEY IDENTITY(1,1),
    DishType NVARCHAR(50),
    DishName NVARCHAR(100),
    Price DECIMAL(10,2),
    Description NVARCHAR(255)
);

-- Create products table
CREATE TABLE products (
    ID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100),
    ContainsFat BIT,
    BaseIngredient NVARCHAR(100)
);

-- Insert sample data into business_menu
INSERT INTO business_menu (DishType, DishName, Price, Description)
VALUES
('Starter', 'Salad', 45.50, 'Fresh garden salad'),
('Hot', 'Steak', 98.00, 'Grilled sirloin steak'),
('Drink', 'Coffee', 35.00, 'Black coffee'),
('Dessert', 'Cake', 60.00, 'Chocolate cake');

-- Insert sample data into products
INSERT INTO products (ProductName, ContainsFat, BaseIngredient)
VALUES
('Tomato', 0, 'Tomato'),
('Olive Oil', 1, 'Olive'),
('Wheat Flour', 0, 'Wheat');

-- Query dishes by price range using three different methods
-- Method 1: Direct WHERE clause
SELECT * FROM business_menu WHERE Price BETWEEN 10 AND 99;

-- Method 2: Subquery
SELECT * FROM (SELECT * FROM business_menu) AS SubMenu WHERE Price BETWEEN 10 AND 99;

-- Method 3: Common Table Expression (CTE)
;WITH CTE_Menu AS (
    SELECT * FROM business_menu
)
SELECT * FROM CTE_Menu WHERE Price BETWEEN 10 AND 99;

-- Count dishes by type in reverse alphabetical order
SELECT DishType, COUNT(*) AS DishCount FROM business_menu
GROUP BY DishType
ORDER BY DishType DESC;

-- Display products without fat, ordered by base ingredient
SELECT * FROM products WHERE ContainsFat = 0 ORDER BY BaseIngredient;

-- Create user Cook
CREATE LOGIN Cook WITH PASSWORD = 'CookPassword';
CREATE USER Cook FOR LOGIN Cook;
GRANT INSERT, UPDATE ON business_menu TO Cook;

-- Backup the database
BACKUP DATABASE Menu TO DISK = 'D:\Backup\Menu.bak' WITH INIT, NAME = 'Full Backup of Menu';

-- Display database file information
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Menu');