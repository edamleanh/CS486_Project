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
SELECT
    u.Department,
    b.BookingID,
    s.SpaceCode,
    s.SpaceName,
    s.SpaceType
FROM Users u 
    JOIN Bookings b ON u.UserID = b.RequesterID
    JOIN Spaces s ON b.SpaceCode = s.SpaceCode
ORDER BY u.Department;

-- 9. FIND THE MOST COMMON ROLE OF MAINTENANCE ISSUE REPORTERS
SELECT u.[Role]
FROM Users u 
WHERE u.[Role] = (SELECT [Role]
    FROM (
        SELECT TOP 1 u2.[Role], COUNT(*) AS role_cnt
        FROM Users u2 
            JOIN Maintenance_Records mr ON u2.UserID = mr.ReporterID
        GROUP BY u2.[Role]) AS MrNumRole);

-- 10. FIND THE SPACES THAT ARE BROKEN THE MOST
SELECT
    s.SpaceCode,
    s.SpaceName,
    s.SpaceType 
FROM Spaces s 
GROUP BY
    s.SpaceCode,
    s.SpaceName,
    s.SpaceType
HAVING
    (SELECT COUNT(*)
    FROM Spaces s2
        JOIN Maintenance_Records mr ON s2.SpaceCode = mr.SpaceCode 
    WHERE s.SpaceCode = s2.SpaceCode)
    =
    (SELECT TOP 1 COUNT(*)
    FROM Spaces s2 
        JOIN Maintenance_Records mr ON s2.SpaceCode = mr.SpaceCode 
    GROUP BY s2.SpaceCode);
    
    
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
    
    


-- ======================================================================
-- QUERY DESIGN (DQL) SCRIPT - GROUP 03 (Tiếp theo: Query 16 - 20)
-- ======================================================================

-- 16. NO-SHOW BOOKINGS REPORT
/*
Business question: Danh sách tất cả các booking bị đánh dấu là No-Show trong hệ thống, kèm thông tin người đặt và không gian?
Target user(s): Facility Managers, Department Administrators
Short explanation: Giúp ban quản lý theo dõi người dùng hay vắng mặt, từ đó có chính sách nhắc nhở hoặc hạn chế đặt chỗ đối với những trường hợp tái phạm nhiều lần. Đây là một trong những business rule quan trọng cần giám sát.
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
    B.Status = 'No-Show'
ORDER BY 
    B.ReqStartTime DESC;


-- 17. UPCOMING APPROVED BOOKINGS (Next 7 Days)
/*
Business question: Những booking nào đã được duyệt và sẽ diễn ra trong 7 ngày tới?
Target user(s): Facility Staff, Facility Managers
Short explanation: Cho phép nhân viên cơ sở vật chất chuẩn bị trước (kiểm tra thiết bị, vệ sinh, sắp xếp check-in) cho các buổi sắp diễn ra, giảm thiểu tình trạng không chuẩn bị kịp.
*/
SELECT 
    B.BookingID,
    S.SpaceName,
    U.FullName AS RequesterName,
    B.ReqStartTime,
    B.ReqEndTime,
    B.Purpose,
    B.Participants,
    B.Status
FROM 
    Bookings B
JOIN 
    Spaces S ON B.SpaceCode = S.SpaceCode
JOIN 
    Users U ON B.RequesterID = U.UserID
WHERE 
    B.Status = 'Approved'
    AND B.ReqStartTime BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
ORDER BY 
    B.ReqStartTime ASC;


-- 18. BOOKING PURPOSE ANALYSIS (Nhu cầu sử dụng theo mục đích)
/*
Business question: Mục đích sử dụng không gian nào phổ biến nhất và trung bình số người tham gia là bao nhiêu?
Target user(s): Facility Managers, Department Administrators
Short explanation: Giúp ban lãnh đạo hiểu rõ nhu cầu thực tế (lecture, examination, workshop, seminar...) để có kế hoạch mua sắm thiết bị, phân bổ không gian và nhân sự phù hợp hơn.
*/
SELECT 
    B.Purpose,
    COUNT(B.BookingID) AS TotalBookings,
    ROUND(AVG(B.Participants), 1) AS AvgParticipants,
    MIN(B.Participants) AS MinParticipants,
    MAX(B.Participants) AS MaxParticipants
FROM 
    Bookings B
WHERE 
    B.Status IN ('Approved', 'Checked In', 'Completed')
GROUP BY 
    B.Purpose
ORDER BY 
    TotalBookings DESC;


-- 19. SPACES WITH MOST MAINTENANCE ISSUES
/*
Business question: Những không gian nào đang gặp nhiều vấn đề bảo trì nhất?
Target user(s): Facility Managers
Short explanation: Giúp quản lý xác định các không gian "yếu" cần được ưu tiên bảo trì, nâng cấp hoặc kiểm tra định kỳ để giảm thiểu ảnh hưởng đến hoạt động giảng dạy và sự kiện.
*/
SELECT 
    S.SpaceCode,
    S.SpaceName,
    S.SpaceType,
    COUNT(M.MaintenanceID) AS TotalMaintenanceRecords,
    MAX(M.StartTime) AS LastMaintenanceDate,
    SUM(CASE WHEN M.Status != 'Completed' THEN 1 ELSE 0 END) AS OpenIssues
FROM 
    Spaces S
LEFT JOIN 
    Maintenance_Records M ON S.SpaceCode = M.SpaceCode
GROUP BY 
    S.SpaceCode, S.SpaceName, S.SpaceType
HAVING 
    COUNT(M.MaintenanceID) > 0
ORDER BY 
    TotalMaintenanceRecords DESC;


-- 20. LONG PENDING BOOKINGS (Backlog Detection)
/*
Business question: Những yêu cầu đặt chỗ nào đang ở trạng thái Pending quá lâu (hơn 3 ngày)?
Target user(s): Facility Managers, Facility Staff
Short explanation: Phát hiện các yêu cầu bị "treo" quá lâu để nhân viên xử lý kịp thời, tránh làm mất lòng người dùng và đảm bảo quy trình duyệt diễn ra nhanh chóng.
*/
SELECT 
    B.BookingID,
    S.SpaceName,
    U.FullName AS RequesterName,
    U.Role,
    B.ReqStartTime,
    B.ReqEndTime,
    B.Purpose,
    DATEDIFF(CURDATE(), B.DecisionTime) AS DaysPending
FROM 
    Bookings B
JOIN 
    Spaces S ON B.SpaceCode = S.SpaceCode
JOIN 
    Users U ON B.RequesterID = U.UserID
WHERE 
    B.Status = 'Pending'
    AND B.DecisionTime IS NOT NULL
    AND DATEDIFF(CURDATE(), B.DecisionTime) > 3
ORDER BY 
    DaysPending DESC;
