-- Создание базы данных "Кинотеатр_название" с указанными параметрами
CREATE DATABASE Кинотеатр_название
ON 
(
    NAME = Кинотеатр_название_Data,
    FILENAME = 'C:\SQLData\Кинотеатр_название_Data.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON 
(
    NAME = Кинотеатр_название_Log,
    FILENAME = 'C:\SQLData\Кинотеатр_название_Log.ldf',
    SIZE = 2MB,
    FILEGROWTH = 1MB
);

-- Проверка существования базы данных "Кинотеатр_название"
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Кинотеатр_название')
    PRINT 'База данных "Кинотеатр_название" уже существует.';
ELSE
    PRINT 'База данных "Кинотеатр_название" не существует.';



-- Create sa user with a placeholder password
CREATE LOGIN sa WITH PASSWORD = 'De_05';



CREATE TABLE Кинотеатр (
    id INT PRIMARY KEY,
    название_фильма NVARCHAR(100),
    время_сеанса DATETIME,
    количество_билетов INT
);

INSERT INTO Кинотеатр (id, название_фильма, время_сеанса, количество_билетов) VALUES
(1, 'Фильм 1', CONVERT(DATETIME, '2024-04-18 18:00:00', 120), 150),
(2, 'Фильм 2', CONVERT(DATETIME, '2024-04-19 19:30:00', 120), 200),
(3, 'Фильм 3', CONVERT(DATETIME, '2024-04-20 20:15:00', 120), 180),
(4, 'Фильм 4', CONVERT(DATETIME, '2024-04-21 17:45:00', 120), 120),
(5, 'Фильм 5', CONVERT(DATETIME, '2024-04-22 21:00:00', 120), 250),
(6, 'Фильм 6', CONVERT(DATETIME, '2025-04-22 21:00:00', 120), 250);



CREATE TABLE Архив (
    id INT PRIMARY KEY,
    название_фильма NVARCHAR(100),
    статус NVARCHAR(50) CHECK (статус IN ('Прокат', 'Завершен')),
    количество_проданных_билетов INT
);

-- Внесение данных в таблицу "Архив"
INSERT INTO Архив (id, название_фильма, статус, количество_проданных_билетов) VALUES
(1, 'Фильм 6', 'Прокат', 300),
(2, 'Фильм 7', 'Прокат', 280),
(3, 'Фильм 8', 'Прокат', 320),
(4, 'Фильм 9', 'Завершен', 400),
(5, 'Фильм 10', 'Завершен', 350);




CREATE TABLE Прокат (
    id INT PRIMARY KEY,
    название_фильма NVARCHAR(100),
    стоимость DECIMAL(10, 2)
);

-- Внесение данных в таблицу "Прокат"
INSERT INTO Прокат (id, название_фильма, стоимость) VALUES
(1, 'Фильм 11', 200.00),
(2, 'Фильм 12', 180.00),
(3, 'Фильм 13', 220.00),
(4, 'Фильм 14', 250.00),
(5, 'Фильм 15', 150.00);




CREATE VIEW Фильмы_следующего_года AS
SELECT *
FROM Кинотеатр
WHERE YEAR(время_сеанса) = YEAR(GETDATE()) + 1;


CREATE VIEW Популярные_фильмы AS
SELECT *,
       ROW_NUMBER() OVER (ORDER BY количество_проданных_билетов DESC) AS Рейтинг
FROM Архив;


CREATE ROLE АдминистраторКинотеатра;
GRANT UPDATE ON Кинотеатр(количество_билетов) TO АдминистраторКинотеатра;

CREATE LOGIN Администратор WITH PASSWORD = 'your_password';
CREATE USER Администратор FOR LOGIN Администратор;
ALTER ROLE АдминистраторКинотеатра ADD MEMBER Администратор;


--резервная копия (поменять имя бд)
BACKUP DATABASE Сессия TO DISK = 'C:\Backup\Сессия.bak' WITH INIT, NAME = 'Full Backup of Сессия';


