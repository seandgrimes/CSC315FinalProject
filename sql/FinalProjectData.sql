-- Create the Travel Agents
INSERT INTO Agent (FirstName, LastName) VALUES ('Joe', 'Camel');
INSERT INTO Agent (FirstName, LastName) VALUES ('Sean', 'Grimes');
INSERT INTO Agent (FirstName, LastName) VALUES ('Caroline', 'Gingles');

-- Create the reservation statuses
INSERT INTO ReservationStatus (Name) VALUES ('OK');
INSERT INTO ReservationStatus (Name) VALUES ('WAITING');

-- Create the airports
INSERT INTO Airport(InternationalCode, Name, City, Country, PhoneNumber)
	VALUES ('KABI', 'Abilene Regional Airport', 'Abilene, TX', 'United States', '318-222-2222')

INSERT INTO Airport(InternationalCode, Name, City, Country, PhoneNumber)
	VALUES ('KDAL', 'Dallas Love Field', 'Dalls, TX', 'United States', '318-222-2222');

INSERT INTO Airport(InternationalCode, Name, City, Country, PhoneNumber)
	VALUES ('KDFW', 'Dallas-Fort Worth International Airport', 'Fort Worth, TX', 'United States', '318-222-2222');

INSERT INTO Airport(InternationalCode, Name, City, Country, PhoneNumber)
	VALUES ('KDEN', 'Denver International Airport', 'Denver, CO', 'United States', '318-222-2222');

INSERT INTO Airport(InternationalCode, Name, City, Country, PhoneNumber)
	VALUES ('KPHX', 'Phoenix Sky Harbor International Airport', 'Phoenix, AZ', 'United States', '318-222-2222');

INSERT INTO Airport(InternationalCode, Name, City, Country, PhoneNumber)
	VALUES ('KATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta, GA', 'United States', '318-222-2222');

INSERT INTO Airport(InternationalCode, Name, City, Country, PhoneNumber)
	VALUES ('KBFI', 'Boeing Field/King County International Airport', 'Seattle, WA', 'United States', '318-222-2222');

INSERT INTO Airport(InternationalCode, Name, City, Country, PhoneNumber)
	VALUES ('KBNA', 'Nashville International Airport', 'Nashville, TN', 'United States', '318-222-2222');

INSERT INTO Airport(InternationalCode, Name, City, Country, PhoneNumber)
	VALUES ('KBOS', 'Logan International Airport', 'Boston, MA', 'United States', '318-222-2222');
	
INSERT INTO Airport(InternationalCode, Name, City, Country, PhoneNumber)
	VALUES ('KLAX', 'Los Angeles International Airport', 'Los Angeles, CA', 'United States', '318-222-2222');

-- Create Carriers
INSERT INTO Carrier (Name, Address, City, State, Country, PhoneNumber) VALUES ('American Airlines', '123 Test Lane',
	'Dallas', 'TX', 'United States', '469-569-8253');
	
INSERT INTO Carrier (Name, Address, City, State, Country, PhoneNumber) VALUES ('Delta Airlines', '123 Test Lane',
	'Dallas', 'TX', 'United States', '469-569-8253');
	
INSERT INTO Carrier (Name, Address, City, State, Country, PhoneNumber) VALUES ('Southwest Airlines', '123 Test Lane',
	'Dallas', 'TX', 'United States', '469-569-8253');
	
-- Create Payment Types
INSERT INTO PaymentType (Type) VALUES ('Credit Card');
INSERT INTO PaymentType (Type) VALUES ('Check');

-- Create Preferences
INSERT INTO Preference (Name) VALUES ('Window Seat');
INSERT INTO Preference (Name) VALUES ('Meal');
INSERT INTO Preference (Name) VALUES ('Aisle Seat');

-- Create the Airplanes
INSERT INTO Airplane([Identity], Type, BusinessCapacity, EconomyCapacity) VALUES ('Boeing', 'Jet', 50, 200);
INSERT INTO Airplane([Identity], Type, BusinessCapacity, EconomyCapacity) VALUES ('Airbus', 'Jet', 75, 225);
INSERT INTO Airplane([Identity], Type, BusinessCapacity, EconomyCapacity) VALUES ('Embrair', 'Turboprop', 10, 75);

DECLARE @American VARCHAR(45);
DECLARE @Delta VARCHAR(45);
DECLARE @Southwest VARCHAR(45);
DECLARE @Boeing INT;
DECLARE @Airbus INT;

SELECT @American = Name FROM Carrier WHERE Name LIKE 'American%';
SELECT @Delta = Name FROM Carrier WHERE Name LIKE 'Delta%';
SELECT @Southwest = Name FROM Carrier WHERE Name LIKE 'Southwest%';
SELECT @Boeing = AirplaneId FROM Airplane WHERE [Identity] = 'Boeing';
SELECT @Airbus = AirplaneId FROM Airplane WHERE [Identity] = 'Airbus';

INSERT INTO Flight (FlightNumber, DepartureAirportCode, ArrivalAirportCode, AirplaneId, CarrierName,
	Date, EconomyFare, BusinessFare, DepartureTime, ArrivalTime) VALUES ('SW-12345', 'KDFW', 'KLAX', @Airbus, @Southwest,
	'12/31/2006', 299, 1200, '12:00PM' ,'3:00PM');
	
INSERT INTO Flight (FlightNumber, DepartureAirportCode, ArrivalAirportCode, AirplaneId, CarrierName,
	Date, EconomyFare, BusinessFare, DepartureTime, ArrivalTime) VALUES ('AA-12345', 'KDFW', 'KLAX', @Boeing, @American,
	'12/31/2006', 325, 1200, '8:00AM' ,'11:00AM');

INSERT INTO Flight (FlightNumber, DepartureAirportCode, ArrivalAirportCode, AirplaneId, CarrierName,
	Date, EconomyFare, BusinessFare, DepartureTime, ArrivalTime) VALUES ('DA-12345', 'KDFW', 'KLAX', @Boeing, @Delta,
	'12/31/2006', 600, 1500, '3:00PM' ,'6:00PM');
	
INSERT INTO Flight (FlightNumber, DepartureAirportCode, ArrivalAirportCode, AirplaneId, CarrierName,
	Date, EconomyFare, BusinessFare, DepartureTime, ArrivalTime) VALUES ('DA-23456', 'KDFW', 'KLAX', @Boeing, @Delta,
	'12/31/2006', 900, 1700, '7:00PM' ,'10:00PM');

-- Create Customer
INSERT INTO Customer (Name, PhoneNumber, City, State, Country, Address) VALUES ('Sean Grimes', '318-222-2222', 'Shreveport',
	'LA', 'United States', '123 Test Lane');
	
DECLARE @CustomerID INT;
SET @CustomerID = SCOPE_IDENTITY();

-- Create Payment Method
INSERT INTO PaymentMethod (AccountNumber, CustomerId, PaymentTypeId, IsPreferred)
	VALUES ('12345', @CustomerID, 1, '1');

DECLARE @PaymentMethodID INT;
SET @PaymentMethodID = SCOPE_IDENTITY();

-- Create Reservations
DECLARE @StatusID INT;
SELECT @StatusID = Id FROM ReservationStatus WHERE Name = 'OK';

DECLARE @AgentID INT;
SELECT @AgentID = Id FROM Agent WHERE FirstName = 'Sean' AND LastName = 'Grimes';

DECLARE @ReservationId INT;
DECLARE @ReservationCounter INT;
SET @ReservationCounter = 0;

WHILE @ReservationCounter < 100 
BEGIN
	SET @ReservationCounter = @ReservationCounter + 1;
	
	INSERT INTO Reservation (CustomerId, AgentId, ReservationStatusId, PaymentMethodId) 
	VALUES (@CustomerID, @AgentID, @StatusID, @PaymentMethodID);

	SET @ReservationId = SCOPE_IDENTITY();
	
	INSERT INTO Flight_Reservation (ReservationId, FlightNumber, ReservationStatusId) 
		VALUES (@ReservationId, 'SW-12345', @StatusID);
END;