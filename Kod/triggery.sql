
automatyczne dodanie po zamówniu na webinar
CREATE TRIGGER trg_AddStudentToWebinar 
ON OrderWebinar 
AFTER INSERT 
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if student is already enrolled
    IF EXISTS (
        SELECT 1
        FROM WebinarDetails wd
        JOIN inserted i ON wd.WebinarID = i.WebinarID
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID
        WHERE wd.StudentID = o.StudentID
    )
    BEGIN
        RAISERROR ('Student jest już zapisany na ten webinar.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Check if the order is fully paid by checking FullyPaidDate
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID
        WHERE o.FullyPaidDate IS NULL
    )
    BEGIN
        RAISERROR ('Zamówienie musi być w pełni opłacone przed zapisem na webinar.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- If all checks pass, insert data into WebinarDetails
    INSERT INTO WebinarDetails (StudentID, WebinarID, TerminationDate)
    SELECT 
        o.StudentID,
        i.WebinarID,
        DATEADD(DAY, 30, GETDATE()) 
    FROM inserted i
    JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
    JOIN Orders o ON ocd.OrderID = o.OrderID
    JOIN Webinars w ON i.WebinarID = w.WebinarID;
END;


automatyczne dodawanie studenta na studia
CREATE TRIGGER trg_AddStudentToStudies
ON OrderStudies
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if the order is fully paid
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID
        WHERE o.FullyPaidDate IS NULL
    )
    BEGIN
        RAISERROR ('Zamówienie musi być w pełni opłacone przed zapisem na studia.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Check if student is already enrolled in these studies
    IF EXISTS (
        SELECT 1
        FROM StudentStudiesDetails ssd
        JOIN inserted i ON ssd.StudiesID = i.StudiesID
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID
        WHERE ssd.StudentID = o.StudentID
    )
    BEGIN
        RAISERROR ('Student jest już zapisany na te studia.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Begin transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Get StudentID and StudiesID for further operations
        DECLARE @StudentID int, @StudiesID int;
        SELECT 
            @StudentID = o.StudentID,
            @StudiesID = i.StudiesID
        FROM inserted i
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID;

        -- Add student to StudentStudiesDetails with initial grade 2.0
        INSERT INTO StudentStudiesDetails (StudentID, StudiesID, Grade)
        VALUES (@StudentID, @StudiesID, 2.0);

        -- Add student to all subjects associated with the studies
        INSERT INTO StudentSubjectDetails (StudentID, SubjectID, Grade)
        SELECT 
            @StudentID,
            s.SubjectID,
            NULL -- Initial grade is NULL
        FROM Subjects s
        WHERE s.StudiesID = @StudiesID;

        -- Add student to all academic meetings for these subjects
        INSERT INTO MeetingAttendance (StudentID, MeetingID, MeetingCompletion)
        SELECT 
            @StudentID,
            am.MeetingID,
            0 -- Not completed initially
        FROM AcademicMeeting am
        JOIN Subjects s ON am.SubjectID = s.SubjectID
        WHERE s.StudiesID = @StudiesID
        AND am.Date >= GETDATE(); -- Only future meetings

        -- Add student to internships associated with the studies
        INSERT INTO StudentInternshipDetails (StudentID, InternshipID, CompletedDays)
        SELECT 
            @StudentID,
            i.InternshipID,
            0 -- Initial completed days
        FROM Internships i
        WHERE i.StudiesID = @StudiesID
        AND i.StartingDate >= GETDATE(); -- Only future internships

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR ('Błąd podczas dodawania studenta do studiów: %s', 16, 1, @ErrorMessage);
        RETURN;
    END CATCH;
END;

na kurs
CREATE TRIGGER trg_AddStudentToCourse
ON OrderCourse
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if the order is fully paid
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID
        WHERE o.FullyPaidDate IS NULL
    )
    BEGIN
        RAISERROR ('Zamówienie musi być w pełni opłacone przed zapisem na kurs.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Check if student is already enrolled in the course
    IF EXISTS (
        SELECT 1
        FROM CourseStudentDetails csd
        JOIN inserted i ON csd.CourseID = i.CourseID
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID
        WHERE csd.StudentID = o.StudentID
    )
    BEGIN
        RAISERROR ('Student jest już zapisany na ten kurs.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Begin transaction for multiple inserts
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Add student to CourseStudentDetails
        INSERT INTO CourseStudentDetails (StudentID, CourseID, Completed)
        SELECT 
            o.StudentID,
            i.CourseID,
            0 -- Not completed initially
        FROM inserted i
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID;

        -- Add student to all course modules in ModuleAttendance
        INSERT INTO ModuleAttendance (StudentID, ModuleID, ModuleCompletion)
        SELECT 
            o.StudentID,
            cm.ModuleID,
            0 -- Not completed initially
        FROM inserted i
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID
        JOIN CourseModules cm ON i.CourseID = cm.CourseID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR ('Błąd podczas dodawania studenta do kursu: %s', 16, 1, @ErrorMessage);
        RETURN;
    END CATCH;
END;

na academic meeting
CREATE TRIGGER trg_AddStudentToAcademicMeeting
ON OrderAcademicMeeting
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if the order is fully paid
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID
        WHERE o.FullyPaidDate IS NULL
    )
    BEGIN
        RAISERROR ('Zamówienie musi być w pełni opłacone przed zapisem na spotkanie.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Check if student is already enrolled in the meeting
    IF EXISTS (
        SELECT 1
        FROM MeetingAttendance ma
        JOIN inserted i ON ma.MeetingID = i.MeetingID
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID
        WHERE ma.StudentID = o.StudentID
    )
    BEGIN
        RAISERROR ('Student jest już zapisany na to spotkanie.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Begin transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Add student to MeetingAttendance
        INSERT INTO MeetingAttendance (MeetingID, StudentID, MeetingCompletion)
        SELECT 
            i.MeetingID,
            o.StudentID,
            0 -- Not completed initially
        FROM inserted i
        JOIN OrderContentDetails ocd ON i.OrderContentID = ocd.OrderContentID
        JOIN Orders o ON ocd.OrderID = o.OrderID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR ('Błąd podczas dodawania studenta do spotkania: %s', 16, 1, @ErrorMessage);
        RETURN;
    END CATCH;
END;

-- Prevent deleting students who have active orders or courses
CREATE TRIGGER TR_PreventStudentDeletion
ON Students
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted d
        INNER JOIN Orders o ON o.StudentID = d.StudentID
        WHERE o.FullyPaidDate IS NULL
    )
    BEGIN
        THROW 50001, 'Cannot delete student with active orders.', 1;
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM deleted d
        INNER JOIN CourseStudentDetails csd ON csd.StudentID = d.StudentID
        WHERE csd.Completed = 0
    )
    BEGIN
        THROW 50002, 'Cannot delete student with active courses.', 1;
        RETURN;
    END

    DELETE FROM Students
    WHERE StudentID IN (SELECT StudentID FROM deleted);
END;


CREATE TRIGGER trg_ProcessFreeWebinarOrder
ON Orders
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Najpierw sprawdzamy czy to zamówienie na darmowy webinar
    IF NOT EXISTS (
        SELECT 1
        FROM inserted i
        JOIN OrderContentDetails ocd ON i.OrderID = ocd.OrderID
        JOIN OrderWebinar ow ON ocd.OrderContentID = ow.OrderContentID
        JOIN Webinars w ON ow.WebinarID = w.WebinarID
        WHERE w.Price = 0
    )
    BEGIN
        RETURN;
    END

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Pobierz StudentID i WebinarID z zamówienia
        DECLARE @StudentID INT, @WebinarID INT;
        
        SELECT 
            @StudentID = i.StudentID,
            @WebinarID = w.WebinarID
        FROM inserted i
        JOIN OrderContentDetails ocd ON i.OrderID = ocd.OrderID
        JOIN OrderWebinar ow ON ocd.OrderContentID = ow.OrderContentID
        JOIN Webinars w ON ow.WebinarID = w.WebinarID
        WHERE w.Price = 0;

        -- Sprawdź czy można zapisać studenta na webinar
        IF dbo.canEnrollWebinar(@StudentID, @WebinarID) = 0
        BEGIN
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Dodaj WebinarDetails z terminem ważności 30 dni od daty zapisu
        INSERT INTO WebinarDetails (StudentID, WebinarID, TerminationDate)
        VALUES (
            @StudentID,
            @WebinarID,
            DATEADD(DAY, 30, GETDATE())
        );

        -- Ustaw FullyPaidDate dla zamówienia
        UPDATE Orders
        SET FullyPaidDate = GETDATE()
        FROM Orders o
        JOIN inserted i ON o.OrderID = i.OrderID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR ('Błąd podczas przetwarzania zamówienia na darmowy webinar: %s', 16, 1, @ErrorMessage);
        RETURN;
    END CATCH;
END;
