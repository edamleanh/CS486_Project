# Logical Database Design

## 1. Relational Schema Mapping
The Conceptual ERD has been mapped to the following normalized tables (3NF):

### `Users` Table
- **UserID** (VARCHAR(20), PK)
- **FullName** (NVARCHAR(100), NOT NULL)
- **Email** (VARCHAR(100), UNIQUE, NOT NULL)
- **Phone** (VARCHAR(15))
- **Role** (VARCHAR(50), NOT NULL) - e.g., 'Student', 'Lecturer', 'Facility Staff', 'Manager'
- **Department** (NVARCHAR(100))
- **AccountStatus** (VARCHAR(20), NOT NULL) - e.g., 'Active', 'Suspended'

### `Spaces` Table
- **SpaceCode** (VARCHAR(20), PK)
- **SpaceName** (NVARCHAR(100), NOT NULL)
- **SpaceType** (VARCHAR(50), NOT NULL) - e.g., 'Classroom', 'Auditorium'
- **Building** (VARCHAR(50), NOT NULL)
- **Floor** (INT)
- **RoomNumber** (VARCHAR(20), NOT NULL)
- **Capacity** (INT, NOT NULL)
- **CurrentStatus** (VARCHAR(20), NOT NULL) - e.g., 'Available', 'Maintenance', 'Closed'
- **UsagePolicy** (NVARCHAR(500))

### `Facilities` Table
- **FacilityID** (INT, Identity, PK)
- **FacilityName** (NVARCHAR(100), NOT NULL)
- **Description** (NVARCHAR(255))

### `Space_Facilities` Table
- **SpaceCode** (VARCHAR(20), PK, FK to Spaces)
- **FacilityID** (INT, PK, FK to Facilities)
- **Quantity** (INT, NOT NULL, Default 1)

### `Bookings` Table
- **BookingID** (INT, Identity, PK)
- **SpaceCode** (VARCHAR(20), FK to Spaces, NOT NULL)
- **RequesterID** (VARCHAR(20), FK to Users, NOT NULL)
- **ApproverID** (VARCHAR(20), FK to Users, NULL)
- **ReqStartTime** (DATETIME, NOT NULL)
- **ReqEndTime** (DATETIME, NOT NULL)
- **Purpose** (NVARCHAR(255), NOT NULL)
- **Participants** (INT, NOT NULL)
- **Status** (VARCHAR(20), NOT NULL) - 'Pending', 'Approved', 'Rejected', 'Cancelled', 'Checked In', 'Completed', 'No-show'
- **DecisionTime** (DATETIME, NULL)
- **RejReason** (NVARCHAR(255), NULL)
- **CheckInStaffID** (VARCHAR(20), FK to Users, NULL)
- **ActualStartTime** (DATETIME, NULL)
- **InitialCondition** (NVARCHAR(255), NULL)
- **CheckOutStaffID** (VARCHAR(20), FK to Users, NULL)
- **ActualEndTime** (DATETIME, NULL)
- **FinalCondition** (NVARCHAR(255), NULL)
- **UsageNotes** (NVARCHAR(500), NULL)

### `Maintenance_Records` Table
- **MaintenanceID** (INT, Identity, PK)
- **SpaceCode** (VARCHAR(20), FK to Spaces, NOT NULL)
- **ReporterID** (VARCHAR(20), FK to Users, NOT NULL)
- **AssignedStaffID** (VARCHAR(20), FK to Users, NULL)
- **ProblemDesc** (NVARCHAR(500), NOT NULL)
- **StartTime** (DATETIME, NOT NULL)
- **CompletionTime** (DATETIME, NULL)
- **Status** (VARCHAR(20), NOT NULL) - 'Reported', 'In Progress', 'Completed'
- **ResultNote** (NVARCHAR(500), NULL)

## 2. Normalization Justification
All tables conform to the Third Normal Form (3NF):
- **1NF**: All attributes are atomic. There are no repeating groups. The Many-to-Many relationship between `Spaces` and `Facilities` has been resolved using the junction table `Space_Facilities`.
- **2NF**: All non-key attributes are fully functionally dependent on the entire primary key. In `Space_Facilities`, `Quantity` depends on both `SpaceCode` and `FacilityID`.
- **3NF**: There are no transitive dependencies. No non-key attribute depends on another non-key attribute. For instance, in `Bookings`, `RejReason` depends solely on the `BookingID`.
