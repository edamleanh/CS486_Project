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


-- QUERY 11: MOST FREQUENTLY BOOKED SPACES
/*
Business question: What are the most frequently used spaces based on the number of approved and completed bookings?
Target user(s): Facility Manager, Department Administrator
Short explanation: Helps management sees if more similar spaces are needed or if underutilized spaces should be repurposed.
*/
SELECT TOP 5
    S.SpaceCode,
    S.SpaceName,
    COUNT(B.BookingID) AS TotalBookings
FROM 
    Spaces S
JOIN 
    Bookings B ON S.SpaceCode = B.SpaceCode 
WHERE 
    B.Status IN ('Approved', 'Completed', 'Checked In')
GROUP BY 
    S.SpaceCode, 
    S.SpaceName
ORDER BY 
    TotalBookings DESC;


-- QUERY 12: USERS WITH HIGH NO-SHOW RATES
/*
Business question: Which users have the highest number of times of not showing up after booking?
Target user(s): Facility Manager, Department Administrator
Short explanation: Finds users who frequently book spaces but fail to show up, allowing management to issue warnings and so on.
*/



-- QUERY 13: AVAILABLE SPACES WITH A SPECIFIC FACILITY
/*
Business question: Which currently available spaces are equipped with a 'Projector', and what is their seating capacity?
Target user(s): Facility Staff, Event Organizers
Short explanation: Helps in organizing events that strictly require a specific facility (like a projector) by finding all available spaces with that equipment and aggregating their capacity.
*/
SELECT 
    S.SpaceCode,
    S.SpaceName,
    S.Capacity,
    SF.Quantity AS ProjectorCount
FROM 
    Spaces S
JOIN 
    Space_Facilities SF ON S.SpaceCode = SF.SpaceCode
JOIN 
    Facilities F ON SF.FacilityID = F.FacilityID
WHERE 
    F.FacilityName = 'Projector'
    AND S.CurrentStatus = 'Available'
ORDER BY 
    S.Capacity DESC;


-- QUERY 14: AVERAGE MAINTENANCE RESOLUTION TIME
/*
Business question: What is the average time taken (in hours) to resolve maintenance issues for each space?
Target user(s): Facility Manager
Short explanation: Allows the manager to evaluate the efficiency of the maintenance team and identify spaces that suffer from prolonged maintenance downtimes.
*/
SELECT 
    S.SpaceCode,
    S.SpaceName,
    COUNT(M.MaintenanceID) AS TotalResolvedIssues,
    AVG(DATEDIFF(HOUR, M.StartTime, M.CompletionTime)) AS AvgResolutionTimeHours
FROM 
    Maintenance_Records M
JOIN 
    Spaces S ON M.SpaceCode = S.SpaceCode
WHERE 
    M.Status = 'Completed'
GROUP BY 
    S.SpaceCode, 
    S.SpaceName;


-- QUERY 15: AUDIT OVERLAPPING APPROVED BOOKINGS
/*
Business question: Are there any approved bookings that overlap in time for the same space? (Data anomaly check)
Target user(s): System Administrator, Facility Manager
Short explanation: Acts as an audit query to ensure the system correctly prevents double bookings. It identifies any instances where two approved bookings exist for the same space at overlapping times.
*/
SELECT 
    B1.BookingID AS Booking1,
    B2.BookingID AS Booking2,
    B1.SpaceCode,
    B1.ReqStartTime AS B1_Start,
    B1.ReqEndTime AS B1_End,
    B2.ReqStartTime AS B2_Start,
    B2.ReqEndTime AS B2_End
FROM 
    Bookings B1
JOIN 
    Bookings B2 ON B1.SpaceCode = B2.SpaceCode
        AND B1.BookingID < B2.BookingID
WHERE 
    B1.Status IN ('Approved', 'Completed', 'Checked In')
    AND B2.Status IN ('Approved', 'Completed', 'Checked In')
    AND B1.ReqStartTime < B2.ReqEndTime 
    AND B1.ReqEndTime > B2.ReqStartTime;
