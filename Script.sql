create database HealthOneMedical
go
use HealthOneMedical
go

create table Patient
(
	PatientID int not null identity(1, 1) primary key,
	FirstName varchar(20) not null,
	LastName varchar(20) not null,
	Address varchar(50),
	Phone char(10) not null,
	Email varchar(50),
	InsuranceIDNumber varchar(20),
	InsuranceCompanyID int,
	PrimaryCareDoctorID int not null,
)
go

create table Doctor
(
	DoctorID int identity(1, 1) not null primary key,
	FirstName varchar(20) not null,
	LastName varchar(20) not null,
	Address varchar(50),
	Phone char(10) not null,
	Email varchar(50),
	SpecializationID int not null
)
go

create table InsuranceCompany
(
	CompanyID int identity(1, 1) not null primary key,
	CompanyName varchar(50) not null,
	Phone char(10)
)

create table Specialization
(
	SpecializationID int identity(1, 1) not null primary key,
	SpecializationName varchar(30) not null
)
go

create table Hospital
(
	HospitalID int identity(1, 1) not null primary key,
	HospitalName varchar(50) not null,
	Email varchar(50),
	Address varchar(50),
)
go

create table Affiliation
(
	AffiliationID int identity(1, 1) not null primary key,
	HospitalID int not null,
	DoctorID int not null,
	AffiliationDate datetime
)
go

create table Prescription
(
	PrescriptionID int identity(1, 1) not null primary key,
	DoctorID int not null,
	PatientID int not null,
	DatePrescribed datetime,
	Description varchar(100)
)
go

create table Medicine
(
	MedicineID int identity(1, 1) not null primary key,
	MedicineName varchar(50) not null,
	Usage varchar(50) not null,
	SideEffects varchar(50)
)
go

create table MedicineRequire
(
	LogID int identity(1, 1) not null primary key,
	PrescriptionID int not null,
	MedicineID int not null,
	Dosage varchar(20)
)
go

create table Visit
(
	VisitID int identity(1, 1) not null primary key,
	VisitDate datetime,
	DoctorID int not null,
	PatientID int not null,
	VisitType int not null, check (VisitType in (1, 2, 3)),
	unique(VisitID, VisitType)
)
go

create table InitialVisit
(
	VisitID int not null primary key,
	VisitType int default 1 not null, check(VisitType = 1),
	InitialDiagnose varchar(100)
)
go

create table FollowUpVisit
(
	VisitID int not null primary key,
	VisitType int default 2 not null, check(VisitType = 2),
	DiagnoseStatus varchar(100)
)
go

create table RoutineVisit
(
	VisitID int not null primary key,
	VisitType int default 3 not null, check(VisitType = 3),
	BloodPressure int not null,
	Weight int not null,
	Height int not null
)
go

create table PrimaryCareHistory
(
	LogID int identity(1, 1) not null primary key,
	PatientID int not null,
	DoctorID int not null,
	StartDate datetime,
	EndDate datetime
)

alter table Patient
add constraint PrimaryCareDoctor_FK 
	foreign key (PrimaryCareDoctorID) 
	references Doctor(DoctorID),

	constraint InsuranceCompany_FK 
	foreign key (InsuranceCompanyID) 
	references InsuranceCompany(CompanyID)
go

alter table Doctor
add constraint SpecializationFK
	foreign key (SpecializationID)
	references Specialization(SpecializationID)
go

alter table Affiliation
add constraint Affiliation_Doctor_FK
	foreign key (DoctorID)
	references Doctor(DoctorID),

	constraint Affiliation_Hospital_FK
	foreign key (HospitalID)
	references Hospital(HospitalID)
go

alter table InitialVisit
add	constraint InitialVisit_FK
	foreign key (VisitID, VisitType)
	references Visit(VisitID, VisitType)
go

alter table FollowUpVisit
add	constraint FollowUpVisit_FK
	foreign key (VisitID, VisitType)
	references Visit(VisitID, VisitType)
go

alter table RoutineVisit
add	constraint RoutineVisit_FK
	foreign key (VisitID, VisitType)
	references Visit(VisitID, VisitType)
go

alter table MedicineRequire
add constraint MedicineRequire_Prescription_FK
	foreign key (PrescriptionID)
	references Prescription(PrescriptionID),

	constraint MedicineRequire_Medicine_FK
	foreign key (MedicineID)
	references Medicine(MedicineID)
go

alter table Prescription
add constraint Prescription_Doctor_FK
	foreign key (DoctorID)
	references Doctor(DoctorID),

	constraint Prescription_Patient_FK
	foreign key (PatientID)
	references Patient(PatientID)
go

alter table Visit
add constraint Visit_Doctor_FK
	foreign key (DoctorID)
	references Doctor(DoctorID),

	constraint Visit_Patient_FK
	foreign key (PatientID)
	references Patient(PatientID)
go

alter table PrimaryCareHistory
add constraint PrimaryCare_Doctor_FK
	foreign key (DoctorID)
	references Doctor(DoctorID),

	constraint PrimaryCare_Patient_FK
	foreign key (PatientID)
	references Patient(PatientID)
go