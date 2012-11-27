IF OBJECT_ID('dbo.Flight_Reservation') IS NOT NULL
BEGIN
	DROP TABLE Flight_Reservation;
END;

IF OBJECT_ID('dbo.ReservationPreference') IS NOT NULL
BEGIN
	DROP TABLE ReservationPreference;
END;

IF OBJECT_ID('dbo.Reservation') IS NOT NULL
BEGIN
	DROP TABLE Reservation;
END;

IF OBJECT_ID('dbo.Flight') IS NOT NULL
BEGIN
	DROP TABLE Flight;
END;

IF OBJECT_ID('dbo.FrequentFlyer') IS NOT NULL
BEGIN
	DROP TABLE FrequentFlyer;
END;

IF OBJECT_ID('dbo.PaymentMethod') IS NOT NULL
BEGIN
	DROP TABLE PaymentMethod;
END;

IF OBJECT_ID('dbo.Customer') IS NOT NULL
BEGIN
	DROP TABLE Customer;
END; 

IF OBJECT_ID('dbo.Preference') IS NOT NULL
BEGIN
	DROP TABLE Preference;
END;

IF OBJECT_ID('dbo.PaymentType') IS NOT NULL
BEGIN
	DROP TABLE PaymentType;
END;

IF OBJECT_ID('dbo.ReservationStatus') IS NOT NULL
BEGIN
	DROP TABLE ReservationStatus;
END;

IF OBJECT_ID('dbo.Agent') IS NOT NULL
BEGIN
	DROP TABLE Agent;
END;

IF OBJECT_ID('dbo.Airplane') IS NOT NULL
BEGIN
	DROP TABLE Airplane;
END;

IF OBJECT_ID('dbo.Carrier') IS NOT NULL
BEGIN
	DROP TABLE Carrier;
END;

IF OBJECT_ID('dbo.Airport') IS NOT NULL
BEGIN
	DROP TABLE Airport;
END;

CREATE TABLE Airport
(
	InternationalCode VARCHAR(5) NOT NULL PRIMARY KEY,
	Name VARCHAR(255) NOT NULL,
	City VARCHAR(45) NOT NULL,
	Country VARCHAR(45) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL
);

CREATE TABLE Carrier
(
	Name VARCHAR(45) NOT NULL PRIMARY KEY,
	Address VARCHAR(45) NOT NULL,
	City VARCHAR(45) NOT NULL,
	State VARCHAR(45) NOT NULL,
	Country VARCHAR(45) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL
);

CREATE TABLE Airplane
(
	AirplaneID INT NOT NULL IDENTITY PRIMARY KEY,
	[Identity] VARCHAR(10) NOT NULL,
	[Type] VARCHAR(10) NOT NULL,
	BusinessCapacity INT NOT NULL,
	EconomyCapacity INT NOT NULL
);

CREATE TABLE Agent
(
	Id INT IDENTITY NOT NULL PRIMARY KEY,
	FirstName VARCHAR(45) NOT NULL,
	LastName VARCHAR(45) NOT NULL
);

CREATE TABLE ReservationStatus
(
	Id INT IDENTITY NOT NULL PRIMARY KEY,
	Name VARCHAR(45) NOT NULL UNIQUE
);

CREATE TABLE PaymentType
(
	Id INT IDENTITY NOT NULL PRIMARY KEY,
	Type VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Preference
(
	Id INT IDENTITY NOT NULL PRIMARY KEY,
	Name VARCHAR(45) NOT NULL UNIQUE
);

CREATE TABLE Customer
(
	Id INT IDENTITY PRIMARY KEY,
	Name VARCHAR(45) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	Address VARCHAR(45) NOT NULL,
	City VARCHAR(20) NOT NULL,
	[State] VARCHAR(45) NOT NULL,
	Country VARCHAR(45) NOT NULL
);

CREATE TABLE PaymentMethod
(
	Id INT IDENTITY PRIMARY KEY,
	AccountNumber VARCHAR(255) NOT NULL,
	CustomerId INT NOT NULL,
	PaymentTypeId INT NOT NULL,
	IsPreferred BIT NOT NULL DEFAULT '0',
	FOREIGN KEY (CustomerId) REFERENCES Customer (Id),
	FOREIGN KEY (PaymentTypeId) REFERENCES PaymentType (Id)
);

CREATE TABLE FrequentFlyer
(
	FrequentFlyerNumber INT IDENTITY PRIMARY KEY,
	CustomerId INTEGER NOT NULL
	FOREIGN KEY (CustomerId) REFERENCES Customer (Id)
);

CREATE TABLE Flight
(
	FlightNumber VARCHAR(45) PRIMARY KEY,
	DepartureAirportCode VARCHAR(5) NOT NULL,
	ArrivalAirportCode VARCHAR (5) NOT NULL,
	AirplaneId INT NOT NULL,
	CarrierName VARCHAR (45) NOT NULL,
	[Date] DATE NOT NULL,
	EconomyFare DECIMAL (10, 2) NOT NULL,
	BusinessFare DECIMAL (10, 2) NOT NULL,
	DepartureTime TIME NOT NULL,
	ArrivalTime TIME NOT NULL,
	FOREIGN KEY (DepartureAirportCode) REFERENCES Airport(InternationalCode),
	FOREIGN KEY (ArrivalAirportCode) REFERENCES Airport(InternationalCode),
	FOREIGN KEY (AirplaneId) REFERENCES Airplane(AirplaneId),
	FOREIGN KEY (CarrierName) REFERENCES Carrier(Name)
);

CREATE TABLE Reservation
(
	Id INT IDENTITY NOT NULL PRIMARY KEY,
	CustomerId INT NOT NULL,
	AgentId INT NOT NULL,
	ReservationStatusId INT NOT NULL,
	FrequentFlyerNumber INT NULL,
	PaymentMethodId INT NOT NULL,
	FOREIGN KEY (CustomerId) REFERENCES Customer (Id),
	FOREIGN KEY (AgentId) REFERENCES Agent (Id),
	FOREIGN KEY (ReservationStatusId) REFERENCES ReservationStatus(Id),
	FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethod(Id)
);

CREATE TABLE ReservationPreference
(
	Id INT IDENTITY NOT NULL PRIMARY KEY,
	PreferenceId INT NOT NULL,
	ReservationId INT NOT NULL,
	Value VARCHAR(45) NOT NULL
	FOREIGN KEY (PreferenceId) REFERENCES Preference (Id),
	FOREIGN KEY (ReservationId) REFERENCES Reservation(Id)
);

CREATE TABLE Flight_Reservation
(
	ReservationId INT NOT NULL,
	FlightNumber VARCHAR(45) NOT NULL,
	ReservationStatusId INT NOT NULL,
	FOREIGN KEY (ReservationId) REFERENCES Reservation (Id),
	FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber),
	FOREIGN KEY (ReservationStatusId) REFERENCES ReservationStatus(Id)
);