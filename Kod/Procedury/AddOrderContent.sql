CREATE   PROCEDURE AddOrderContent
    @OrderID INT,
    @ContentType NVARCHAR(50),
    @ContentID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdź, czy istnieje zamówienie o podanym OrderID
    IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
    BEGIN
        RAISERROR('Zamówienie o podanym ID nie istnieje.', 16, 1);
        RETURN;
    END

    -- Pobierz StudentID z zamówienia
    DECLARE @StudentID INT;
    SELECT @StudentID = StudentID FROM Orders WHERE OrderID = @OrderID;

    -- Sprawdź, czy na danym kursie jest miejsce
    IF @ContentType = 'Course' AND NOT EXISTS (
        SELECT 1 FROM dbo.CheckCourseCapacity(@ContentID) WHERE HasAvailableSpots > 0
    )
    BEGIN
        RAISERROR('Brak miejsc na wybranym kursie.', 16, 1);
        RETURN;
    END
    -- Sprawdź, czy na danych studiach jest miejsce
    ELSE IF @ContentType = 'Studies' AND NOT EXISTS (
        SELECT 1 FROM dbo.CheckStudiesCapacity(@ContentID) WHERE HasAvailableSpots > 0
    )
    BEGIN
        RAISERROR('Brak miejsc na wybranych studiach.', 16, 1);
        RETURN;
    END
    ELSE IF @ContentType = 'Webinar' AND EXISTS (
        SELECT 1
        FROM WebinarDetails
        WHERE StudentID = @StudentID AND WebinarID = @ContentID
    )
    BEGIN
        RAISERROR('Student o podanym ID jest już zapisany na ten webinar.', 16, 1);
        RETURN;
    END
    ELSE IF @ContentType = 'AcademicMeeting' AND EXISTS (
        SELECT 1
        FROM MeetingAttendance
        WHERE StudentID = @StudentID AND MeetingID = @ContentID
    )
    BEGIN
        RAISERROR('Student o podanym ID jest już zapisany na to spotkanie.', 16, 1);
        RETURN;
    END

    -- Dodaj szczegóły zamówienia do tabeli OrderContentDetails
    DECLARE @OrderContentID INT;
    INSERT INTO OrderContentDetails (OrderID)
    VALUES (@OrderID);

    SET @OrderContentID = SCOPE_IDENTITY();

    -- Dodaj szczegóły zamówienia do odpowiednich tabel
    IF @ContentType = 'Course'
    BEGIN
        INSERT INTO OrderCourse (OrderContentID, CourseID)
        VALUES (@OrderContentID, @ContentID);
    END
    ELSE IF @ContentType = 'Webinar'
    BEGIN
        INSERT INTO OrderWebinar (OrderContentID, WebinarID)
        VALUES (@OrderContentID, @ContentID);
    END
    ELSE IF @ContentType = 'Studies'
    BEGIN
        INSERT INTO OrderStudies (OrderContentID, StudiesID)
        VALUES (@OrderContentID, @ContentID);
    END
    ELSE IF @ContentType = 'AcademicMeeting'
    BEGIN
        INSERT INTO OrderAcademicMeeting (OrderContentID, MeetingID)
        VALUES (@OrderContentID, @ContentID);
    END

    PRINT 'Szczegóły zamówienia dodane pomyślnie.';
END;
go

grant execute on dbo.AddOrderContent to system
go

