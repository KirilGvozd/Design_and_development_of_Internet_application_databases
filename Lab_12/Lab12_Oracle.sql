CREATE TABLE Agency (
                           Agency_id NUMBER PRIMARY KEY,
                           Agency_name NVARCHAR2(100)
);

CREATE TABLE Apartment (
                         Apartment_id NUMBER PRIMARY KEY,
                         Address NVARCHAR2(100),
                         days NUMBER,
                         price NUMBER(10, 2),
                         Agency_id NUMBER REFERENCES Agency(Agency_id)
);

CREATE TABLE Customer (
                          Customer_id NUMBER PRIMARY KEY,
                          Customer_name NVARCHAR2(100)
);

CREATE TABLE Report (
                        id NUMBER GENERATED ALWAYS AS IDENTITY,
                        xml_column XMLTYPE
);

INSERT INTO Agency (agency_id, agency_name) VALUES (1, 'Agency1');
INSERT INTO Agency (agency_id, agency_name) VALUES (2, 'Agency2');
INSERT INTO Apartment (apartment_id, address, days, price, agency_id) VALUES (1, 'Address1', 2, 35.12, 1);
INSERT INTO Apartment (apartment_id, address, days, price, agency_id) VALUES (2, 'Address2', 2, 35.12, 1);
INSERT INTO Apartment (apartment_id, address, days, price, agency_id) VALUES (3, 'Address2', 2, 35.12, 2);
INSERT INTO Customer (customer_id, customer_name) VALUES (1, 'Customer1');
commit;

CREATE OR REPLACE PROCEDURE GenerateXML AS
    xmlData XMLTYPE;
BEGIN
    SELECT XMLELEMENT("AgencyReport",
                      XMLAGG(
                              XMLELEMENT("Agency",
                                         XMLATTRIBUTES(Agency.Agency_id AS "id"),
                                         XMLELEMENT("AgencyName", Agency.Agency_name),
                                         (SELECT XMLAGG(
                                                         XMLELEMENT("Apartment",
                                                                    XMLATTRIBUTES(Apartment.Apartment_id AS "id"),
                                                                    XMLELEMENT("Address", Apartment.Address),
                                                                    XMLELEMENT("Days", Apartment.days),
                                                                    XMLELEMENT("Price", Apartment.price)
                                                         )
                                                 )
                                          FROM Apartment
                                          WHERE Apartment.Agency_id = Agency.Agency_id),
                                         (SELECT XMLAGG(
                                                         XMLELEMENT("Customer",
                                                                    XMLATTRIBUTES(Customer.Customer_id AS "id"),
                                                                    XMLELEMENT("CustomerName", Customer.Customer_name)
                                                         )
                                                 )
                                          FROM Customer)
                              )
                      ),
                      SYSTIMESTAMP) INTO xmlData
    FROM Agency;

    INSERT INTO Report (xml_column) VALUES (xmlData);
END GenerateXML;

select* from Report;
begin
    GenerateXML();
end;

CREATE INDEX My_XML_Index ON Report(xml_column) INDEXTYPE IS XDB.XMLINDEX;
SELECT XMLQuery(
               '/AgencyReport/Agency/Apartment/Adress/text()'
               PASSING xml_column
               RETURNING CONTENT
       ) AS ApartmentName,
       XMLQuery(
               '/AgencyReport/Agency/Apartment/Days/text()'
               PASSING xml_column
               RETURNING CONTENT
       ) AS Days,
       XMLQuery(
               '/AgencyReport/Agency/Apartment/Price/text()'
               PASSING xml_column
               RETURNING CONTENT
       ) AS Price
FROM Report;



CREATE OR REPLACE FUNCTION SelectData(XPath IN VARCHAR2) RETURN XMLType
AS
    v_xml XMLType;
BEGIN
    SELECT XMLQuery(XPath PASSING BY VALUE xml_column RETURNING CONTENT)
    INTO v_xml
    FROM Report;
    RETURN v_xml;
END SelectData;
select SelectData('/AgencyReport/Agency/AgencyName') from dual;
commit;

select * from Report;