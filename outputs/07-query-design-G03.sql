-- ======================================================================
-- QUERY DESIGN (DQL) SCRIPT - GROUP 03
-- ======================================================================

-- 1. VIEW ALL PENDING BOOKING REQUESTS
/*
Business question: What are the current pending booking requests that need approval?
Explanation: Used by Facility Staff/Managers to review requests that have not yet been approved or rejected.
*/
SELECT 
    B.BookingID,
    S.SpaceName,
    U.FullName AS RequesterName,
    U.Role AS RequesterRole,
    B.ReqStartTime,
    B.ReqEndTime,
    B.Purpose,
    B.Participants
FROM 
    Bookings B
JOIN 
    Spaces S ON B.SpaceCode = S.SpaceCode
JOIN 
    Users U ON B.RequesterID = U.UserID
WHERE 
    B.Status = 'Pending'
ORDER BY 
    B.ReqStartTime ASC;

-- 2. CHECK SPACE AVAILABILITY FOR A SPECIFIC TIME
/*
Business question: Which spaces are available for booking on '2026-10-25' between '08:00:00' and '12:00:00' with a capacity of at least 30?
Explanation: Helps users find available spaces by filtering out spaces that are closed/under maintenance or have overlapping approved bookings.
*/
SELECT 
    S.SpaceCode, 
    S.SpaceName, 
    S.Capacity
FROM 
    Spaces S
WHERE 
    S.CurrentStatus = 'Available'
    AND S.Capacity >= 30
    AND S.SpaceCode NOT IN (
        SELECT SpaceCode 
        FROM Bookings 
        WHERE Status IN ('Approved', 'Checked In')
          AND (ReqStartTime < '2026-10-25 12:00:00' AND ReqEndTime > '2026-10-25 08:00:00')
    );

-- 3. LIST ALL FACILITIES IN A SPECIFIC SPACE
/*
Business question: What equipment/facilities are available in 'Auditorium A1' (SpaceCode 'A1-101')?
Explanation: Allows requesters to see what equipment exists in a room before booking.
*/
SELECT 
    F.FacilityName, 
    SF.Quantity, 
    F.Description
FROM 
    Space_Facilities SF
JOIN 
    Facilities F ON SF.FacilityID = F.FacilityID
WHERE 
    SF.SpaceCode = 'A1-101';

-- 4. VIEW ACTIVE MAINTENANCE ISSUES
/*
Business question: Which spaces are currently facing maintenance issues that are not yet completed?
Explanation: Facility managers use this to track outstanding repairs and coordinate maintenance staff.
*/
SELECT 
    M.MaintenanceID,
    S.SpaceName,
    U.FullName AS ReporterName,
    M.ProblemDesc,
    M.StartTime,
    M.Status
FROM 
    Maintenance_Records M
JOIN 
    Spaces S ON M.SpaceCode = S.SpaceCode
JOIN 
    Users U ON M.ReporterID = U.UserID
WHERE 
    M.Status != 'Completed'
ORDER BY 
    M.StartTime DESC;

-- 5. USER BOOKING HISTORY
/*
Business question: What is the booking history of student 'SV001'?
Explanation: Allows an individual user to check the statuses of all their past and upcoming booking requests.
*/
SELECT 
    B.BookingID,
    S.SpaceName,
    B.ReqStartTime,
    B.ReqEndTime,
    B.Status,
    B.RejReason,
    B.DecisionTime
FROM 
    Bookings B
JOIN 
    Spaces S ON B.SpaceCode = S.SpaceCode
WHERE 
    B.RequesterID = 'SV001'
ORDER BY 
    B.ReqStartTime DESC;
