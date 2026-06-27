# 01 - Business Requirement Analysis

## 1. Mục đích nghiệp vụ (Business Purpose)
Hệ thống được xây dựng nhằm giúp Trường quản lý các không gian chung một cách công bằng, tránh tình trạng đặt phòng trùng lặp thời gian, ngăn chặn việc đặt các phòng không khả dụng và lưu trữ lại toàn bộ lịch sử sử dụng. Cụ thể, hệ thống quản lý toàn diện quy trình đặt phòng, phê duyệt, các phiên sử dụng, bảo trì, báo cáo sự cố và mức độ sử dụng cơ sở vật chất.

## 2. Các tác nhân (Actors)
Người dùng hệ thống bắt buộc phải có tài khoản của trường. Các tác nhân tham gia vào hệ thống bao gồm:
*   Sinh viên (Student)
*   Giảng viên (Lecturer)
*   Trợ giảng (Teaching Assistant)
*   Nhân viên cơ sở vật chất (Facility staff)
*   Quản trị viên khoa (Department administrator)
*   Quản lý cơ sở vật chất (Facility manager)

## 3. Các thực thể và thuộc tính (Entities & Attributes)
Dựa trên mô tả, chúng ta xác định được các thực thể và thuộc tính cốt lõi sau:

*   **User (Người dùng):** User ID, Full name, Email, Phone number, Role, Department, Account status.
*   **Space (Không gian/Phòng):** Space code, Space name, Space type, Building, Floor, Room number, Capacity, Current status, Usage policy.
*   **Facility (Thiết bị/Tiện ích):** Facility Name/Type (ví dụ: máy chiếu, bảng trắng, máy tính, điều hòa...).
*   **Booking Request (Yêu cầu đặt phòng):** Requested start time, Requested end time, Purpose of use, Expected number of participants, Status.
    *   *Các thuộc tính phát sinh trong quá trình xử lý:* Decision time, Decision note, Rejection reason (nếu bị từ chối).
    *   *Các thuộc tính phát sinh trong quá trình sử dụng:* Actual start time, Actual end time, Initial condition, Final condition, Usage notes.
*   **Maintenance Record (Hồ sơ bảo trì):** Reporter (người báo cáo), Problem description, Start time, Completion time, Status, Result note.

## 4. Mối quan hệ và Bản số (Relationships & Cardinalities)
Dựa trên nguyên tắc xác định bản số (Multiplicity), hệ thống có các mối quan hệ sau:

*   `User` **Submits (Gửi)** `Booking Request`: Một người dùng có thể tạo nhiều yêu cầu, mỗi yêu cầu chỉ thuộc về một người dùng (1:N).
*   `Space` **Has (Có)** `Booking Request`: Một không gian có thể có nhiều yêu cầu đặt phòng, một yêu cầu chỉ đặt một không gian (1:N).
*   `User` (Staff/Manager) **Approves/Rejects (Duyệt/Từ chối)** `Booking Request`: Một nhân viên có thể duyệt nhiều yêu cầu (1:N).
*   `User` (Staff) **Checks-in/Completes (Làm thủ tục)** `Booking Request`: Một nhân viên có thể làm thủ tục cho nhiều phiên sử dụng (1:N).
*   `Space` **Contains (Chứa)** `Facility`: Một không gian có thể có nhiều thiết bị, và một loại thiết bị có thể nằm ở nhiều không gian (M:N).
*   `Space` **Undergoes (Trải qua)** `Maintenance Record`: Một không gian có thể có nhiều lịch sử bảo trì (1:N).
*   `User` (Staff) **Is Assigned to (Được giao xử lý)** `Maintenance Record`: Một nhân viên có thể được phân công xử lý nhiều hồ sơ bảo trì (1:N).

## 5. Quy tắc nghiệp vụ (Business Rules)
Các quy tắc hệ thống phải tuân thủ nghiêm ngặt để đảm bảo tính toàn vẹn dữ liệu (Integrity Constraints):

1.  **Quy tắc tài khoản:** Mọi người dùng đều phải có tài khoản trường học hợp lệ.
2.  **Quy tắc chống trùng lặp:** Không được phép có hai lượt đặt phòng đã được phê duyệt trên cùng một không gian mà có thời gian (start time - end time) trùng lặp nhau.
3.  **Quy tắc khả dụng:** Không thể đặt các không gian đang trong tình trạng bảo trì, tạm đóng cửa hoặc ngừng hoạt động.
4.  **Quy tắc phê duyệt:** Khi một yêu cầu đặt phòng được phê duyệt hoặc từ chối, hệ thống bắt buộc phải ghi nhận người ra quyết định, thời gian quyết định và ghi chú (phải có lý do cụ thể nếu từ chối).
5.  **Quy tắc sử dụng (Check-in/Check-out):** 
    *   Lúc bắt đầu, nhân viên phải check-in để ghi nhận thời gian bắt đầu thực tế, người check-in và tình trạng ban đầu của phòng.
    *   Lúc kết thúc, nhân viên phải hoàn tất (check-out) để ghi nhận thời gian kết thúc thực tế, tình trạng cuối cùng và ghi chú sử dụng.

