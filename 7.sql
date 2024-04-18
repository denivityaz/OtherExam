-- Check if the Колледж Database exists and drop if it does
IF DB_ID('Колледж') IS NOT NULL
BEGIN
    ALTER DATABASE Колледж SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Колледж;
    PRINT 'Existing Колледж database dropped.';
END

-- Create the Колледж Database with specified file sizes
CREATE DATABASE Колледж
ON (NAME = Колледж_Data,
    FILENAME = 'C:\SQLData\КолледжData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Колледж_Log,
        FILENAME = 'C:\SQLData\КолледжLog.ldf',
        SIZE = 2MB);
PRINT 'Колледж database created successfully.';

-- Use the Колледж Database
USE Колледж;

-- Create tables
CREATE TABLE Студенты (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Course INT CONSTRAINT chk_Course CHECK (Course BETWEEN 1 AND 5)
);

CREATE TABLE Предметы (
    SubjectID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Course INT CONSTRAINT chk_SubjectCourse CHECK (Course BETWEEN 1 AND 5)
);

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

-- Create users and roles
CREATE LOGIN Преподаватель1 WITH PASSWORD = 'Password1';
CREATE LOGIN Преподаватель2 WITH PASSWORD = 'Password2';
CREATE USER Преподаватель1 FOR LOGIN Преподаватель1;
CREATE USER Преподаватель2 FOR LOGIN Преподаватель2;

CREATE ROLE Куратор;
GRANT SELECT, UPDATE, INSERT ON Студенты TO Куратор;
GRANT SELECT, UPDATE, INSERT ON Предметы TO Куратор;
ALTER ROLE Куратор ADD MEMBER Преподаватель1;

-- Create a view to show students taking the Mathematics exam
CREATE VIEW StudentsTakingMath AS
SELECT s.Name, s.Course
FROM Студенты s
JOIN Предметы p ON s.Course = p.Course
WHERE p.Name = 'Mathematics';

-- Backup the database
BACKUP DATABASE Колледж TO DISK = 'C:\Backup\Колледж.bak' WITH INIT, NAME = 'Full Backup of Колледж';

-- Display database file information
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Колледж');
