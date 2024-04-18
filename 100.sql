-- Drop the BD database if it exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'BD')
BEGIN
    ALTER DATABASE BD SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BD;
END;

-- Drop the Users table if it exists
USE master;
GO
IF OBJECT_ID('BD.dbo.Users', 'U') IS NOT NULL
BEGIN
    DROP TABLE BD.dbo.Users;
END;

-- Create the BD database and the Users table
CREATE DATABASE BD;
GO

USE BD;
GO

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50),
    PasswordHash NVARCHAR(100)
);
GO

-- Create 10 users with random passwords
DECLARE @i INT = 1;
DECLARE @username NVARCHAR(50);
DECLARE @password NVARCHAR(5);

WHILE @i <= 10
BEGIN
    SET @username = 'user' + CAST(@i AS NVARCHAR(2));
    SET @password = ''; -- Random password
    DECLARE @j INT = 1;

    WHILE @j <= 5
    BEGIN
        DECLARE @charIndex INT = CAST(RAND() * 36 AS INT); -- 26 letters + 10 digits
        SET @password = @password + CHAR( CASE 
                                            WHEN @charIndex < 26 THEN @charIndex + 65 -- Letters A-Z
                                            ELSE @charIndex + 22 -- Digits 0-9
                                          END);
        SET @j = @j + 1;
    END

    INSERT INTO Users (Username, PasswordHash) VALUES (@username, HASHBYTES('SHA2_256', @password));

    SET @i = @i + 1;
END;
GO
