CREATE PROCEDURE AddPayment
    @OrderID INT,
    @PaidAmount MONEY
AS
BEGIN
    BEGIN TRY
        -- Sprawdzenie, czy zamówienie istnieje
        IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
        BEGIN
            PRINT 'Błąd: Zamówienie nie istnieje.';
            RETURN;
        END

        -- Sprawdzenie, czy zamówienie nie zostało jeszcze w całości opłacone
        IF dbo.IsOrderPaid(@OrderID) = 1
        BEGIN
            PRINT 'Błąd: Zamówienie zostało już w całości opłacone.';
            RETURN;
        END

        -- Dodanie płatności
        INSERT INTO Payments (OrderID, PaidAmount, PaymentDate)
        VALUES (@OrderID, @PaidAmount, GETDATE());

        -- Sprawdzenie, czy zamówienie zostało w całości opłacone po dodaniu płatności
        IF dbo.IsOrderPaid(@OrderID) = 1
        BEGIN
            -- Ustawienie FullyPaidDate na datę dzisiejszą
            UPDATE Orders
            SET FullyPaidDate = GETDATE()
            WHERE OrderID = @OrderID;

            -- Dodanie studenta do odpowiednich komponentów zamówienia
            DECLARE @StudentID INT;
            SELECT @StudentID = StudentID FROM Orders WHERE OrderID = @OrderID;

            -- Dodanie studenta do kursów
            DECLARE @CourseID INT;
            DECLARE course_cursor CURSOR FOR
            SELECT CourseID FROM OrderCourse oc
            JOIN OrderContentDetails ocd ON oc.OrderContentID = ocd.OrderContentID
            WHERE ocd.OrderID = @OrderID;

            OPEN course_cursor;
            FETCH NEXT FROM course_cursor INTO @CourseID;
            WHILE @@FETCH_STATUS = 0
            BEGIN
                EXEC AddStudentToCourse @StudentID, @CourseID;
                FETCH NEXT FROM course_cursor INTO @CourseID;
            END
            CLOSE course_cursor;
            DEALLOCATE course_cursor;

            -- Dodanie studenta do webinarów
            DECLARE @WebinarID INT;
            DECLARE webinar_cursor CURSOR FOR
            SELECT WebinarID FROM OrderWebinar ow
            JOIN OrderContentDetails ocd ON ow.OrderContentID = ocd.OrderContentID
            WHERE ocd.OrderID = @OrderID;

            OPEN webinar_cursor;
            FETCH NEXT FROM webinar_cursor INTO @WebinarID;
            WHILE @@FETCH_STATUS = 0
            BEGIN
                EXEC AddStudentToWebinar @StudentID, @WebinarID;
                FETCH NEXT FROM webinar_cursor INTO @WebinarID;
            END
            CLOSE webinar_cursor;
            DEALLOCATE webinar_cursor;

            -- Dodanie studenta do studiów
            DECLARE @StudiesID INT;
            DECLARE studies_cursor CURSOR FOR
            SELECT StudiesID FROM OrderStudies os
            JOIN OrderContentDetails ocd ON os.OrderContentID = ocd.OrderContentID
            WHERE ocd.OrderID = @OrderID;

            OPEN studies_cursor;
            FETCH NEXT FROM studies_cursor INTO @StudiesID;
            WHILE @@FETCH_STATUS = 0
            BEGIN
                EXEC AddStudentToStudies @StudentID, @StudiesID;
                FETCH NEXT FROM studies_cursor INTO @StudiesID;
            END
            CLOSE studies_cursor;
            DEALLOCATE studies_cursor;

            -- Dodanie studenta do spotkań akademickich
            INSERT INTO MeetingAttendance (StudentID, MeetingID, MeetingCompletion)
            SELECT @StudentID, oam.MeetingID, 0
            FROM OrderAcademicMeeting oam
            JOIN OrderContentDetails ocd ON oam.OrderContentID = ocd.OrderContentID
            WHERE ocd.OrderID = @OrderID;

            PRINT 'Płatność została dodana, a zamówienie zostało w całości opłacone. Student został dodany do odpowiednich komponentów zamówienia.';
        END
        ELSE
        BEGIN
            PRINT 'Płatność została dodana, ale zamówienie nie zostało jeszcze w całości opłacone.';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd: ' + ERROR_MESSAGE();
    END CATCH
END;
go

