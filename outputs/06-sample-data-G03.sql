-- 06 - Sample Data (DML) for Space Management System

-- =======================================================
-- CLEAR EXISTING DATA (To prevent PK/FK conflicts on rerun)
-- =======================================================
DELETE FROM MAINTENANCE_RECORD;
DELETE FROM BOOKING_REQUEST;
DELETE FROM FACILITY;
DELETE FROM SPACE;
DELETE FROM [USER];

-- =======================================================
-- RESET IDENTITY SEEDS
-- =======================================================
DBCC CHECKIDENT ('MAINTENANCE_RECORD', RESEED, 0);
DBCC CHECKIDENT ('BOOKING_REQUEST', RESEED, 0);
DBCC CHECKIDENT ('FACILITY', RESEED, 0);

-- =======================================================
-- INSERT DATA: [USER]
-- =======================================================
INSERT INTO [USER] (UserID, FullName, Email, PhoneNumber, Role, Department, AccountStatus) VALUES
('SV001', N'Nguyễn Văn A', 'a.nguyen@student.edu.vn', '0901234567', 'Student', 'Computer Science', 'Active'),
('SV002', N'Trần Thị B', 'b.tran@student.edu.vn', '0912345678', 'Student', 'Computer Science', 'Active'),
('GV001', N'Lê Thị Nhàn', 'nhan.le@edu.vn', '0923456789', 'Lecturer', 'Computer Science', 'Active'),
('TA001', N'Nguyễn Ngọc Toàn', 'toan.nguyen@edu.vn', '0934567890', 'TA', 'Computer Science', 'Active'),
('FS001', N'Phạm Văn C', 'c.pham@facility.edu.vn', '0945678901', 'Facility Staff', 'Facility Management', 'Active'),
('FM001', N'Hoàng Thị D', 'd.hoang@facility.edu.vn', '0956789012', 'Facility Manager', 'Facility Management', 'Active');

-- =======================================================
-- INSERT DATA: SPACE
-- =======================================================
INSERT INTO SPACE (SpaceCode, SpaceName, SpaceType, Building, FloorLevel, RoomNumber, Capacity, CurrentStatus, UsagePolicy) VALUES
('A1-101', N'Phòng học lý thuyết A1-101', 'Classroom', 'A1', 1, '101', 50, 'Available', N'Chỉ sử dụng cho giờ học chính khóa'),
('A1-102', N'Phòng máy tính A1-102', 'Lab', 'A1', 1, '102', 40, 'Available', N'Không mang đồ ăn, thức uống vào phòng'),
('A2-201', N'Hội trường A2', 'Auditorium', 'A2', 2, '201', 200, 'Available', N'Yêu cầu duyệt trước 3 ngày'),
('B1-301', N'Phòng họp B1', 'Meeting Room', 'B1', 3, '301', 20, 'Maintenance', N'Dành cho Giảng viên và Staff');

-- =======================================================
-- INSERT DATA: FACILITY
-- =======================================================
INSERT INTO FACILITY (SpaceCode, FacilityName, FacilityType, Condition) VALUES
('A1-101', N'Máy chiếu Panasonic', 'Projector', 'Good'),
('A1-101', N'Điều hòa Daikin', 'AC', 'Good'),
('A1-102', N'Máy lạnh LG', 'AC', 'Broken'),
('A1-102', N'Dàn PC Sinh viên', 'PC', 'Good'),
('A2-201', N'Hệ thống âm thanh hội trường', 'Microphone', 'Good'),
('A2-201', N'Màn hình LED lớn', 'Projector', 'Good'),
('B1-301', N'Bảng tương tác thông minh', 'Whiteboard', 'Broken');

-- =======================================================
-- INSERT DATA: BOOKING_REQUEST
-- =======================================================
INSERT INTO BOOKING_REQUEST (RequesterID, ApproverID, SpaceCode, ReqStartTime, ReqEndTime, Purpose, NumParticipants, Status, DecisionTime, DecisionNote, RejReason, CheckInStaffID, ActualStartTime, ActualEndTime, InitialCond, FinalCond, UsageNotes) VALUES
-- 1. Completed Booking (Giảng viên dạy)
('GV001', 'FM001', 'A1-101', '2026-06-25 08:00:00', '2026-06-25 11:30:00', N'Dạy môn Cơ sở dữ liệu', 45, 'Completed', '2026-06-20 14:00:00', N'Đã duyệt, sắp xếp ưu tiên', NULL, 'FS001', '2026-06-25 07:50:00', '2026-06-25 11:35:00', N'Sạch sẽ, đủ thiết bị', N'Bình thường', N'Không có sự cố'),

-- 2. Approved but not yet started (Future - Lịch thực hành)
('TA001', 'FM001', 'A1-102', '2026-06-28 13:00:00', '2026-06-28 17:00:00', N'Thực hành hệ CSDL', 40, 'Approved', '2026-06-26 09:00:00', N'Đã duyệt', NULL, NULL, NULL, NULL, NULL, NULL, NULL),

-- 3. Pending (Sinh viên xin mượn hội trường)
('SV001', NULL, 'A2-201', '2026-07-05 08:00:00', '2026-07-05 17:00:00', N'Tổ chức hội thảo Khoa học Sinh viên', 150, 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),

-- 4. Rejected (Sinh viên xin mượn phòng họp sai chính sách)
('SV002', 'FM001', 'B1-301', '2026-06-26 15:00:00', '2026-06-26 16:00:00', N'Học nhóm', 5, 'Rejected', '2026-06-24 10:00:00', N'Không phù hợp', N'Phòng họp B1 chỉ dành cho Giảng viên/Staff theo Policy', NULL, NULL, NULL, NULL, NULL, NULL);

-- =======================================================
-- INSERT DATA: MAINTENANCE_RECORD
-- =======================================================
INSERT INTO MAINTENANCE_RECORD (SpaceCode, ReporterID, HandlerID, ProblemDesc, StartTime, CompletionTime, Status, ResultNote) VALUES
-- 1. Đã sửa xong
('A1-102', 'GV001', 'FS001', N'Máy lạnh LG báo lỗi và không làm mát', '2026-06-25 10:00:00', '2026-06-25 14:00:00', 'Resolved', N'Đã thay gas, máy hoạt động bình thường'),

-- 2. Đang sửa (In Progress)
('B1-301', 'FM001', 'FS001', N'Bảng tương tác không lên nguồn', '2026-06-26 08:00:00', NULL, 'In Progress', NULL),

-- 3. Mới báo cáo, chờ xử lý
('A1-101', 'SV001', NULL, N'Đèn trần bị chớp nháy liên tục ở góc trái trên', '2026-06-27 09:00:00', NULL, 'Reported', NULL);
