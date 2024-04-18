-- Создание базы данных "Аптека" с заданными параметрами
CREATE DATABASE Аптека
ON 
(
    NAME = Аптека_Data,
    FILENAME = 'C:\SQLData\АптекаData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON 
(
    NAME = Аптека_Log,
    FILENAME = 'C:\SQLData\АптекаLog.ldf',
    SIZE = 2MB,
    FILEGROWTH = 1MB
);

SELECT * FROM sys.databases WHERE name = 'Аптека'




CREATE TABLE Витамины (
    id INT PRIMARY KEY,
    название NVARCHAR(100),
    стоимость DECIMAL(10, 2),
    количество INT
);

-- Внесение данных в таблицу "Витамины"
INSERT INTO Витамины (id, название, стоимость, количество) VALUES
(1, 'Витамин С', 799.99, 15),
(2, 'Витамин D3', 699.50, 20),
(3, 'Витамин B12', 899.00, 8),
(4, 'Витамин E', 599.75, 12),
(5, 'Витамин А', 999.25, 5);




CREATE TABLE Рецепт (
    id INT PRIMARY KEY,
    название NVARCHAR(100),
    количество INT
);

-- Внесение данных в таблицу "Рецепт"
INSERT INTO Рецепт (id, название, количество) VALUES
(1, 'Аспирин', 25),
(2, 'Ибупрофен', 30),
(3, 'Амоксициллин', 15),
(4, 'Диклофенак', 10),
(5, 'Ацетилцистеин', 5);




CREATE VIEW Малоупаковочные_лекарства AS
SELECT * FROM Рецепт WHERE количество < 10;


SELECT * FROM Витамины WHERE стоимость BETWEEN 599 AND 999;





-- Создание логина для пользователя "Ревизор"
USE master;
CREATE LOGIN Ревизор WITH PASSWORD = 'password'; -- Замените 'password' на реальный пароль

-- Переключение на базу данных "Аптека"
USE Аптека;

-- Создание пользователя "Ревизор" в базе данных и связь с логином "Ревизор"
CREATE USER Ревизор FOR LOGIN Ревизор;



-- Предоставление разрешений пользователю "Ревизор" на изменение и добавление препаратов в обе таблицы
GRANT INSERT, UPDATE ON Витамины TO Ревизор;
GRANT INSERT, UPDATE ON Рецепт TO Ревизор;

--резервная копия (поменять имя бд)
BACKUP DATABASE Сессия TO DISK = 'C:\Backup\Сессия.bak' WITH INIT, NAME = 'Full Backup of Сессия';



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

