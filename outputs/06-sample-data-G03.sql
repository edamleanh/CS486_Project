-- ======================================================================
-- SAMPLE DATA (DML) SCRIPT - GROUP 03
-- ======================================================================

-- 1. INSERT USERS
INSERT INTO Users (UserID, FullName, Email, Phone, Role, Department, AccountStatus) VALUES
('SV001', 'Nguyen Van A', 'nva@student.university.edu', '0901234567', 'Student', 'Computer Science', 'Active'),
('GV001', 'Tran Thi B', 'ttb@university.edu', '0912345678', 'Lecturer', 'Software Engineering', 'Active'),
('ST001', 'Le Van C', 'lvc@facility.university.edu', '0923456789', 'Facility Staff', 'Facility Management', 'Active'),
('MN001', 'Pham Thi D', 'ptd@admin.university.edu', '0934567890', 'Manager', 'Facility Management', 'Active');

-- 2. INSERT SPACES
INSERT INTO Spaces (SpaceCode, SpaceName, SpaceType, Building, Floor, RoomNumber, Capacity, CurrentStatus, UsagePolicy) VALUES
('A1-101', 'Auditorium A1', 'Auditorium', 'Building A', 1, '101', 200, 'Available', 'Only for events and large seminars'),
('B2-201', 'CS Lab 1', 'Computer Laboratory', 'Building B', 2, '201', 40, 'Available', 'No food or drinks allowed'),
('C3-301', 'Meeting Room C3', 'Meeting Room', 'Building C', 3, '301', 15, 'Maintenance', 'Book at least 1 day in advance');

-- 3. INSERT FACILITIES
INSERT INTO Facilities (FacilityName, Description) VALUES
('Projector', '4K Laser Projector'),
('Microphone', 'Wireless Microphone System'),
('Whiteboard', 'Large Magnetic Whiteboard'),
('Desktop PC', 'Core i7, 16GB RAM, RTX 3060');

-- 4. INSERT SPACE_FACILITIES
INSERT INTO Space_Facilities (SpaceCode, FacilityID, Quantity) VALUES
('A1-101', 1, 2), -- 2 Projectors in Auditorium
('A1-101', 2, 4), -- 4 Microphones in Auditorium
('B2-201', 1, 1), -- 1 Projector in Lab
('B2-201', 4, 40), -- 40 PCs in Lab
('C3-301', 3, 1); -- 1 Whiteboard in Meeting Room

-- 5. INSERT BOOKINGS
INSERT INTO Bookings (SpaceCode, RequesterID, ApproverID, ReqStartTime, ReqEndTime, Purpose, Participants, Status, DecisionTime, RejReason) VALUES
-- Approved Booking
('A1-101', 'GV001', 'ST001', '2026-10-15 08:00:00', '2026-10-15 11:30:00', 'Introduction to Computer Science Seminar', 150, 'Approved', '2026-10-10 09:00:00', NULL),
-- Completed Booking
('B2-201', 'SV001', 'ST001', '2026-10-12 13:00:00', '2026-10-12 15:00:00', 'Student Web Project Defense', 5, 'Completed', '2026-10-01 10:00:00', NULL),
-- Rejected Booking
('A1-101', 'SV001', 'MN001', '2026-10-20 18:00:00', '2026-10-20 22:00:00', 'Student Club Party', 100, 'Rejected', '2026-10-11 11:00:00', 'Parties are not allowed in the auditorium'),
-- Pending Booking
('B2-201', 'GV001', NULL, '2026-10-25 08:00:00', '2026-10-25 12:00:00', 'Database Systems Midterm', 40, 'Pending', NULL, NULL);

-- Update the completed booking to add check-in/out data
UPDATE Bookings
SET CheckInStaffID = 'ST001', ActualStartTime = '2026-10-12 12:55:00', InitialCondition = 'Clean and ready',
    CheckOutStaffID = 'ST001', ActualEndTime = '2026-10-12 15:05:00', FinalCondition = 'Left clean', UsageNotes = 'No issues'
WHERE BookingID = 2;

-- 6. INSERT MAINTENANCE RECORDS
INSERT INTO Maintenance_Records (SpaceCode, ReporterID, AssignedStaffID, ProblemDesc, StartTime, CompletionTime, Status, ResultNote) VALUES
('C3-301', 'GV001', 'ST001', 'Broken chairs and flickering lights', '2026-10-10 14:00:00', NULL, 'In Progress', NULL),
('B2-201', 'SV001', 'ST001', 'PC number 12 will not turn on', '2026-10-05 08:00:00', '2026-10-05 10:00:00', 'Completed', 'Replaced power supply');
