-- Создание базы данных Монеты
IF DB_ID('Монеты') IS NOT NULL
BEGIN
    ALTER DATABASE Монеты SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Монеты;
    PRINT 'Existing Монеты database dropped.';
END

CREATE DATABASE Монеты
ON (NAME = Монеты_Data,
    FILENAME = 'C:\SQLData\МонетыData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Монеты_Log,
        FILENAME = 'C:\SQLData\МонетыLog.ldf',
        SIZE = 2MB);
PRINT 'Монеты database created successfully.';

USE Монеты;

-- Создание таблицы Монета
CREATE TABLE Монета (
    CoinID INT PRIMARY KEY IDENTITY,
    Metal NVARCHAR(50),
    Country NVARCHAR(50),
    Denomination NVARCHAR(50),
    ActualCost DECIMAL(10, 2),
    CHECK (Metal IN ('золото', 'серебро', 'никель', 'медь'))
);

-- Вставка данных в таблицу Монета
INSERT INTO Монета (Metal, Country, Denomination, ActualCost) VALUES
('золото', 'Россия', '10 рублей', 1500.00),
('серебро', 'США', '1 доллар', 1200.00),
('никель', 'Канада', '5 центов', 30.00),
('медь', 'Великобритания', '2 пенса', 20.00),
('золото', 'Австрия', '100 евро', 8000.00),
('серебро', 'Австралия', '1 доллар', 900.00),
('медь', 'Индия', '5 рупий', 25.00),
('никель', 'Южная Корея', '100 вон', 100.00),
('серебро', 'Мексика', '10 песо', 300.00),
('золото', 'Китай', '500 юаней', 7500.00);

-- Создание представления для золотых монет
CREATE VIEW GoldCoins AS
SELECT * FROM Монета
WHERE Metal = 'золото';

-- Создание представления для монет из Австрии с стоимостью более 100 рублей
CREATE VIEW AustrianCoins AS
SELECT * FROM Монета
WHERE Country = 'Австрия' AND ActualCost > 100;


-- Вывод информации о базе данных
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Монеты');


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

--Чтобы импортировать данные из таблицы "Монета" в Excel и сохранить их в файле с именем "Монеты.xls", вы можете выполнить следующие шаги:

--1. Откройте Microsoft Excel.
--2. В верхней панели меню выберите вкладку "Данные".
--3. В разделе "Источники данных" выберите "От других источников" и затем "Из SQL Server".
--4. Введите имя вашего сервера SQL Server, выберите метод аутентификации и введите учетные данные, если это необходимо.
--5. Выберите базу данных "Монеты" и таблицу "Монета".
--6. Нажмите на кнопку "Открыть".
--7. После того как данные будут успешно импортированы, выберите "Файл" -> "Сохранить как".
--8. Введите имя файла "Монета.xls" в поле "Имя файла" и выберите формат файла "Таблица Excel (*.xls)".
--9. Нажмите на кнопку "Сохранить".

--Теперь у вас будет файл Excel с данными из таблицы "Монета" и названием "Монеты.xls".


/*
Для настройки автоматического ежедневного резервного копирования базы данных "Монеты" в Microsoft SQL Server, вы можете использовать SQL Server Agent, который позволяет создавать и управлять заданиями по расписанию. Вот подробная инструкция по настройке ежедневного резервного копирования через SQL Server Management Studio (SSMS):

### Шаг 1: Проверка и запуск SQL Server Agent
1. Откройте SQL Server Management Studio (SSMS).
2. Подключитесь к вашему экземпляру SQL Server.
3. В Object Explorer найдите "SQL Server Agent". Если он не запущен (иконка красная), кликните правой кнопкой мыши и выберите "Start".

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