# 04 - Design Validation

Tài liệu này kiểm chứng thiết kế cơ sở dữ liệu đã xây dựng ở Bước 3 so với các yêu cầu nghiệp vụ ban đầu (Business Rules), đồng thời đề xuất các phương án bảo mật, phân quyền và tối ưu hiệu năng.

## 1. Cross-referencing Tables with Business Rules (Đối chiếu nghiệp vụ)

Dưới đây là bảng đối chiếu giữa các yêu cầu từ `01-business-req-analysis` và cấu trúc bảng của CSDL:

| Mã Yêu Cầu | Yêu cầu nghiệp vụ | Cách CSDL đáp ứng | Bảng liên quan |
| :--- | :--- | :--- | :--- |
| **BR-01** | Hệ thống phải lưu trữ đầy đủ thông tin người dùng với tài khoản trường (Mã số, Tên, Email, SĐT, Vai trò, Khoa). | Toàn bộ thuộc tính này đã được khai báo với kiểu dữ liệu phù hợp (VD: `Email` là UNIQUE). | `USER` |
| **BR-02** | Hệ thống phải quản lý được thông tin về Không gian/Phòng học (sức chứa, trạng thái, tòa nhà, loại phòng). | Các trường `Capacity`, `CurrentStatus`, `Building`, `SpaceType` giải quyết yêu cầu này. | `SPACE` |
| **BR-03** | Mỗi phòng có thể có nhiều trang thiết bị (Projector, AC, PC...). Phải biết thiết bị nào ở phòng nào và tình trạng ra sao. | Mối quan hệ 1-N (1 `SPACE` có nhiều `FACILITY` thông qua `SpaceCode` làm khóa ngoại). Trường `Condition` quản lý tình trạng. | `SPACE`, `FACILITY` |
| **BR-04** | Người dùng có thể đặt phòng cho các mục đích cụ thể, ghi rõ thời gian bắt đầu, kết thúc, số lượng người. | Lưu trực tiếp vào `ReqStartTime`, `ReqEndTime`, `Purpose`, `NumParticipants`. | `BOOKING_REQUEST` |
| **BR-05** | Quy trình Duyệt/Từ chối cần được ghi dấu vết: Ai duyệt, duyệt khi nào, lý do từ chối. | Quản lý bởi các trường: `ApproverID` (Khóa ngoại trỏ đến USER), `DecisionTime`, `DecisionNote`, `RejReason`. | `BOOKING_REQUEST` |
| **BR-06** | Theo dõi việc check-in / check-out thực tế của người dùng để xác nhận tình trạng phòng trước/sau khi dùng. | Lưu ở `ActualStartTime`, `ActualEndTime`, `InitialCond`, `FinalCond`, `CheckInStaffID`. | `BOOKING_REQUEST` |
| **BR-07** | Báo cáo sự cố và quản lý sửa chữa phòng. Cần biết ai báo cáo, ai sửa chữa và kết quả. | Quản lý bởi `ReporterID`, `HandlerID`, thời gian `StartTime`, `CompletionTime` và `ResultNote`. | `MAINTENANCE_RECORD` |

---

## 2. Security & Access Control Considerations (Bảo mật và Phân quyền)

Hệ thống nên áp dụng cơ chế **RBAC (Role-Based Access Control)**. Các Roles bao gồm: `Student`, `Lecturer`, `TA`, `Facility Staff`, `Dept Admin`, `Facility Manager`.

*   **Row-Level Security (Bảo mật cấp dòng):**
    *   Sinh viên (`Student`) chỉ được phép xem các `BOOKING_REQUEST` do chính họ tạo ra (Mệnh đề `WHERE RequesterID = @CurrentUserID`).
    *   Nhân viên cơ sở vật chất (`Facility Staff`) được xem toàn bộ yêu cầu đặt phòng nhưng chỉ được thao tác cập nhật (Check-in/Check-out, duyệt) trong phạm vi tòa nhà hoặc nhóm phòng họ phụ trách.
*   **Data Masking (Che dấu dữ liệu):**
    *   Thông tin `PhoneNumber`, `Email` của người dùng có thể được che đi đối với các tài khoản không có quyền Admin/Manager.
*   **Integrity (Tính Toàn vẹn):**
    *   `Email` có Constraint `UNIQUE` để đảm bảo không trùng lặp tài khoản.
    *   Các trường có đuôi `ID` / `Code` đều ràng buộc FK chặt chẽ (ON UPDATE CASCADE) để không có dữ liệu mồ côi (Orphaned Data).

---

## 3. Performance Considerations (Tối ưu hiệu năng / Indexes)

Dự kiến khi số lượng sinh viên và sự kiện tăng lên, bảng `BOOKING_REQUEST` và `MAINTENANCE_RECORD` sẽ lớn rất nhanh. Để hệ thống truy xuất nhanh, cần tạo các **Index** (Chỉ mục) sau:

1.  **Index trên Thời gian (Date/Time):**
    *   `CREATE NONCLUSTERED INDEX IX_BookingReq_Times ON BOOKING_REQUEST (ReqStartTime, ReqEndTime);`
    *   *Lý do:* Tối ưu hóa truy vấn tìm phòng trống hoặc kiểm tra xung đột (conflict) lịch đặt phòng.
2.  **Index trên Khóa ngoại (Foreign Keys):**
    *   `CREATE NONCLUSTERED INDEX IX_BookingReq_SpaceCode ON BOOKING_REQUEST (SpaceCode);`
    *   `CREATE NONCLUSTERED INDEX IX_Facility_SpaceCode ON FACILITY (SpaceCode);`
    *   *Lý do:* Tăng tốc cho các phép `JOIN` từ phòng ra thiết bị hoặc ra danh sách yêu cầu của phòng đó.
3.  **Index trên Trạng thái:**
    *   `CREATE NONCLUSTERED INDEX IX_BookingReq_Status ON BOOKING_REQUEST (Status);`
    *   *Lý do:* Giúp các Admin nhanh chóng lọc ra các yêu cầu đang ở trạng thái `Pending` cần phải duyệt.
4.  **Index trên User:**
    *   `CREATE NONCLUSTERED INDEX IX_BookingReq_Requester ON BOOKING_REQUEST (RequesterID);`
    *   *Lý do:* Tìm nhanh lịch sử đặt phòng của một cá nhân cụ thể.
