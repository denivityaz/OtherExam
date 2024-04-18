-- Check if the Магнит Database exists and drop if it does
IF DB_ID('Магнит') IS NOT NULL
BEGIN
    ALTER DATABASE Магнит SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Магнит;
    PRINT 'Existing Магнит database dropped.';
END

-- Create the Магнит Database with specified file sizes
CREATE DATABASE Магнит
ON (NAME = Магнит_Data,
    FILENAME = 'C:\SQLData\МагнитData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Магнит_Log,
        FILENAME = 'C:\SQLData\МагнитLog.ldf',
        SIZE = 2MB);
PRINT 'Магнит database created successfully.';

-- Use the Магнит Database
USE Магнит;

-- Create sa user with a specified password
CREATE LOGIN sa WITH PASSWORD = 'De_05';

-- Create table Косметика
CREATE TABLE Косметика (
    ProductID INT PRIMARY KEY IDENTITY,
    ProductName NVARCHAR(100),
    Quantity INT,
    Price DECIMAL(10, 2),
    SupplierPrice DECIMAL(10, 2),
    SupplierID INT
);

-- Create table Postavka
CREATE TABLE Postavka (
    SupplierID INT PRIMARY KEY IDENTITY,
    SupplierName NVARCHAR(100),
    ContactInfo NVARCHAR(100),
    ProductID INT,
    FOREIGN KEY (ProductID) REFERENCES Косметика(ProductID)
);

-- Insert sample data into Косметика
INSERT INTO Косметика (ProductName, Quantity, Price, SupplierPrice, SupplierID) VALUES
('Lipstick', 10, 200.00, 150.00, 1),
('Foundation', 15, 350.00, 250.00, 2),
('Eyeliner', 5, 150.00, 120.00, 3),
('Mascara', 3, 180.00, 140.00, 4),
('Blush', 2, 160.00, 130.00, 5);

-- Insert sample data into Postavka
INSERT INTO Postavka (SupplierName, ContactInfo, ProductID) VALUES
('Supplier A', '123-456-7890', 1),
('Supplier B', '123-456-7891', 2),
('Supplier C', '123-456-7892', 3),
('Supplier D', '123-456-7893', 4),
('Supplier E', '123-456-7894', 5);

-- Create a view for products with low stock
CREATE VIEW LowStock AS
SELECT ProductName, Quantity
FROM Косметика
WHERE Quantity < 5;

-- Create a procedure to update supplier cost in Косметика
CREATE PROCEDURE UpdateSupplierPrice
    @ProductID INT,
    @NewPrice DECIMAL(10, 2)
AS
BEGIN
    UPDATE Косметика
    SET SupplierPrice = @NewPrice
    WHERE ProductID = @ProductID;
END;

SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Магнит');


/*
Для настройки автоматического ежедневного резервного копирования базы данных "Магнит" в Microsoft SQL Server, вы можете использовать SQL Server Agent, который позволяет создавать и управлять заданиями по расписанию. Вот подробная инструкция по настройке ежедневного резервного копирования через SQL Server Management Studio (SSMS):

### Шаг 1: Проверка и запуск SQL Server Agent
1. Откройте **SQL Server Management Studio (SSMS)**.
2. Подключитесь к вашему экземпляру SQL Server.
3. В **Object Explorer** найдите "SQL Server Agent". Если он не запущен (иконка красная), кликните правой кнопкой мыши и выберите "Start".

### Шаг 2: Создание задания для резервного копирования
1. В Object Explorer (меню слева) под "SQL Server Agent" найдите папку "Jobs".
2. Кликните правой кнопкой мыши по "Jobs" и выберите "New Job".
3. В окне "New Job":
   - Введите имя задания, например, `Daily Backup for Магнит`.
   - Во вкладке "Steps" нажмите "New" для создания шага задания:
     - В поле "Step name" введите имя шага, например, `Backup Database`.
     - В "Type" выберите "Transact-SQL script (T-SQL)".
     - Убедитесь, что в "Database" выбрана ваша база данных "Магнит".
     - В поле "Command" введите команду резервного копирования:
       ```sql
       BACKUP DATABASE Магнит TO DISK = 'C:\Backup\Магнит.bak' WITH INIT;
       ```
       Убедитесь, что путь `C:\Backup\` существует на сервере и доступен для записи.
4. Перейдите на вкладку "Schedules" и создайте новое расписание:
   - Нажмите "New".
   - В поле "Name" введите имя расписания, например, `Everyday at Midnight`.
   - Выберите "Recurring".
   - В "Frequency" установите "Daily" и настройте выполнение задания каждый день.
   - В "Daily frequency" установите "Occurs once at" и задайте время `00:00:00`.
   - Нажмите "OK" для сохранения расписания.

### Шаг 3: Сохранение и запуск задания
1. Вернитесь в окно "New Job" и нажмите "OK" для сохранения задания.
2. Задание настроено и будет автоматически выполняться каждый день в полночь.

*/