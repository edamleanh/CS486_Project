# Conceptual Design / ERD

## Entities & Attributes
- **USER**: UserID (PK), FullName, Email, Phone, Role, Department, AccountStatus
- **SPACE**: SpaceCode (PK), SpaceName, SpaceType, Building, Floor, RoomNumber, Capacity, CurrentStatus, UsagePolicy
- **FACILITY**: FacilityID (PK), FacilityName, Description
- **BOOKING**: BookingID (PK), SpaceCode (FK), RequesterID (FK), ApproverID (FK), CheckInStaffID (FK), CheckOutStaffID (FK), ReqStartTime, ReqEndTime, Purpose, Participants, Status, RejReason, DecisionTime, ActualStartTime, InitialCondition, ActualEndTime, FinalCondition, UsageNotes
- **MAINTENANCE**: MaintenanceID (PK), SpaceCode (FK), ReporterID (FK), AssignedStaffID (FK), ProblemDesc, StartTime, CompletionTime, Status, ResultNote

## Relationships & Cardinality
- A USER can make multiple BOOKINGs (1:N)
- A SPACE can have multiple BOOKINGs (1:N)
- A USER (Staff) can approve/check-in/check-out multiple BOOKINGs (1:N)
- A SPACE has a many-to-many relationship with FACILITY (N:M), resolved by SPACE_FACILITY
- A SPACE can have multiple MAINTENANCE records (1:N)
- A USER can report or be assigned to multiple MAINTENANCE records (1:N)

## ERD Diagram

```mermaid
erDiagram
    USER ||--o{ BOOKING : requests
    USER ||--o{ BOOKING : approves
    USER ||--o{ BOOKING : checks_in
    USER ||--o{ BOOKING : checks_out
    USER ||--o{ MAINTENANCE : reports
    USER ||--o{ MAINTENANCE : assigned_to

    SPACE ||--o{ BOOKING : hosts
    SPACE ||--o{ MAINTENANCE : undergoes
    SPACE ||--o{ SPACE_FACILITY : contains

    FACILITY ||--o{ SPACE_FACILITY : placed_in

    USER {
        string UserID PK
        string FullName
        string Email
        string Phone
        string Role
        string Department
        string AccountStatus
    }

    SPACE {
        string SpaceCode PK
        string SpaceName
        string SpaceType
        string Building
        int Floor
        string RoomNumber
        int Capacity
        string CurrentStatus
        string UsagePolicy
    }

    FACILITY {
        int FacilityID PK
        string FacilityName
        string Description
    }

    SPACE_FACILITY {
        string SpaceCode PK, FK
        int FacilityID PK, FK
        int Quantity
    }

    BOOKING {
        int BookingID PK
        string SpaceCode FK
        string RequesterID FK
        string ApproverID FK
        datetime ReqStartTime
        datetime ReqEndTime
        string Purpose
        int Participants
        string Status
        datetime DecisionTime
        string RejReason
        string CheckInStaffID FK
        datetime ActualStartTime
        string InitialCondition
        string CheckOutStaffID FK
        datetime ActualEndTime
        string FinalCondition
        string UsageNotes
    }

    MAINTENANCE {
        int MaintenanceID PK
        string SpaceCode FK
        string ReporterID FK
        string AssignedStaffID FK
        string ProblemDesc
        datetime StartTime
        datetime CompletionTime
        string Status
        string ResultNote
    }
```
