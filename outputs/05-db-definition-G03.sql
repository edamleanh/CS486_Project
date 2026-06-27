-- ======================================================================
-- DATABASE DEFINITION (DDL) SCRIPT - GROUP 03
-- ======================================================================

-- 1. DROP EXISTING TABLES FOR IDEMPOTENCY
IF OBJECT_ID('Maintenance_Records', 'U') IS NOT NULL DROP TABLE Maintenance_Records;
IF OBJECT_ID('Space_Facilities', 'U') IS NOT NULL DROP TABLE Space_Facilities;
IF OBJECT_ID('Bookings', 'U') IS NOT NULL DROP TABLE Bookings;
IF OBJECT_ID('Facilities', 'U') IS NOT NULL DROP TABLE Facilities;
IF OBJECT_ID('Spaces', 'U') IS NOT NULL DROP TABLE Spaces;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;

-- 2. CREATE TABLES

CREATE TABLE Users (
    UserID VARCHAR(20) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    Role VARCHAR(50) NOT NULL, 
    Department NVARCHAR(100),
    AccountStatus VARCHAR(20) NOT NULL DEFAULT 'Active'
);

CREATE TABLE Spaces (
    SpaceCode VARCHAR(20) PRIMARY KEY,
    SpaceName NVARCHAR(100) NOT NULL,
    SpaceType VARCHAR(50) NOT NULL,
    Building VARCHAR(50) NOT NULL,
    Floor INT,
    RoomNumber VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    CurrentStatus VARCHAR(20) NOT NULL DEFAULT 'Available',
    UsagePolicy NVARCHAR(500)
);

CREATE TABLE Facilities (
    FacilityID INT IDENTITY(1,1) PRIMARY KEY,
    FacilityName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);

CREATE TABLE Space_Facilities (
    SpaceCode VARCHAR(20) NOT NULL,
    FacilityID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1 CHECK (Quantity > 0),
    PRIMARY KEY (SpaceCode, FacilityID),
    FOREIGN KEY (SpaceCode) REFERENCES Spaces(SpaceCode) ON DELETE CASCADE,
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID) ON DELETE CASCADE
);

CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    SpaceCode VARCHAR(20) NOT NULL,
    RequesterID VARCHAR(20) NOT NULL,
    ApproverID VARCHAR(20) NULL,
    ReqStartTime DATETIME NOT NULL,
    ReqEndTime DATETIME NOT NULL,
    Purpose NVARCHAR(255) NOT NULL,
    Participants INT NOT NULL CHECK (Participants > 0),
    Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    DecisionTime DATETIME NULL,
    RejReason NVARCHAR(255) NULL,
    CheckInStaffID VARCHAR(20) NULL,
    ActualStartTime DATETIME NULL,
    InitialCondition NVARCHAR(255) NULL,
    CheckOutStaffID VARCHAR(20) NULL,
    ActualEndTime DATETIME NULL,
    FinalCondition NVARCHAR(255) NULL,
    UsageNotes NVARCHAR(500) NULL,
    
    FOREIGN KEY (SpaceCode) REFERENCES Spaces(SpaceCode),
    FOREIGN KEY (RequesterID) REFERENCES Users(UserID),
    FOREIGN KEY (ApproverID) REFERENCES Users(UserID),
    FOREIGN KEY (CheckInStaffID) REFERENCES Users(UserID),
    FOREIGN KEY (CheckOutStaffID) REFERENCES Users(UserID),
    CONSTRAINT CHK_ReqTime CHECK (ReqEndTime > ReqStartTime),
    CONSTRAINT CHK_ActualTime CHECK (ActualEndTime >= ActualStartTime OR ActualEndTime IS NULL)
);

CREATE TABLE Maintenance_Records (
    MaintenanceID INT IDENTITY(1,1) PRIMARY KEY,
    SpaceCode VARCHAR(20) NOT NULL,
    ReporterID VARCHAR(20) NOT NULL,
    AssignedStaffID VARCHAR(20) NULL,
    ProblemDesc NVARCHAR(500) NOT NULL,
    StartTime DATETIME NOT NULL,
    CompletionTime DATETIME NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Reported',
    ResultNote NVARCHAR(500) NULL,
    
    FOREIGN KEY (SpaceCode) REFERENCES Spaces(SpaceCode),
    FOREIGN KEY (ReporterID) REFERENCES Users(UserID),
    FOREIGN KEY (AssignedStaffID) REFERENCES Users(UserID)
);

-- 3. CREATE INDEXES
CREATE INDEX Idx_Bookings_Space_Time ON Bookings(SpaceCode, ReqStartTime, ReqEndTime);
CREATE INDEX Idx_Bookings_Status ON Bookings(Status);
CREATE INDEX Idx_Bookings_Requester ON Bookings(RequesterID);
CREATE INDEX Idx_Maintenance_Status ON Maintenance_Records(Status);
