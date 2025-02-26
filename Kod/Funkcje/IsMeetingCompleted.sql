CREATE   FUNCTION IsMeetingCompleted
(
    @StudentID INT,
    @MeetingID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @MeetingCompletion BIT;
    DECLARE @HasAccess BIT;

    -- Check if student has access to this meeting through an order
    SELECT @HasAccess = CASE
        WHEN EXISTS (
            SELECT 1
            FROM Orders o
            JOIN OrderContentDetails ocd ON o.OrderID = ocd.OrderID
            JOIN OrderAcademicMeeting oam ON ocd.OrderContentID = oam.OrderContentID
            WHERE o.StudentID = @StudentID
            AND oam.MeetingID = @MeetingID
        ) THEN 1
        ELSE 0
    END;

    -- Get meeting completion status
    SELECT
        @MeetingCompletion = ma.MeetingCompletion
    FROM MeetingAttendance ma
    WHERE ma.StudentID = @StudentID
    AND ma.MeetingID = @MeetingID;

    -- Return 1 only if student has access and completed the meeting
    RETURN CASE
        WHEN @MeetingCompletion = 1 AND @HasAccess = 1 THEN 1
        ELSE 0
    END;
END
go

grant execute on dbo.IsMeetingCompleted to student
go

