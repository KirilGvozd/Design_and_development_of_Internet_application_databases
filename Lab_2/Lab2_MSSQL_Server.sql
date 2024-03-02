CREATE TABLE Apartments (
    apartment_id int primary key identity,
    day_cost money not null,
    room_number int not null,
    house_number nvarchar(10) not null,
    street nvarchar(50) not null,
    city nvarchar(30) not null,
    number_of_rooms int not null,
    description nvarchar(max)
);

CREATE TABLE Rents (
    rent_id int primary key identity,
    apartment_id int references Apartments(apartment_id),
    status nvarchar(10) not null,
    data_begin date not null,
    end_date date not null,
    client_id int references Clients(client_id)
);

CREATE TABLE Clients (
    client_id int primary key,
    surname nvarchar(20) not null,
    name nvarchar(20) not null,
    passport_number nvarchar(15) not null,
    phone_number int not null
);

CREATE TABLE Bill_details (
    bill_id int primary key,
    rent_id int references Rents(rent_id),
    bill_date date not null,
    total money not null
);

CREATE INDEX idx_apartments_city_street ON Apartments(city, street);
CREATE INDEX idx_rents_apartment_id ON Rents(apartment_id);
CREATE INDEX idx_rents_client_id ON Rents(client_id);
CREATE INDEX idx_bill_details_rent_id ON Bill_details(rent_id);

-- Functions
CREATE FUNCTION CalculateTotalCost (@day_cost money, @num_days int)
RETURNS money
AS
BEGIN
    DECLARE @total_cost money
    SET @total_cost = @day_cost * @num_days
    RETURN @total_cost
END;

CREATE FUNCTION GetClientRentHistory (@client_id int)
RETURNS TABLE
AS
RETURN (
    SELECT R.rent_id, R.data_begin, R.end_date, R.status,
           A.apartment_id, A.street, A.city,
           A.number_of_rooms, A.day_cost
    FROM Rents R
    JOIN Apartments A ON R.apartment_id = A.apartment_id
    WHERE R.client_id = @client_id
);

CREATE FUNCTION GetTotalNumberOfApartmentsInCity (@city nvarchar(30))
RETURNS int
AS
BEGIN
    DECLARE @total_apartments int
    SELECT @total_apartments = COUNT(apartment_id)
    FROM Apartments
    WHERE city = @city
    RETURN @total_apartments
END;

-- Procedures
CREATE PROCEDURE InsertNewClient
    @surname nvarchar(20),
    @name nvarchar(20),
    @passport_number nvarchar(15),
    @phone_number int
AS
BEGIN
    INSERT INTO Clients (surname, name, passport_number, phone_number)
    VALUES (@surname, @name, @passport_number, @phone_number)
END;

CREATE PROCEDURE CloseRent
    @rent_id int
AS
BEGIN
    UPDATE Rents
    SET status = 'Closed'
    WHERE rent_id = @rent_id
END;

CREATE PROCEDURE UpdateApartmentDescription
    @apartment_id int,
    @description nvarchar(max)
AS
BEGIN
    UPDATE Apartments
    SET description = @description
    WHERE apartment_id = @apartment_id
END;

-- Views
CREATE VIEW ActiveRentsView AS
SELECT R.rent_id, R.data_begin, R.end_date, R.status,
       A.apartment_id, A.street, A.city,
       C.client_id, C.surname, C.name
FROM Rents R
JOIN Apartments A ON R.apartment_id = A.apartment_id
JOIN Clients C ON R.client_id = C.client_id
WHERE R.status = 'Active'

CREATE VIEW AvailableApartmentsView AS
SELECT A.apartment_id, A.room_number, A.house_number, A.street, A.city, A.number_of_rooms, A.description
FROM Apartments A
LEFT JOIN Rents R ON A.apartment_id = R.apartment_id
WHERE R.rent_id IS NULL

CREATE VIEW dbo.OverdueRentsView AS
SELECT R.rent_id, R.data_begin, R.end_date, R.status,
       C.client_id, C.surname, C.name, C.passport_number, C.phone_number
FROM Rents R
JOIN Clients C ON R.client_id = C.client_id
WHERE R.end_date < GETDATE() AND R.status = 'Active'