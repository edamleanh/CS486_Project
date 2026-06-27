-- 07 - Query Design (DQL) for Space Management System

/*
Yêu cầu đề bài: Thiết kế ít nhất 5 truy vấn SQL có ý nghĩa đối với bài toán.
Mỗi truy vấn cần đi kèm:
- Câu hỏi nghiệp vụ (Business question)
- Người dùng mục tiêu (Target user)
- Giải thích tính hữu ích (Explanation)
- Lệnh SQL
*/

-- ======================================================================
-- QUERY 1: Tìm các yêu cầu đặt phòng đang chờ duyệt
-- ======================================================================
/*
- Business question: Hiện tại có những yêu cầu đặt phòng nào đang chờ duyệt (Pending), ai là người yêu cầu và muốn đặt phòng nào?
- Target user(s): Facility Manager (Quản lý cơ sở vật chất)
- Explanation: Giúp người quản lý nhanh chóng lọc ra danh sách các yêu cầu đang đợi để tiến hành thao tác duyệt (Approve) hoặc từ chối (Reject).
*/
SELECT 
    BR.BookingID,
    U.FullName AS RequesterName,
    U.Role AS RequesterRole,
    S.SpaceName,
    BR.ReqStartTime,
    BR.ReqEndTime,
    BR.Purpose
FROM 
    BOOKING_REQUEST BR
JOIN 
    [USER] U ON BR.RequesterID = U.UserID
JOIN 
    SPACE S ON BR.SpaceCode = S.SpaceCode
WHERE 
    BR.Status = 'Pending'
ORDER BY 
    BR.ReqStartTime ASC;


-- ======================================================================
-- QUERY 2: Xem danh sách các phòng đang gặp sự cố thiết bị
-- ======================================================================
/*
- Business question: Có những không gian nào đang chứa thiết bị bị hỏng (Broken) và đó là thiết bị gì?
- Target user(s): Facility Staff (Nhân viên cơ sở vật chất)
- Explanation: Giúp nhân viên bảo trì có cái nhìn tổng quan về các thiết bị hư hỏng ở các phòng để lên lịch trình đi sửa chữa và thay thế thiết bị.
*/
SELECT 
    S.SpaceCode,
    S.SpaceName,
    F.FacilityName,
    F.FacilityType,
    F.Condition
FROM 
    SPACE S
JOIN 
    FACILITY F ON S.SpaceCode = F.SpaceCode
WHERE 
    F.Condition = 'Broken'
ORDER BY 
    S.SpaceCode;


-- ======================================================================
-- QUERY 3: Theo dõi trạng thái bảo trì chưa hoàn tất
-- ======================================================================
/*
- Business question: Những sự cố phòng nào đã được báo cáo nhưng chưa được sửa chữa xong (Reported hoặc In Progress)? Ai là người xử lý?
- Target user(s): Facility Manager / Facility Staff
- Explanation: Theo dõi tiến độ bảo trì của hệ thống, giúp người quản lý đôn đốc công việc hoặc phân công người xử lý nếu cột HandlerID vẫn đang trống.
*/
SELECT 
    MR.MaintenanceID,
    S.SpaceName,
    U.FullName AS ReporterName,
    H.FullName AS HandlerName,
    MR.ProblemDesc,
    MR.StartTime,
    MR.Status
FROM 
    MAINTENANCE_RECORD MR
JOIN 
    SPACE S ON MR.SpaceCode = S.SpaceCode
JOIN 
    [USER] U ON MR.ReporterID = U.UserID
LEFT JOIN 
    [USER] H ON MR.HandlerID = H.UserID
WHERE 
    MR.Status IN ('Reported', 'In Progress')
ORDER BY 
    MR.StartTime DESC;


-- ======================================================================
-- QUERY 4: Thống kê tần suất sử dụng của các phòng (Utilization)
-- ======================================================================
/*
- Business question: Mỗi phòng đã được sử dụng (Completed) hoặc được đặt trước (Approved) bao nhiêu lần? Sắp xếp từ nhiều nhất đến ít nhất.
- Target user(s): Department Administrator / Facility Manager
- Explanation: Giúp ban quản lý đánh giá được phòng nào được sử dụng nhiều nhất (quá tải) và phòng nào ít được sử dụng, từ đó có cơ sở để điều chỉnh không gian hoặc chuyển đổi mục đích sử dụng.
*/
SELECT 
    S.SpaceCode,
    S.SpaceName,
    COUNT(BR.BookingID) AS TotalBookings
FROM 
    SPACE S
LEFT JOIN 
    BOOKING_REQUEST BR ON S.SpaceCode = BR.SpaceCode 
                       AND BR.Status IN ('Approved', 'Completed')
GROUP BY 
    S.SpaceCode, 
    S.SpaceName
ORDER BY 
    TotalBookings DESC;


-- ======================================================================
-- QUERY 5: Lịch sử đặt phòng của một cá nhân cụ thể
-- ======================================================================
/*
- Business question: Lịch sử đặt phòng của người dùng có mã 'SV001' là gì? Các yêu cầu đã được xử lý ra sao?
- Target user(s): Student / Lecturer (Người dùng cuối)
- Explanation: Cho phép người dùng theo dõi và xem lại toàn bộ các phiên đặt phòng của chính mình, biết được phòng nào bị từ chối và phòng nào đã được duyệt.
*/
SELECT 
    BR.BookingID,
    S.SpaceName,
    BR.ReqStartTime,
    BR.ReqEndTime,
    BR.Status,
    BR.RejReason,
    BR.DecisionTime
FROM 
    BOOKING_REQUEST BR
JOIN 
    SPACE S ON BR.SpaceCode = S.SpaceCode
WHERE 
    BR.RequesterID = 'SV001'
ORDER BY 
    BR.ReqStartTime DESC;
