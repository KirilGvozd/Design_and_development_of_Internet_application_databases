-- Task 5
ALTER TABLE APARTMENTS ADD PreviousLevelID NUMBER REFERENCES APARTMENTS(APARTMENT_ID);

INSERT INTO APARTMENTS (DAY_COST, ROOM_NUMBER, HOUSE_NUMBER, STREET, CITY, NUMBER_OF_ROOMS, DESCRIPTION, PREVIOUSLEVELID)
VALUES (12, 423, '12', 'Minskaya', 'Minsk', 2, 'Двухкомнатная квартира', 1);

INSERT INTO APARTMENTS (DAY_COST, ROOM_NUMBER, HOUSE_NUMBER, STREET, CITY, NUMBER_OF_ROOMS, DESCRIPTION, PREVIOUSLEVELID)
VALUES (10, 421, '12', 'Minskaya', 'Minsk', 2, 'Двухкомнатная квартира', 1);

CREATE OR REPLACE TYPE apartment_type AS OBJECT (
    apartment_id int,
    day_cost float(2),
    room_number int,
    house_number nvarchar2(10),
    street nvarchar2(50),
    city nvarchar2(30),
    number_of_rooms int,
    description nvarchar2(255),
    PreviousLevelID NUMBER,
    node_level int
);

CREATE TYPE apartment_type_table AS TABLE OF apartment_type;

-- Task 6
CREATE OR REPLACE FUNCTION ShowChildNodes (a_id IN INT)
RETURN apartment_type_table PIPELINED IS
BEGIN
    FOR rec IN (
        SELECT
            APARTMENT_ID,
            DAY_COST,
            ROOM_NUMBER,
            HOUSE_NUMBER,
            STREET,
            CITY,
            NUMBER_OF_ROOMS,
            DESCRIPTION,
            PreviousLevelID,
            LEVEL as node_level
        FROM
            APARTMENTS
        START WITH APARTMENT_ID = a_id
        CONNECT BY NOCYCLE PRIOR APARTMENT_ID = PreviousLevelID
    ) LOOP
        PIPE ROW(apartment_type(rec.APARTMENT_ID, rec.DAY_COST, rec.ROOM_NUMBER, rec.HOUSE_NUMBER, rec.STREET, rec.CITY, rec.NUMBER_OF_ROOMS, rec.DESCRIPTION, rec.PreviousLevelID, rec.node_level));
    END LOOP;
    RETURN;
END;

ALTER FUNCTION SHOWCHILDNODES COMPILE;

SELECT * FROM TABLE ( SHOWCHILDNODES(3) );

CREATE OR REPLACE PROCEDURE AddChildNode (
    p_day_cost FLOAT,
    p_room_number INT,
    p_house_number NVARCHAR2,
    p_street NVARCHAR2,
    p_city NVARCHAR2,
    p_number_of_rooms INT,
    p_description NVARCHAR2,
    p_PreviousLevelID IN NUMBER
) IS
BEGIN
    INSERT INTO APARTMENTS (DAY_COST, ROOM_NUMBER, HOUSE_NUMBER, STREET, CITY, NUMBER_OF_ROOMS, DESCRIPTION, PREVIOUSLEVELID)
    VALUES (p_day_cost, p_room_number, p_house_number, p_street, p_city, p_number_of_rooms, p_description, p_PreviousLevelID);
END;

ALTER PROCEDURE ADDCHILDNODE COMPILE;

CALL AddChildNode(12, 23, '12B', 'Bobruyskaya', 'Minsk', 1, 'Однокомнатная квартира', 2);

SELECT * FROM APARTMENTS;

CREATE OR REPLACE PROCEDURE MoveNodes (
    p_old_parent_node IN NUMBER,
    p_new_parent_node IN NUMBER
) IS
BEGIN
    UPDATE APARTMENTS
    SET PreviousLevelID = p_new_parent_node
    WHERE PreviousLevelID = p_old_parent_node;
END;

CALL MoveNodes(2, 1);

SELECT * FROM APARTMENTS;