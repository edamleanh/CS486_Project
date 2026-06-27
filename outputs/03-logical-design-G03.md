# 03 - Logical Database Design

Dựa trên sơ đồ thực thể liên kết (ERD) từ Bước 2, dưới đây là thiết kế mức logic (Relational Schema) cho cơ sở dữ liệu hệ thống quản lý không gian trường học.

## 1. Relational Schema (Lược đồ quan hệ)

Ký hiệu:
- **PK**: Primary Key (Khóa chính) - được **gạch dưới và in đậm**.
- **FK**: Foreign Key (Khóa ngoại) - được *in nghiêng*.

### 1. Bảng USER (Người dùng)
Lưu trữ thông tin của sinh viên, giảng viên, nhân viên.
- **<u>UserID</u>** (VARCHAR(20), PK): Mã số người dùng (VD: Mã số SV, Mã số GV).
- FullName (NVARCHAR(100), NOT NULL): Họ và tên.
- Email (VARCHAR(100), NOT NULL, UNIQUE): Địa chỉ email.
- PhoneNumber (VARCHAR(20), NULL): Số điện thoại liên hệ.
- Role (VARCHAR(50), NOT NULL): Vai trò (Student, Lecturer, TA, Facility Staff, Dept Admin, Facility Manager).
- Department (NVARCHAR(100), NULL): Khoa / Phòng ban.
- AccountStatus (VARCHAR(20), NOT NULL): Trạng thái tài khoản (Active, Suspended, Inactive).

### 2. Bảng SPACE (Không gian / Phòng)
Lưu trữ thông tin về các phòng có thể đặt.
- **<u>SpaceCode</u>** (VARCHAR(20), PK): Mã phòng (VD: A1-101).
- SpaceName (NVARCHAR(100), NOT NULL): Tên phòng / Không gian.
- SpaceType (VARCHAR(50), NOT NULL): Loại phòng (Classroom, Lab, Meeting Room, Auditorium).
- Building (NVARCHAR(50), NOT NULL): Tòa nhà.
- FloorLevel (INT, NOT NULL): Tầng.
- RoomNumber (VARCHAR(20), NOT NULL): Số phòng.
- Capacity (INT, NOT NULL): Sức chứa tối đa.
- CurrentStatus (VARCHAR(20), NOT NULL): Trạng thái hiện tại (Available, In Use, Maintenance, Closed).
- UsagePolicy (NVARCHAR(MAX), NULL): Chính sách sử dụng riêng (nếu có).

### 3. Bảng FACILITY (Thiết bị)
Lưu trữ thông tin thiết bị cố định được gắn trong các phòng.
- **<u>FacilityID</u>** (INT IDENTITY(1,1), PK): Mã tự tăng của thiết bị.
- *SpaceCode* (VARCHAR(20), FK references SPACE(SpaceCode), NOT NULL): Thuộc phòng nào.
- FacilityName (NVARCHAR(100), NOT NULL): Tên thiết bị (VD: Máy chiếu Panasonic).
- FacilityType (VARCHAR(50), NOT NULL): Loại thiết bị (Projector, AC, Whiteboard, PC).
- Condition (VARCHAR(20), NOT NULL): Tình trạng (Good, Broken).

### 4. Bảng BOOKING_REQUEST (Yêu cầu đặt phòng)
Lưu trữ lịch sử và trạng thái của các yêu cầu đặt phòng, bao gồm cả quá trình check-in/out.
- **<u>BookingID</u>** (INT IDENTITY(1,1), PK): Mã yêu cầu tự tăng.
- *RequesterID* (VARCHAR(20), FK references USER(UserID), NOT NULL): Người gửi yêu cầu.
- *ApproverID* (VARCHAR(20), FK references USER(UserID), NULL): Người duyệt yêu cầu (Có thể NULL nếu đang chờ).
- *SpaceCode* (VARCHAR(20), FK references SPACE(SpaceCode), NOT NULL): Phòng được đặt.
- ReqStartTime (DATETIME, NOT NULL): Thời gian bắt đầu dự kiến.
- ReqEndTime (DATETIME, NOT NULL): Thời gian kết thúc dự kiến.
- Purpose (NVARCHAR(255), NOT NULL): Mục đích sử dụng.
- NumParticipants (INT, NOT NULL): Số lượng người tham gia dự kiến.
- Status (VARCHAR(20), NOT NULL): Trạng thái (Pending, Approved, Rejected, Cancelled, No-show, Completed).
- DecisionTime (DATETIME, NULL): Thời điểm được duyệt/từ chối.
- DecisionNote (NVARCHAR(255), NULL): Ghi chú của người duyệt.
- RejReason (NVARCHAR(255), NULL): Lý do từ chối (nếu có).
- *CheckInStaffID* (VARCHAR(20), FK references USER(UserID), NULL): Nhân viên hỗ trợ check-in/out thực tế (nếu có).
- ActualStartTime (DATETIME, NULL): Thời gian check-in thực tế.
- ActualEndTime (DATETIME, NULL): Thời gian check-out thực tế.
- InitialCond (NVARCHAR(255), NULL): Tình trạng phòng lúc nhận.
- FinalCond (NVARCHAR(255), NULL): Tình trạng phòng lúc trả.
- UsageNotes (NVARCHAR(255), NULL): Ghi chú sự cố trong quá trình dùng.

### 5. Bảng MAINTENANCE_RECORD (Hồ sơ bảo trì)
Lưu trữ lịch sử báo cáo sự cố và bảo trì của phòng.
- **<u>MaintenanceID</u>** (INT IDENTITY(1,1), PK): Mã bảo trì tự tăng.
- *SpaceCode* (VARCHAR(20), FK references SPACE(SpaceCode), NOT NULL): Phòng gặp sự cố/cần bảo trì.
- *ReporterID* (VARCHAR(20), FK references USER(UserID), NOT NULL): Người báo cáo sự cố.
- *HandlerID* (VARCHAR(20), FK references USER(UserID), NULL): Nhân viên được phân công xử lý (NULL nếu chưa ai nhận).
- ProblemDesc (NVARCHAR(MAX), NOT NULL): Mô tả sự cố/lý do bảo trì.
- StartTime (DATETIME, NOT NULL): Thời gian bắt đầu ghi nhận sự cố.
- CompletionTime (DATETIME, NULL): Thời gian hoàn thành sửa chữa.
- Status (VARCHAR(20), NOT NULL): Trạng thái (Reported, In Progress, Resolved).
- ResultNote (NVARCHAR(MAX), NULL): Kết quả/Ghi chú sau bảo trì.

---

## 2. Normalization (Chuẩn hóa dữ liệu)

Thiết kế trên đã tuân thủ **Dạng chuẩn 3 (3NF - Third Normal Form)**:

1. **1NF (First Normal Form)**: 
   - Tất cả các thuộc tính đều chứa các giá trị nguyên tử (atomic). Không có cột nào chứa mảng dữ liệu (ví dụ: danh sách thiết bị không nằm trong bảng `SPACE` mà tách ra thành bảng `FACILITY` riêng biệt chứa 1 record / 1 thiết bị).
2. **2NF (Second Normal Form)**: 
   - Không có bảng nào sử dụng khóa chính phức hợp (Composite Key). Khóa chính của các bảng đều là khóa đơn (Single-column PK). Do đó, hoàn toàn không xảy ra hiện tượng phụ thuộc một phần (Partial Dependency) vào khóa chính.
3. **3NF (Third Normal Form)**:
   - Mọi thuộc tính không phải khóa (non-key attributes) đều phụ thuộc trực tiếp vào khóa chính, không có hiện tượng phụ thuộc bắc cầu (Transitive Dependency). Ví dụ: Thông tin của người đặt phòng (Tên, Email) được lưu ở bảng `USER`, bảng `BOOKING_REQUEST` chỉ lưu `RequesterID` làm khóa ngoại, tránh dư thừa dữ liệu. 

Với mô hình mức logic này, cơ sở dữ liệu đảm bảo được tính toàn vẹn (Data Integrity), giảm thiểu tối đa sự bất thường khi Thêm, Sửa, Xóa (Anomaly).
