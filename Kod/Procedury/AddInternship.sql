CREATE PROCEDURE AddInternship
    @StudiesID INT,
    @InternshipName NVARCHAR(30),
    @StartingDate DATETIME,
    @Description NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź, czy istnieją studia o podanym StudiesID
    IF NOT EXISTS (SELECT 1 FROM Studies WHERE StudiesID = @StudiesID)
    BEGIN
        RAISERROR('Studia o podanym ID nie istnieją.', 16, 1);
        RETURN;
    END

    -- Wstaw nowy staż do tabeli Internships
    INSERT INTO Internships (StudiesID, InternshipName, StartingDate, Description)
    VALUES (@StudiesID, @InternshipName, @StartingDate, @Description);

    PRINT 'Staż dodany pomyślnie.';
END;
go

grant execute on dbo.AddInternship to opiekun_praktyk
go

