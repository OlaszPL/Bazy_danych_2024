CREATE   PROCEDURE AddStudent
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(60),
    @Address NVARCHAR(150),
    @City NVARCHAR(30),
    @PostalCode VARCHAR(10),
    @Country NVARCHAR(30),
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(15),
    @IsRegularCustomer BIT
AS
BEGIN
    BEGIN TRY
        -- Wstawienie nowego studenta z automatycznym ustawieniem GDPRAgreementDate
        INSERT INTO Students (FirstName, LastName, Address, City, PostalCode, Country, Email, PhoneNumber, IsRegularCustomer, GDPRAgreementDate)
        VALUES (@FirstName, @LastName, @Address, @City, @PostalCode, @Country, @Email, @PhoneNumber, @IsRegularCustomer, GETDATE());

        PRINT 'Student successfully added with current date and time for GDPRAgreementDate.';
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;
go

grant execute on dbo.AddStudent to kadrowy
go

