    DECLARE
    TYPE ApartmentCollection IS TABLE OF APARTMENTTYPE;
        TYPE OrderCollection IS TABLE OF OrderType;

        apartments ApartmentCollection;
        orders OrderCollection;
    BEGIN
    SELECT VALUE(p) BULK COLLECT INTO apartments
    FROM OBJECTAPARTMENTS p;

    FOR i IN 1..apartments.COUNT LOOP
    SELECT VALUE(o) BULK COLLECT INTO orders
    FROM ObjectOrders o
    WHERE o.CustomerID = apartments(i).APARTMENTID;

    DBMS_OUTPUT.PUT_LINE('Apartment: ' || apartments(i).ADDRESS);
    FOR j IN 1..orders.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE('ApartmentID: ' || orders(j).OrderID || ', OrderDate: ' || orders(j).OrderDate);
    END LOOP;
    END LOOP;
    SELECT VALUE(p) BULK COLLECT INTO apartments
    FROM OBJECTAPARTMENTS p;
    END;

select * from OBJECTAPARTMENTS;
insert into OBJECTAPARTMENTS values (302, 'new 222', 52.60, 1);


DECLARE
TYPE ApartmentCollection IS TABLE OF APARTMENTTYPE;
    products ApartmentCollection;
    product APARTMENTTYPE := APARTMENTTYPE(APARTMENTID => 241, ADDRESS => 'Product One', PRICE => 100, CATEGORYID => 1);
    isMember BOOLEAN := FALSE;
BEGIN
SELECT VALUE(p) BULK COLLECT INTO products
FROM OBJECTAPARTMENTS p;

FOR i IN 1..products.COUNT LOOP
        IF product.APARTMENTID = products(i).APARTMENTID

        THEN
            isMember := TRUE;
            EXIT;
END IF;
END LOOP;

IF isMember THEN
        DBMS_OUTPUT.PUT_LINE('Apartment ' || product.ADDRESS || ' is a member of the collection.');
ELSE
        DBMS_OUTPUT.PUT_LINE('Apartment ' || product.ADDRESS || ' is not a member of the collection.');
END IF;
END;

DECLARE
TYPE ProductCollection IS TABLE OF APARTMENTTYPE;
    products ProductCollection;
BEGIN
SELECT VALUE(p) BULK COLLECT INTO products
FROM OBJECTAPARTMENTS p;

IF products.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Apartment collection is empty.');
ELSE
        DBMS_OUTPUT.PUT_LINE('Apartment collection is not empty.');
END IF;
END;


CREATE TABLE RelationalApartments (
                                    ApartmentID INT PRIMARY KEY,
                                    Address VARCHAR(100),
                                    Price DECIMAL(10, 2),
                                    CategoryID INT
);

drop table RelationalApartments;



select * from RelationalApartments;

DECLARE
TYPE ApartmentCollection IS TABLE OF APARTMENTTYPE;
    apartments ApartmentCollection;
BEGIN

    apartments := ApartmentCollection();

SELECT APARTMENTTYPE(APARTMENTID => APARTMENTID, ADDRESS => ADDRESS, PRICE => Price, CATEGORYID => CategoryID) BULK COLLECT INTO apartments
FROM OBJECTAPARTMENTS;

IF apartments.COUNT > 0 THEN
        FORALL i IN apartments.FIRST..apartments.LAST
            INSERT INTO RelationalApartments (ApartmentID, Address, Price, CategoryID)
            VALUES (apartments(i).APARTMENTID, apartments(i).ADDRESS, apartments(i).Price, apartments(i).CategoryID);
END IF;

COMMIT;
END;