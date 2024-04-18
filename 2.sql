-- Attempt to create the Sclad Database with specific file sizes
IF DB_ID('Sclad') IS NOT NULL
BEGIN
    ALTER DATABASE Sclad SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Sclad;
    PRINT 'Existing Sclad database dropped.';
END

CREATE DATABASE Sclad
ON (NAME = Sclad_Data,
    FILENAME = 'C:\SQLData\ScladData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
LOG ON (NAME = Sclad_Log,
        FILENAME = 'C:\SQLData\ScladLog.ldf',
        SIZE = 2MB);
PRINT 'Sclad database created successfully.';

-- Use the Sclad Database
USE Sclad;

-- Create tables
CREATE TABLE Employees (
    ID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    EmployeeNumber INT,
    Department NVARCHAR(50),
    Position NVARCHAR(50)
);
PRINT 'Employees table created successfully.';

CREATE TABLE Products (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100),
    ProductCode INT,
    Quantity INT,
    Cost DECIMAL(10,2),
    Stock INT
);
PRINT 'Products table created successfully.';

CREATE TABLE Clients (
    ID INT PRIMARY KEY,
    ClientName NVARCHAR(100),
    ProductCode INT,
    Quantity INT,
    TotalAmount DECIMAL(10,2)
);
PRINT 'Clients table created successfully.';

-- Insert data into tables
INSERT INTO Employees VALUES
(1, 'John Doe', 101, 'Sales', 'Manager'),
(2, 'Jane Smith', 102, 'HR', 'Recruiter'),
(3, 'Alice Johnson', 103, 'IT', 'Developer'),
(4, 'Chris Brown', 104, 'Marketing', 'Assistant'),
(5, 'Patricia Lee', 105, 'Production', 'Supervisor');

INSERT INTO Products VALUES
(1, 'Laptop', 1001, 50, 1200.00, 30),
(2, 'Desktop Computer', 1002, 40, 800.00, 20),
(3, 'Printer', 1003, 70, 200.00, 50),
(4, 'Mouse', 1004, 150, 20.00, 100),
(5, 'Keyboard', 1005, 85, 50.00, 75);

INSERT INTO Clients VALUES
(1, 'Acme Corp', 1001, 10, 12000.00),
(2, 'Globex Corp', 1003, 5, 1000.00),
(3, 'IniTech', 1002, 20, 16000.00),
(4, 'Umbrella Corp', 1004, 50, 1000.00),
(5, 'Vandelay Industries', 1005, 30, 1500.00);

-- Create a procedure to insert data into any table
-- CREATE PROCEDURE InsertData
--     @TableName NVARCHAR(100),
--     @Values NVARCHAR(MAX)
-- AS
-- BEGIN
--     DECLARE @SQL NVARCHAR(MAX);
--     SET @SQL = 'INSERT INTO ' + @TableName + ' VALUES (' + @Values + ');';
--     EXEC sp_executesql @SQL;
-- END;

-- Role and permission setup
CREATE ROLE storekeeper;
CREATE LOGIN salesman1 WITH PASSWORD = 'Password1';
CREATE LOGIN salesman2 WITH PASSWORD = 'Password2';
CREATE USER salesman1 FOR LOGIN salesman1;
CREATE USER salesman2 FOR LOGIN salesman2;
GRANT SELECT, UPDATE ON Products TO storekeeper;
ALTER ROLE storekeeper ADD MEMBER salesman1;
ALTER ROLE storekeeper ADD MEMBER salesman2;
GRANT EXECUTE ON OBJECT::InsertData TO salesman2;

-- Backup the database
BACKUP DATABASE Sclad TO DISK = 'D:\Backup\Sclad.bak' WITH INIT, NAME = 'Full Backup of Sclad';

-- Output database info
SELECT name, size, file_id FROM sys.master_files WHERE database_id = DB_ID('Sclad');

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
