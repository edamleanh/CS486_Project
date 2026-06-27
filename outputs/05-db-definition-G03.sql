-- 05 - Database Definition (DDL) for Space Management System

-- =======================================================
-- DROP EXISTING TABLES (Reverse Dependency Order)
-- =======================================================
DROP TABLE IF EXISTS MAINTENANCE_RECORD;
DROP TABLE IF EXISTS BOOKING_REQUEST;
DROP TABLE IF EXISTS FACILITY;
DROP TABLE IF EXISTS SPACE;
DROP TABLE IF EXISTS [USER]; -- USER is a reserved keyword in SQL Server

-- =======================================================
-- TABLE CREATION
-- =======================================================

-- 1. Create USER table
CREATE TABLE [USER] (
    UserID VARCHAR(20) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20) NULL,
    Role VARCHAR(50) NOT NULL,
    Department NVARCHAR(100) NULL,
    AccountStatus VARCHAR(20) NOT NULL
);

-- 2. Create SPACE table
CREATE TABLE SPACE (
    SpaceCode VARCHAR(20) PRIMARY KEY,
    SpaceName NVARCHAR(100) NOT NULL,
    SpaceType VARCHAR(50) NOT NULL,
    Building NVARCHAR(50) NOT NULL,
    FloorLevel INT NOT NULL,
    RoomNumber VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL,
    CurrentStatus VARCHAR(20) NOT NULL,
    UsagePolicy NVARCHAR(MAX) NULL
);

-- 3. Create FACILITY table
CREATE TABLE FACILITY (
    FacilityID INT IDENTITY(1,1) PRIMARY KEY,
    SpaceCode VARCHAR(20) NOT NULL,
    FacilityName NVARCHAR(100) NOT NULL,
    FacilityType VARCHAR(50) NOT NULL,
    Condition VARCHAR(20) NOT NULL,
    
    CONSTRAINT FK_Facility_Space FOREIGN KEY (SpaceCode) REFERENCES SPACE(SpaceCode)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. Create BOOKING_REQUEST table
CREATE TABLE BOOKING_REQUEST (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    RequesterID VARCHAR(20) NOT NULL,
    ApproverID VARCHAR(20) NULL,
    SpaceCode VARCHAR(20) NOT NULL,
    ReqStartTime DATETIME NOT NULL,
    ReqEndTime DATETIME NOT NULL,
    Purpose NVARCHAR(255) NOT NULL,
    NumParticipants INT NOT NULL,
    Status VARCHAR(20) NOT NULL,
    DecisionTime DATETIME NULL,
    DecisionNote NVARCHAR(255) NULL,
    RejReason NVARCHAR(255) NULL,
    CheckInStaffID VARCHAR(20) NULL,
    ActualStartTime DATETIME NULL,
    ActualEndTime DATETIME NULL,
    InitialCond NVARCHAR(255) NULL,
    FinalCond NVARCHAR(255) NULL,
    UsageNotes NVARCHAR(255) NULL,

    CONSTRAINT FK_Booking_Requester FOREIGN KEY (RequesterID) REFERENCES [USER](UserID)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_Booking_Approver FOREIGN KEY (ApproverID) REFERENCES [USER](UserID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Booking_Space FOREIGN KEY (SpaceCode) REFERENCES SPACE(SpaceCode)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Booking_CheckInStaff FOREIGN KEY (CheckInStaffID) REFERENCES [USER](UserID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- 5. Create MAINTENANCE_RECORD table
CREATE TABLE MAINTENANCE_RECORD (
    MaintenanceID INT IDENTITY(1,1) PRIMARY KEY,
    SpaceCode VARCHAR(20) NOT NULL,
    ReporterID VARCHAR(20) NOT NULL,
    HandlerID VARCHAR(20) NULL,
    ProblemDesc NVARCHAR(MAX) NOT NULL,
    StartTime DATETIME NOT NULL,
    CompletionTime DATETIME NULL,
    Status VARCHAR(20) NOT NULL,
    ResultNote NVARCHAR(MAX) NULL,

    CONSTRAINT FK_Maintenance_Space FOREIGN KEY (SpaceCode) REFERENCES SPACE(SpaceCode)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Maintenance_Reporter FOREIGN KEY (ReporterID) REFERENCES [USER](UserID)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_Maintenance_Handler FOREIGN KEY (HandlerID) REFERENCES [USER](UserID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- =======================================================
-- INDEX CREATION (Performance Optimization)
-- =======================================================

-- Indexes on Time and Status for fast booking lookups
CREATE NONCLUSTERED INDEX IX_BookingReq_Times ON BOOKING_REQUEST (ReqStartTime, ReqEndTime);
CREATE NONCLUSTERED INDEX IX_BookingReq_Status ON BOOKING_REQUEST (Status);

-- Indexes on Foreign Keys to speed up JOIN operations
CREATE NONCLUSTERED INDEX IX_BookingReq_SpaceCode ON BOOKING_REQUEST (SpaceCode);
CREATE NONCLUSTERED INDEX IX_BookingReq_Requester ON BOOKING_REQUEST (RequesterID);
CREATE NONCLUSTERED INDEX IX_Facility_SpaceCode ON FACILITY (SpaceCode);
CREATE NONCLUSTERED INDEX IX_Maintenance_SpaceCode ON MAINTENANCE_RECORD (SpaceCode);
