# Business Requirement Analysis

## Executive Summary
The School of Computer Science needs a database system to manage shared physical spaces (auditoriums, classrooms, labs, meeting rooms) to replace the current manual process. The system will handle booking, approval, usage sessions, maintenance, and facility utilization.

## Actors / Users
- Student
- Lecturer
- Teaching Assistant
- Facility Staff
- Department Administrator
- Facility Manager

## Key Business Entities
1. **User**: Information of the requester or staff (ID, Name, Email, Phone, Role, Dept, Status).
2. **Space**: The physical space (Code, Name, Type, Building, Floor, Room Number, Capacity, Status, Usage Policy).
3. **Facility**: Equipment present in spaces (e.g., projector, computer).
4. **Booking**: Reservation request (Space, Start Time, End Time, Purpose, Participants, Status, Approval Info, Check-in/out Info).
5. **Maintenance**: Record of repairs or issues (Space, Reporter, Assigned Staff, Description, Start, End, Status).

## Major Business Processes / Use Cases
- User submits a space booking request.
- Facility Staff / Manager approves or rejects the booking request.
- Facility Staff checks in the booking when the user arrives (records actual start and condition).
- Facility Staff completes the booking when the session ends (records actual end and condition).
- Staff logs and manages space maintenance records.
- Staff views booking and maintenance histories.

## Business Rules & Constraints
- Users must have a valid university account.
- A space cannot have two approved bookings with overlapping time periods.
- Spaces that are under maintenance, closed, or retired cannot be booked.
- Booking approvals must record the staff member who made the decision, time, and note (reason for rejection if rejected).

## Assumptions & Unresolved Questions
- **Assumption**: All facilities are bound to the space directly. If specific facilities can be moved, a more complex inventory management would be needed. Currently, assuming facility availability is static per space.
- **Unresolved Question**: How far in advance can a booking be made? What are the operating hours?
