-- Создание базы данных с указанными размерами файлов
CREATE DATABASE Kvant
ON (NAME = Kvant_Data,
    FILENAME = 'C:\SQLData\KvantData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Kvant_Log,
        FILENAME = 'C:\SQLData\KvantLog.ldf',
        SIZE = 2MB);

SELECT * FROM sys.databases WHERE name = 'Kvant'

-- Создание таблиц для 'Product', 'Employees' и 'Warehouse'
USE Kvant;

CREATE TABLE Product (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100) UNIQUE,
    Price MONEY
);

CREATE TABLE Employees (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Password NVARCHAR(50),
    UNIQUE (Name)
);

CREATE TABLE Warehouse (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100) UNIQUE,
    Quantity INT
);

INSERT INTO Product (ID, Name, Price) VALUES
(1, 'Logitech Mouse', 20.50),
(2, 'Microsoft Mouse', 18.75),
(3, 'Razer Mouse', 35.99),
(4, 'HP Mouse', 15.25),
(5, 'Dell Mouse', 22.00);

INSERT INTO Employees (ID, Name, Password) VALUES
(1, 'Seller', 'seller_password'),
(2, 'Warehouse1', 'warehouse1_password');

INSERT INTO Warehouse (ID, Name, Quantity) VALUES
(1, 'Logitech Mouse', 50),
(2, 'Microsoft Mouse', 40),
(3, 'Razer Mouse', 30),
(4, 'HP Mouse', 20),
(5, 'Dell Mouse', 10);


-- Создание логина для администратора базы данных
USE master;
CREATE LOGIN DBAdmin WITH PASSWORD = 'admin_password'; -- Создание логина с паролем для администратора

USE Kvant; -- Предполагается, что Kvant - это название вашей базы данных

-- Создание пользователя для администратора базы данных
CREATE USER DBAdmin FOR LOGIN DBAdmin;

-- Предоставление права SELECT на таблицу Employees администратору базы данных
GRANT SELECT ON Employees TO DBAdmin;

-- Отказ в праве SELECT на таблицу Employees для всех остальных пользователей или ролей
DENY SELECT ON Employees TO PUBLIC;


-- Создание пользователей и назначение прав доступа
USE master;

CREATE LOGIN Seller WITH PASSWORD = 'seller_password';
CREATE LOGIN Warehouse1 WITH PASSWORD = 'warehouse1_password';

USE Kvant;

CREATE USER Seller FOR LOGIN Seller;
CREATE USER Warehouse1 FOR LOGIN Warehouse1;

GRANT SELECT ON Product TO Seller;
GRANT SELECT ON Warehouse TO Seller;
DENY SELECT ON Warehouse TO Seller;

GRANT UPDATE ON Warehouse TO Warehouse1;

-- Создание хранимой процедуры для обновления записей в таблице 'Product' из таблицы 'Warehouse'
CREATE PROCEDURE UpdateProductFromWarehouse
AS
BEGIN
    UPDATE Product
    SET Price = W.Quantity
    FROM Product P
    INNER JOIN Warehouse W ON P.Name = W.Name;
END;


-- Создание представления для отображения наличия мышек в таблице 'Product'
CREATE VIEW MouseAvailability AS
SELECT Product.*, Warehouse.Quantity AS Availability
FROM Product
INNER JOIN Warehouse ON Product.Name = Warehouse.Name
WHERE Product.Name LIKE '%Mouse%';




-- Create 10 users with random passwords
DECLARE @i INT = 1;
WHILE @i <= 10
BEGIN
    DECLARE @password NVARCHAR(12) = CONCAT('u', @i, '_', NEWID());
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


--резервная копия (поменять имя бд)
BACKUP DATABASE Сессия TO DISK = 'C:\Backup\Сессия.bak' WITH INIT, NAME = 'Full Backup of Сессия';