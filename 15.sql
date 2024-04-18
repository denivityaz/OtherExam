-- Проверка наличия базы данных и удаление, если она существует
IF DB_ID('Sclad') IS NOT NULL
BEGIN
    ALTER DATABASE Sclad SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Sclad;
    PRINT 'Existing Sclad database dropped.';
END

-- Создание базы данных Sclad
CREATE DATABASE Sclad
ON (NAME = Sclad_Data,
    FILENAME = 'C:\SQLData\ScladData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Sclad_Log,
        FILENAME = 'C:\SQLData\ScladLog.ldf',
        SIZE = 2MB);
PRINT 'Sclad database created successfully.';

-- Использование базы данных Sclad
USE Sclad;

-- Создание таблицы tovar1
CREATE TABLE tovar1 (
    ProductID INT PRIMARY KEY IDENTITY,
    ProductName NVARCHAR(100),
    Quantity INT,
    SupplierPrice DECIMAL(10, 2),
    StorePrice AS (SupplierPrice * 1.30),
    SupplierID INT
);

-- Создание таблицы Postavka
CREATE TABLE Postavka (
    SupplierID INT PRIMARY KEY IDENTITY,
    SupplierName NVARCHAR(100),
    ContactInfo NVARCHAR(100),
    ProductID INT,
    ProductPrice DECIMAL(10, 2),
    FOREIGN KEY (ProductID) REFERENCES tovar1(ProductID)
);

-- Вставка данных в таблицу tovar1
INSERT INTO tovar1 (ProductName, Quantity, SupplierPrice, SupplierID) VALUES
('Shampoo', 50, 100.00, 1),
('Conditioner', 40, 80.00, 2),
('Soap', 200, 20.00, 3),
('Toothpaste', 150, 30.00, 4),
('Perfume', 20, 500.00, 5);

-- Вставка данных в таблицу Postavka
INSERT INTO Postavka (SupplierName, ContactInfo, ProductID, ProductPrice) VALUES
('Supplier A', '123-456-7890', 1, 100.00),
('Supplier B', '234-567-8901', 2, 80.00),
('Supplier C', '345-678-9012', 3, 20.00),
('Supplier D', '456-789-0123', 4, 30.00),
('Supplier E', '567-890-1234', 5, 500.00);

-- Создание представления для косметических товаров с ценой магазина
CREATE VIEW CosmeticProducts AS
SELECT ProductName, StorePrice
FROM tovar1;

-- Создание процедуры для обновления стоимости товара
CREATE PROCEDURE UpdateSupplierPrice
    @ProductID INT,
    @NewSupplierPrice DECIMAL(10, 2)
AS
BEGIN
    UPDATE tovar1
    SET SupplierPrice = @NewSupplierPrice
    WHERE ProductID = @ProductID;
END;

-- Вывод информации о базе данных
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Sclad');

/*
### Шаг 2: Создание задания для резервного копирования
1. В Object Explorer (меню слева) под "SQL Server Agent" найдите папку "Jobs".
2. Кликните правой кнопкой мыши по "Jobs" и выберите "New Job".
3. В окне "New Job":
   - Введите имя задания, например, `Daily Backup for Монеты`.
   - Во вкладке "Steps" нажмите "New" для создания шага задания:
     - В поле "Step name" введите имя шага, например, `Backup Database`.
     - В "Type" выберите "Transact-SQL script (T-SQL)".
     - Убедитесь, что в "Database" выбрана ваша база данных "Магнит".
     - В поле "Command" введите команду резервного копирования:
       ```sql
       BACKUP DATABASE Магнит TO DISK = 'C:\Backup\Монеты.bak' WITH INIT;
       ```
       Убедитесь, что путь `C:\Backup\` существует на сервере и доступен для записи.
4. Перейдите на вкладку "Schedules" и создайте новое расписание:
   - Нажмите "New".
   - В поле "Name" введите имя расписания, например, `Everyday at Midnight`.
   - Выберите "Recurring".
   - В "Frequency" установите "Daily" и настройте выполнение задания каждый день.
   - В "Daily frequency" установите "Occurs once at" и задайте время `21:00:00`.
   - Нажмите "OK" для сохранения расписания.

### Шаг 3: Сохранение и запуск задания
1. Вернитесь в окно "New Job" и нажмите "OK" для сохранения задания.
2. Задание настроено и будет автоматически выполняться каждый день в полночь.

*/

--Чтобы импортировать данные из таблицы "Postavka" в Excel и сохранить их в файле с именем "Postavka.xls", вы можете выполнить следующие шаги:

--1. Откройте Microsoft Excel.
--2. В верхней панели меню выберите вкладку "Данные".
--3. В разделе "Источники данных" выберите "От других источников" и затем "Из SQL Server".
--4. Введите имя вашего сервера SQL Server, выберите метод аутентификации и введите учетные данные, если это необходимо.
--5. Выберите базу данных "Sclad" и таблицу "Postavka".
--6. Нажмите на кнопку "Открыть".
--7. После того как данные будут успешно импортированы, выберите "Файл" -> "Сохранить как".
--8. Введите имя файла "Postavka.xls" в поле "Имя файла" и выберите формат файла "Таблица Excel (*.xls)".
--9. Нажмите на кнопку "Сохранить".

--Теперь у вас будет файл Excel с данными из таблицы "Postavka" и названием "Postavka.xls".