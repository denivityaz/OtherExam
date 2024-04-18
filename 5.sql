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

-- Create tables
CREATE TABLE Студенты (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Course INT
);

CREATE TABLE Предметы (
    SubjectID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Course INT CHECK (Course BETWEEN 1 AND 5) -- Constraint for course number
);

CREATE TABLE Преподаватели (
    TeacherID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100)
);

-- Insert sample data
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

-- Create user
CREATE LOGIN Преподаватель1 WITH PASSWORD = 'Password1';
CREATE USER Преподаватель1 FOR LOGIN Преподаватель1;

-- Create a stored procedure to increment the course
CREATE PROCEDURE IncrementCourse @StudentID INT
AS
BEGIN
    UPDATE Студенты SET Course = Course + 1 WHERE StudentID = @StudentID AND Course < 5;
END;

-- Create a view to list all students taking Mathematics
CREATE VIEW StudentsTakingMath AS
SELECT s.Name
FROM Студенты s
JOIN Предметы p ON s.Course = p.Course
WHERE p.Name = 'Mathematics';

-- Backup the database
BACKUP DATABASE Сессия TO DISK = 'C:\Backup\Сессия.bak' WITH INIT, NAME = 'Full Backup of Сессия';

-- Display database file information
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Сессия');
