CREATE TABLE Apartments (
                 apartment_id int generated as identity primary key,
                 day_cost float(2) not null,
                 room_number int not null,
                 house_number nvarchar2(10) not null,
                 street nvarchar2(50) not null,
                 city nvarchar2(30) not null,
                 number_of_rooms int not null,
                 description nvarchar2(255)
             );

CREATE TABLE Clients (
                 client_id int generated as identity primary key,
                 surname nvarchar2(20) not null,
                 name nvarchar2(20) not null,
                 passport_number nvarchar2(15) not null,
                 phone_number int not null
             );

CREATE TABLE Rents (
                 rent_id int generated as identity primary key,
                 apartment_id int references Apartments(apartment_id) not null,
                 status nvarchar2(10) not null,
                 data_begin date not null,
                 end_date date not null,
                 client_id int references Clients(client_id) not null
             );

CREATE TABLE Bill_details (
                 bill_id int generated as identity primary key,
                 rent_id int references Rents(rent_id) not null,
                 bill_date date not null,
                 total float(2) not null
             );

CREATE INDEX idx_apartments_city_street ON Apartments(city, street);
CREATE INDEX idx_rents_apartment_id ON Rents(apartment_id);
CREATE INDEX idx_rents_client_id ON Rents(client_id);
CREATE INDEX idx_bill_details_rent_id ON Bill_details(rent_id);

-- Functions

CREATE OR REPLACE FUNCTION CalculateTotalCost (day_cost FLOAT(2), num_days NUMBER)
RETURN FLOAT(2)
IS
    total_cost NUMBER;
BEGIN
    total_cost := day_cost * num_days;
    RETURN total_cost;
END CalculateTotalCost;

CREATE OR REPLACE FUNCTION GetClientRentHistory (client_id NUMBER)
RETURN SYS_REFCURSOR
IS
    rent_history SYS_REFCURSOR;
BEGIN
    OPEN rent_history FOR
        SELECT R.rent_id, R.data_begin, R.end_date, R.status,
               A.apartment_id, A.street, A.city,
               A.number_of_rooms, A.day_cost
        FROM Rents R
        JOIN Apartments A ON R.apartment_id = A.apartment_id
        WHERE R.client_id = client_id;
    RETURN rent_history;
END GetClientRentHistory;

CREATE OR REPLACE FUNCTION GetTotalNumberOfApartmentsInCity (city VARCHAR2)
RETURN NUMBER
IS
    total_apartments NUMBER;
BEGIN
    SELECT COUNT(apartment_id) INTO total_apartments
    FROM Apartments
    WHERE city = city;

    RETURN total_apartments;
END GetTotalNumberOfApartmentsInCity;

-- Procedures
CREATE OR REPLACE PROCEDURE InsertNewClient(
    surname NVARCHAR2,
    name NVARCHAR2,
    passport_number NVARCHAR2,
    phone_number NUMBER
)
AS
BEGIN
    INSERT INTO Clients (surname, name, passport_number, phone_number)
    VALUES (surname, name, passport_number, phone_number);
    COMMIT;
END InsertNewClient;

CREATE OR REPLACE PROCEDURE CloseRent(
    rent_id NUMBER
)
AS
BEGIN
    UPDATE Rents
    SET status = 'Closed'
    WHERE rent_id = rent_id;
    COMMIT;
END CloseRent;

CREATE OR REPLACE PROCEDURE UpdateApartmentDescription(
    apartment_id NUMBER,
    description CLOB
)
AS
BEGIN
    UPDATE Apartments
    SET description = description
    WHERE apartment_id = apartment_id;
    COMMIT;
END UpdateApartmentDescription;

-- Views
CREATE OR REPLACE VIEW ActiveRentsView AS
SELECT R.rent_id, R.data_begin, R.end_date, R.status,
       A.apartment_id, A.street, A.city,
       C.client_id, C.surname, C.name
FROM Rents R
JOIN Apartments A ON R.apartment_id = A.apartment_id
JOIN Clients C ON R.client_id = C.client_id
WHERE R.status = 'Active';

CREATE OR REPLACE VIEW AvailableApartmentsView AS
SELECT A.apartment_id, A.room_number, A.house_number, A.street, A.city, A.number_of_rooms, A.description
FROM Apartments A
LEFT JOIN Rents R ON A.apartment_id = R.apartment_id
WHERE R.rent_id IS NULL;

CREATE OR REPLACE VIEW OverdueRentsView AS
SELECT R.rent_id, R.data_begin, R.end_date, R.status,
       C.client_id, C.surname, C.name, C.passport_number, C.phone_number
FROM Rents R
JOIN Clients C ON R.client_id = C.client_id
WHERE R.end_date < SYSDATE AND R.status = 'Active';