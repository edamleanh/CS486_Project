-- ======================================================================
-- QUERY DESIGN (DQL) SCRIPT - GROUP 03
-- ======================================================================

-- 1. VIEW ALL PENDING BOOKING REQUESTS
/*
Business question: What are the current pending booking requests that need approval?
Target user(s): Facility Staff, Facility Managers
Short explanation: Used by Facility Staff/Managers to review requests that have not yet been approved or rejected in order to make approval decisions.
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
Target user(s): Students, Lecturers, Teaching Assistants, Department Administrators
Short explanation: Helps users find available spaces by filtering out spaces that are closed/under maintenance or have overlapping approved bookings.
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
Target user(s): Students, Lecturers, Any Requester
Short explanation: Allows requesters to see what equipment exists in a room before booking to ensure it meets their needs.
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
Target user(s): Facility Managers, Facility Staff
Short explanation: Facility managers use this to track outstanding repairs and coordinate maintenance staff to resolve issues quickly.
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
Target user(s): Students (e.g., SV001)
Short explanation: Allows an individual user to check the statuses of all their past and upcoming booking requests for their own records.
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

-- 6. LIST ALL BOOKINGS THAT ARE CHECKED IN BY A STAFF IN A TIME INTERVAL
/*
 * Business question: What are the bookings checked in by 'ST001' between 2026-06-21 and 2026-06-27?
 * Target user(s): Staff
 */
SELECT *
FROM Bookings b 
WHERE b.CheckInStaffID = 'ST001'
    AND b.ActualStartTime >= '2026-06-21' AND b.ActualStartTime <= '2026-06-27'
ORDER BY b.ActualStartTime DESC;

-- 7. CHECK BOOKING HISTORY OF A SPACE
/*
 * Business question: What is the booking history of space 'A1-101'?
 */
SELECT
    b.BookingID,
    s.SpaceName,
    b.ReqStartTime,
    b.ReqEndTime,
    b.Status,
    b.RejReason,
    b.DecisionTime
FROM Spaces s JOIN Bookings b ON s.SpaceCode = b.SpaceCode 
WHERE s.SpaceCode = 'A1-101'
ORDER BY b.ReqStartTime DESC;

-- 8. LIST SPACES BOOKED BY STUDENTS IN EACH DEPARTMENT
/*
 *  Target user(s): Student, Department
 */
SELECT u.Department,
    b.BookingID,
    s.SpaceCode,
    s.SpaceName,
    s.SpaceType
FROM Users u 
    JOIN Bookings b ON u.UserID = b.RequesterID
    JOIN Spaces s ON b.SpaceCode = s.SpaceCode
ORDER BY u.Department;
