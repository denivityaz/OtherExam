-- Check if the Сессия Database exists and drop if it does
IF DB_ID('Сессия') IS NOT NULL
BEGIN
    ALTER DATABASE Сессия SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Сессия;
    PRINT 'Existing Сессия database dropped.';
END

-- Create the Сессия Database with specified file sizes
CREATE DATABASE Сессия
ON (NAME = Сессия_Data,
    FILENAME = 'C:\SQLData\СессияData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Сессия_Log,
        FILENAME = 'C:\SQLData\СессияLog.ldf',
        SIZE = 2MB);
PRINT 'Сессия database created successfully.';

-- Use the Сессия Database
USE Сессия;

-- Create Students table
CREATE TABLE Студенты (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Course INT
);

-- Create Subjects table
CREATE TABLE Предметы (
    SubjectID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Course INT CHECK (Course BETWEEN 1 AND 5) -- Constraint for course number
);

-- Create Teachers table
CREATE TABLE Преподаватели (
    TeacherID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100)
);

-- Insert sample data into tables
INSERT INTO Студенты (Name, Course) VALUES
('Ivan Ivanov', 1),
('Maria Petrova', 2),
('Sergey Sidorov', 3),
('Olga Pavlova', 4),
('Nikolay Nikolaev', 5);

INSERT INTO Предметы (Name, Course) VALUES
('Mathematics', 1),
('Physics', 2),
('Chemistry', 3),
('Biology', 4),
('History', 5);

INSERT INTO Преподаватели (Name) VALUES
('Dmitry Dmitriev'),
('Anna Ivanova'),
('Petr Petrov'),
('Elena Sidrova'),
('Natalia Pavlova');

-- Create role Куратор
CREATE ROLE Куратор;
GRANT UPDATE, INSERT ON Студенты TO Куратор;
GRANT UPDATE, INSERT ON Предметы TO Куратор;

-- Create a trigger to log updates in Students table
CREATE TRIGGER UpdateStudentTrigger
ON Студенты
AFTER UPDATE
AS
PRINT 'Student record updated.';

-- Create a view to show students taking the Mathematics exam
CREATE VIEW StudentsTakingMath AS
SELECT s.Name
FROM Студенты s
JOIN Предметы p ON s.Course = p.Course
WHERE p.Name = 'Mathematics';

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

