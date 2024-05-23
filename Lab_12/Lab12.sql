CREATE TABLE Agency (
                           agency_id INT PRIMARY KEY,
                           agency_name NVARCHAR(100)
);

CREATE TABLE Apartment (
                         apartment_id INT PRIMARY KEY,
                         address NVARCHAR(100),
                         days INT,
                         price DECIMAL(10, 2),
                         agency_id INT FOREIGN KEY REFERENCES Agency(agency_id)
);

CREATE TABLE Customer (
                          customer_id INT PRIMARY KEY,
                          customer_name NVARCHAR(100)
);
create table Report (
                        id INTEGER primary key identity(1,1),
                        xml_column XML
);
CREATE TABLE Report (
    id INT IDENTITY PRIMARY KEY,
    ReportXML XML
);

INSERT INTO Agency (agency_id, agency_name) VALUES (1, 'Agency1');
INSERT INTO Agency (agency_id, agency_name) VALUES (2, 'Agency2');
INSERT INTO Apartment (apartment_id, address, days, price, agency_id) VALUES (1, 'Address1', 2, 35.12, 1);
INSERT INTO Apartment (apartment_id, address, days, price, agency_id) VALUES (2, 'Address2', 2, 35.12, 1);
INSERT INTO Apartment (apartment_id, address, days, price, agency_id) VALUES (3, 'Address2', 2, 35.12, 2);
INSERT INTO Customer (customer_id, customer_name) VALUES (1, 'Customer1');

CREATE PROCEDURE GenerateReportXML
    @ReportXML XML OUTPUT
AS
BEGIN
    DECLARE @Timestamp NVARCHAR(50) = CONVERT(NVARCHAR, GETDATE(), 126);

    WITH ApartmentData AS (
        SELECT
            A.apartment_id,
            A.address,
            A.days,
            A.price,
            Ag.agency_id,
            Ag.agency_name
        FROM
            Apartment A
        INNER JOIN
            Agency Ag ON A.agency_id = Ag.agency_id
    )
    SELECT
        @ReportXML = (
            SELECT
                Ag.agency_id AS '@AgencyID',
                Ag.agency_name AS 'AgencyName',
                (
                    SELECT
                        A.apartment_id AS 'ApartmentID',
                        A.address AS 'Address',
                        A.days AS 'Days',
                        A.price AS 'Price'
                    FROM ApartmentData A
                    WHERE A.agency_id = Ag.agency_id
                    FOR XML PATH('Apartment'), TYPE
                )
            FROM
                Agency Ag
            FOR XML PATH('Agency'), ROOT('Agencies')
        );

    -- Добавление временной метки
    SET @ReportXML.modify('
        insert element Timestamp {sql:variable("@Timestamp")}
        as last into (/Agencies)[1]
    ');
END;

DECLARE @GeneratedXML XML;

-- Вызов процедуры для генерации XML
EXEC GenerateReportXML @ReportXML = @GeneratedXML OUTPUT;

-- Вывод сгенерированного XML
SELECT @GeneratedXML AS GeneratedXML;

CREATE PROCEDURE InsertReportXML
AS
BEGIN
    DECLARE @ReportXML XML;

    EXEC GenerateReportXML @ReportXML OUTPUT;

    INSERT INTO Report (ReportXML)
    VALUES (@ReportXML);
END;

EXEC InsertReportXML;


DECLARE @GeneratedXML XML;
EXEC InsertReportXML @GeneratedXML;
SELECT * FROM Report;


select * from Report;
exec InsertInReport;

CREATE PRIMARY XML INDEX PXML_ReportXML_Index ON Report (ReportXML);



    SELECT
        xml_column.value('(/AgencyReport/Agency/@id)[1]', 'INT') AS AgencyID,
        xml_column.value('(/AgencyReport/Agency/AgencyName)[1]', 'VARCHAR(100)') AS AgencyName,
        xml_column.value('(/AgencyReport/Agency/TotalDays)[1]', 'INT') AS TotalDays,
        xml_column.value('(/AgencyReport/Agency/MaxPrice)[1]', 'DECIMAL(10,2)') AS MaxPrice,
        xml_column.value('(/AgencyReport/Agency/Timestamp)[1]', 'DATETIME') AS Timestamp
    FROM
        Report
    WHERE
        xml_column.exist('/AgencyReport/Agency/@id') = 1;

CREATE PROCEDURE ExtractFromReportXML
    @XPath NVARCHAR(MAX)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = N'
        SELECT
            T.C.value(''.'', ''NVARCHAR(MAX)'') AS ExtractedValue
        FROM
            Report
        CROSS APPLY
            Report.ReportXML.nodes(''' + @XPath + ''') AS T(C)
    ';

    EXEC sp_executesql @SQL;
END;

EXEC ExtractFromReportXML N'/Agencies/Agency[@AgencyID="2"]/AgencyName';