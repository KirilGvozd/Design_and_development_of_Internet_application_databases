-- Task 2
CREATE OR REPLACE TYPE Apartment AS OBJECT (
    apartment_id NUMBER,
    address VARCHAR2(100),
    rent NUMBER,
    CONSTRUCTOR FUNCTION Apartment(apartment_id NUMBER, address VARCHAR2, rent NUMBER) RETURN SELF AS RESULT,
    MEMBER FUNCTION compare(apartment2 Apartment) RETURN NUMBER,
    MEMBER FUNCTION getRent(id INTEGER) RETURN NUMBER,
    MEMBER PROCEDURE printApartment
);
/

CREATE OR REPLACE TYPE BODY Apartment AS
    CONSTRUCTOR FUNCTION Apartment(apartment_id NUMBER, address VARCHAR2, rent NUMBER) RETURN SELF AS RESULT IS
    BEGIN
        SELF.apartment_id := apartment_id;
        SELF.address := address;
        SELF.rent := rent;
        RETURN;
    END;

    MEMBER FUNCTION compare(apartment2 Apartment) RETURN NUMBER IS
    BEGIN
        IF SELF.rent = apartment2.rent THEN
            RETURN 0;
        ELSIF SELF.rent < apartment2.rent THEN
            RETURN -1;
        ELSE
            RETURN 1;
        END IF;
    END;

    MEMBER FUNCTION getRent(id INTEGER) RETURN NUMBER IS
    BEGIN
        RETURN SELF.rent;
    END;

    MEMBER PROCEDURE printApartment IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Apartment ID: ' || SELF.apartment_id);
        DBMS_OUTPUT.PUT_LINE('Address: ' || SELF.address);
        DBMS_OUTPUT.PUT_LINE('Rent: ' || SELF.rent);
    END;
END;
/

-- Task 3
CREATE TABLE ApartmentTable OF Apartment (
    PRIMARY KEY (apartment_id)
);

INSERT INTO ApartmentTable VALUES (Apartment(1, '123 Main St', 1000));
INSERT INTO ApartmentTable VALUES (Apartment(2, '456 Elm St', 1200));
-- Другие операторы INSERT

-- Task 4
CREATE VIEW ApartmentView AS
SELECT * FROM ApartmentTable;

-- Task 5
CREATE INDEX RentIndex ON ApartmentTable(rent);

-- Индексирование по методу
CREATE INDEX rent_method_index ON ApartmentTable
(CAST(MULTISET(
    SELECT apartment_id
    FROM TABLE(CAST(
        MULTISET(
            SELECT REF(a)
            FROM ApartmentTable a
        ) AS ApartmentList
    ))
    WHERE a.getRent(0) = 100
) AS SYS.ODCINumberList));