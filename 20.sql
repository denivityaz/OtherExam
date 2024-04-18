-- Check if the Универ Database exists and drop if it does
IF DB_ID('Универ') IS NOT NULL
BEGIN
    ALTER DATABASE Универ SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Универ;
    PRINT 'Existing Универ database dropped.';
END

-- Create the Универ Database with specified file sizes
CREATE DATABASE Универ
ON (NAME = Универ_Data,
    FILENAME = 'C:\SQLData\УниверData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Универ_Log,
        FILENAME = 'C:\SQLData\УниверLog.ldf',
        SIZE = 2MB);
PRINT 'Универ database created successfully.';

-- Use the Универ Database
USE Универ;

-- Create sa user with a specified password
CREATE LOGIN sa WITH PASSWORD = 'De_05';

-- Create tables
CREATE TABLE Студенты (
    StudentID INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(100),
    Course INT
);

CREATE TABLE Предметы (
    SubjectID INT PRIMARY KEY IDENTITY,
    SubjectName NVARCHAR(100),
    Course INT CONSTRAINT CHK_Course CHECK (Course BETWEEN 1 AND 5)
);

CREATE TABLE Преподаватели (
    TeacherID INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(100)
);

-- Insert sample data into tables
INSERT INTO Студенты (FullName, Course) VALUES
('John Doe', 1), 
('Jane Smith', 2), 
('Alice Johnson', 3), 
('Bob Brown', 4), 
('Charlie Davis', 5);

INSERT INTO Предметы (SubjectName, Course) VALUES
('Mathematics', 1), 
('History', 2), 
('Biology', 3), 
('Programming', 4), 
('Chemistry', 5);

INSERT INTO Преподаватели (FullName) VALUES
('Dr. Emily Stone'), 
('Dr. Mark Lee'), 
('Prof. Anna Cohen'), 
('Prof. Steve Watts'), 
('Dr. Lucy Bale');

-- Create a user with a role "Куратор" who can edit "Студенты" and "Предметы"
CREATE LOGIN Куратор WITH PASSWORD = 'KuratorPassword';
CREATE USER Куратор FOR LOGIN Куратор;
CREATE ROLE EditRole;
GRANT SELECT, INSERT, UPDATE ON Студенты TO EditRole;
GRANT SELECT, INSERT, UPDATE ON Предметы TO EditRole;
ALTER ROLE EditRole ADD MEMBER Куратор;

-- Create a trigger to update data in Студенты
CREATE TRIGGER trg_UpdateStudent
ON Студенты
AFTER UPDATE
AS
PRINT 'Студенты data updated';

-- Create a view to show all students taking "Programming"
CREATE VIEW StudentsTakingProgramming AS
SELECT s.FullName
FROM Студенты s
JOIN Предметы p ON s.Course = p.Course
WHERE p.SubjectName = 'Programming';

-- Backup the database
BACKUP DATABASE Универ TO DISK = 'C:\Backup\Универ.bak' WITH INIT, NAME = 'Full Backup of Универ';

-- Display database file information
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Универ');
