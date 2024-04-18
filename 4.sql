-- Check if the Menu Database exists and drop if necessary
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

-- Use the Menu Database
USE Menu;

-- Create a system administrator user
CREATE LOGIN sa WITH PASSWORD = 'De_05';
PRINT 'System administrator user created.';

-- Create table business_menu
CREATE TABLE business_menu (
    ID INT PRIMARY KEY IDENTITY(1,1),
    DishName NVARCHAR(100),
    DishType NVARCHAR(50),
    Proteins DECIMAL(5,2),
    Carbohydrates DECIMAL(5,2),
    Fats DECIMAL(5,2),
    Price DECIMAL(10,2),
    BaseIngredient NVARCHAR(50)
);

-- Sample insert into business_menu
INSERT INTO business_menu (DishName, DishType, Proteins, Carbohydrates, Fats, Price, BaseIngredient)
VALUES
('Caesar Salad', 'Starter', 5.2, 8.3, 16.2, 120.00, 'Chicken'),
('Beef Steak', 'Hot', 26.0, 0.0, 18.0, 300.00, 'Beef'),
('Fruit Drink', 'Drink', 0.0, 20.0, 0.0, 50.00, 'Fruit'),
('Cheese Cake', 'Dessert', 6.0, 20.0, 18.0, 150.00, 'Milk');

-- Calculate caloric value for each dish
SELECT DishName, (Proteins + Carbohydrates) * 4.1 + Fats * 9.3 AS CaloricValue FROM business_menu;

-- Update prices for milk-based dishes
UPDATE business_menu SET Price = Price / 2 WHERE BaseIngredient = 'Milk';

-- Delete dishes containing potato
DELETE FROM business_menu WHERE BaseIngredient = 'Potato';

-- Create a user who can modify business_menu
CREATE LOGIN Cook WITH PASSWORD = 'CookPassword';
CREATE USER Cook FOR LOGIN Cook;
GRANT INSERT, UPDATE ON business_menu TO Cook;
PRINT 'User Cook created and granted permissions.';

-- Backup the database
BACKUP DATABASE Menu TO DISK = 'C:\Backup\Menu.bak' WITH INIT, NAME = 'Full Backup of Menu';

-- Display database file information
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Menu');

-- Backup the database
BACKUP DATABASE College TO DISK = 'C:\Backup\College.bak' WITH INIT, NAME = 'Full Backup of College';

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
