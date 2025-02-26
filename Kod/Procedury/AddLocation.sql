CREATE PROCEDURE AddLocation
    @Address NVARCHAR(150),
    @Room VARCHAR(10),
    @MaxPeople INT
AS
BEGIN
    BEGIN TRY
        -- Wstawienie nowej lokacji
        INSERT INTO Locations (Address, Room, MaxPeople)
        VALUES (@Address, @Room, @MaxPeople);

        PRINT 'Location successfully added.';
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;
go

