CREATE PROCEDURE AddTeacher
    @FirstName NVARCHAR(30),
    @LastName NVARCHAR(60),
    @Address NVARCHAR(150),
    @City NVARCHAR(30),
    @Country NVARCHAR(30),
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(15)
AS
BEGIN
    INSERT INTO Teachers (FirstName, LastName, Address, City, Country, Email, PhoneNumber)
    VALUES (@FirstName, @LastName, @Address, @City, @Country, @Email, @PhoneNumber);
END;
go

grant execute on dbo.AddTeacher to kadrowy
go

