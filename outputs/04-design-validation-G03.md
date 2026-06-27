# Design Validation

## 1. Business Rules Cross-Reference
- **Rule:** A space cannot have two approved bookings with overlapping time periods.
  - **Validation:** Implemented via application logic during INSERT/UPDATE on `Bookings`, or through a trigger validating `ReqStartTime` and `ReqEndTime` against existing approved bookings for the same `SpaceCode`.
- **Rule:** A space under maintenance cannot be booked.
  - **Validation:** The `Spaces` table has a `CurrentStatus` column. Booking queries check this column before allowing a booking creation. 
- **Rule:** Rejection reason must be stored.
  - **Validation:** Supported by `RejReason` in the `Bookings` table.
- **Rule:** Only university accounts can book.
  - **Validation:** Enforced by foreign key `RequesterID` linking to the `Users` table which holds authenticated users.

## 2. Security & Access Control
- **Data Privacy**: Passwords are not stored in this schema (assumes SSO/University Authentication). `Email` and `Phone` should have restricted read access, visible only to Staff/Admins and the owner.
- **Role-Based Access (RBAC)**: 
  - Students/Lecturers: Can only read spaces, create pending bookings, and view their own history.
  - Facility Staff: Can update Booking statuses (check-in, check-out), manage Maintenance, read all user info.
  - Manager: Can perform all Staff actions, plus modify `Spaces`, `Facilities`, and generate reports.

## 3. Performance Considerations & Indexes
To optimize database performance, particularly for the most common lookup and filtering queries:
- **Idx_Bookings_Space_Time**: `CREATE INDEX` on `Bookings (SpaceCode, ReqStartTime, ReqEndTime)` -> Speeds up overlap conflict checks.
- **Idx_Bookings_Status**: `CREATE INDEX` on `Bookings (Status)` -> Speeds up finding pending requests for staff.
- **Idx_Maintenance_Status**: `CREATE INDEX` on `Maintenance_Records (Status)` -> Quickly filters unresolved maintenance issues.
- **Idx_Bookings_Requester**: `CREATE INDEX` on `Bookings (RequesterID)` -> Quick access to an individual's booking history.
