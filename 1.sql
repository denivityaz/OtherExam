
-- Create the College Database with specified file sizes
CREATE DATABASE College
ON (NAME = College_Data,
    FILENAME = 'C:\SQLData\CollegeData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = College_Log,
        FILENAME = 'C:\SQLData\CollegeLog.ldf',
        SIZE = 2MB);

-- Check if the College Database exists
IF DB_ID('College') IS NOT NULL
    PRINT 'The College database exists.';
ELSE
    PRINT 'The College database does not exist.';

-- Create sa user with a placeholder password
USE College;
CREATE LOGIN sa WITH PASSWORD = 'De_05';

-- Create Zachet table
CREATE TABLE Zachet (
    StudentID INT PRIMARY KEY,
    LastName NVARCHAR(50),
    FirstName NVARCHAR(50),
    Grade_PM01 INT,
    Grade_PM02 INT
);

-- Create data entry procedure
CREATE PROCEDURE Stud
    @StudentID INT,
    @LastName NVARCHAR(50),
    @FirstName NVARCHAR(50),
    @Grade_PM01 INT,
    @Grade_PM02 INT
AS
BEGIN
    INSERT INTO Zachet (StudentID, LastName, FirstName, Grade_PM01, Grade_PM02)
    VALUES (@StudentID, @LastName, @FirstName, @Grade_PM01, @Grade_PM02);
END;

-- Insert sample data
EXEC Stud 1, 'Smith', 'John', 90, 85;
EXEC Stud 2, 'Doe', 'Jane', 88, 92;
EXEC Stud 3, 'Brown', 'Bob', 75, 80;
EXEC Stud 4, 'Wilson', 'Alice', 95, 89;
EXEC Stud 5, 'Taylor', 'Charlie', 84, 78;

-- Display contents of Zachet
SELECT * FROM Zachet;

-- Create view for top students
CREATE VIEW View1 AS
SELECT StudentID, LastName, FirstName
FROM Zachet
WHERE Grade_PM01 >= 90 AND Grade_PM02 >= 90;

-- Create Teacher role and users Prepod1 and Prepod2
CREATE ROLE Teacher;
CREATE LOGIN Prepod1 WITH PASSWORD = 'Pr123';
CREATE LOGIN Prepod2 WITH PASSWORD = 'Pr456';
CREATE USER Prepod1 FOR LOGIN Prepod1;
CREATE USER Prepod2 FOR LOGIN Prepod2;

-- Assign users to roles and grant permissions
ALTER ROLE Teacher ADD MEMBER Prepod1;
GRANT SELECT, UPDATE ON Zachet TO Teacher;

-- Correct permission for the stored procedure
GRANT EXECUTE ON OBJECT::Stud TO Prepod2;

-- Ensure correct permission for the view
GRANT SELECT ON View1 TO Prepod2;


-- Backup the database 
BACKUP DATABASE College TO DISK = 'C:\Backup\College.bak' WITH INIT, NAME = 'Full Backup of College';

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
