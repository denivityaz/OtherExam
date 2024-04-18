-- Check if the Sony Database exists and drop if it does
IF DB_ID('Sony') IS NOT NULL
BEGIN
    ALTER DATABASE Sony SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Sony;
    PRINT 'Existing Sony database dropped.';
END

-- Create the Sony Database with specified file sizes
CREATE DATABASE Sony
ON (NAME = Sony_Data,
    FILENAME = 'C:\SQLData\SonyData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Sony_Log,
        FILENAME = 'C:\SQLData\SonyLog.ldf',
        SIZE = 2MB);
PRINT 'Sony database created successfully.';

-- Use the Sony Database
USE Sony;

-- Create sa user with a placeholder password
CREATE LOGIN sa WITH PASSWORD = 'De_05';

-- Create table films
CREATE TABLE films (
    FilmID INT PRIMARY KEY IDENTITY(1,1),
    Genre NVARCHAR(100),
    ReleaseYear INT,
    Director NVARCHAR(100),
    Screenwriter NVARCHAR(100)
);

-- Insert sample data into films
INSERT INTO films (Genre, ReleaseYear, Director, Screenwriter) VALUES
('Action', 2020, 'Director A', 'Screenwriter A'),
('Drama', 2021, 'Director B', 'Screenwriter B'),
('Comedy', 2019, 'Director C', 'Screenwriter C'),
('Horror', 2022, 'Director D', 'Screenwriter D'),
('Thriller', 2018, 'Director E', 'Screenwriter E'),
('Documentary', 2020, 'Director F', 'Screenwriter F'),
('Romance', 2019, 'Director G', 'Screenwriter G'),
('Sci-Fi', 2021, 'Director H', 'Screenwriter H'),
('Fantasy', 2022, 'Director I', 'Screenwriter I'),
('Musical', 2018, 'Director J', 'Screenwriter J');

-- Create table cinema1
CREATE TABLE cinema1 (
    CinemaID INT PRIMARY KEY IDENTITY(1,1),
    City NVARCHAR(100),
    MallName NVARCHAR(100),
    CinemaName NVARCHAR(100),
    Owner NVARCHAR(100),
    ContactNumber NVARCHAR(20),
    FilmID INT,
    FOREIGN KEY (FilmID) REFERENCES films(FilmID)
);

-- Insert sample data into cinema1
INSERT INTO cinema1 (City, MallName, CinemaName, Owner, ContactNumber, FilmID) VALUES
('Saint Petersburg', 'Mall SPB', 'Cinema SPB', 'Owner A', '1234567890', 1),
('Gatchina', 'Mall Gatchina', 'Cinema Gatchina', 'Owner B', '0987654321', 2),
('Saint Petersburg', 'Mall Nevsky', 'Cinema Nevsky', 'Owner C', '2345678901', 3),
('Gatchina', 'Mall Central', 'Cinema Central', 'Owner D', '3456789012', 4),
('Saint Petersburg', 'Mall East', 'Cinema East', 'Owner E', '4567890123', 5),
('Saint Petersburg', 'Mall West', 'Cinema West', 'Owner F', '5678901234', 6),
('Gatchina', 'Mall South', 'Cinema South', 'Owner G', '6789012345', 7),
('Saint Petersburg', 'Mall North', 'Cinema North', 'Owner H', '7890123456', 8),
('Gatchina', 'Mall OldTown', 'Cinema OldTown', 'Owner I', '8901234567', 9),
('Saint Petersburg', 'Mall NewCity', 'Cinema NewCity', 'Owner J', '9012345678', 10);

-- Create a view to show films in Saint Petersburg and Gatchina
CREATE VIEW FilmsInSpecificCities AS
SELECT f.FilmID, f.Genre, f.ReleaseYear, f.Director, f.Screenwriter, c.City
FROM films f
JOIN cinema1 c ON f.FilmID = c.FilmID
WHERE c.City IN ('Saint Petersburg', 'Gatchina');

-- Backup the database
BACKUP DATABASE Sony TO DISK = 'C:\Backup\Sony.bak' WITH INIT, NAME = 'Full Backup of Sony';

-- Display database file information
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Sony');

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

/*
Чтобы импортировать данные из таблицы "films" в Excel и сохранить их в файле с именем "films.xls", вы можете выполнить следующие шаги:

Откройте Microsoft Excel.
В верхней панели меню выберите вкладку "Данные".
В разделе "Источники данных" выберите "От других источников" и затем "Из SQL Server".
Введите имя вашего сервера SQL Server, выберите метод аутентификации и введите учетные данные, если это необходимо.
Выберите базу данных "Sony" и таблицу "films".
Нажмите на кнопку "Открыть".
После того как данные будут успешно импортированы, выберите "Файл" -> "Сохранить как".
Введите имя файла "films.xls" в поле "Имя файла" и выберите формат файла "Таблица Excel (*.xls)".
Нажмите на кнопку "Сохранить".

Теперь у вас будет файл Excel с данными из таблицы "films" и названием "films.xls"
*/