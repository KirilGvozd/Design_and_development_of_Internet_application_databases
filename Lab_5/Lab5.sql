-- Inserting data
INSERT INTO Apartments (day_cost, room_number, house_number, street, city, number_of_rooms, description)
VALUES
    (100.00, 1, '123', 'Main Street', 'New York', 1, 'Cozy studio apartment'),
    (150.00, 2, '456', 'Broadway', 'Los Angeles', 2, 'Spacious 2-bedroom apartment'),
    (200.00, 3, '789', 'Park Avenue', 'Chicago', 3, 'Luxurious 3-bedroom penthouse');

INSERT INTO Clients (client_id, surname, name, passport_number, phone_number)
VALUES
    (1, 'Smith', 'John', 'ABC123', '1234567890'),
    (2, 'Johnson', 'Emily', 'DEF456', '2345678901'),
    (3, 'Williams', 'Michael', 'GHI789', '3456789012');

INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id)
VALUES
    (186, 'Active', '2023-10-01', '2023-10-31', 1),
    (186, 'Active', '2023-11-01', '2023-11-30', 2),
    (187, 'Active', '2023-10-15', '2023-11-15', 1),
    (187, 'Active', '2023-11-16', '2023-12-16', 3),
    (188, 'Active', '2023-11-01', '2023-11-30', 1),
    (188, 'Active', '2023-12-01', '2023-12-31', 2);

INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (186, 'Active', '2021-04-01', '2024-10-10', 3);
SELECT * FROM Rents;

INSERT INTO Bill_details (bill_id, rent_id, bill_date, total)
VALUES
    (1, 7, '2023-10-31', 3100.00),
    (2, 8, '2023-11-30', 4500.00),
    (3, 7, '2023-11-15', 3000.00),
    (4, 9, '2023-12-16', 3200.00),
    (5, 10, '2023-11-30', 6000.00),
    (6, 11, '2023-12-31', 6200.00);

INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (7, 13, '2022-10-10', 2000);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (8, 14, '2023-10-10', 3000);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (9, 15, '2023-10-10', 1500);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (10, 15, '2023-10-10', 3500);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (11, 15, '2023-10-10', 300);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (12, 13, '2023-10-10', 700);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (13, 13, '2023-10-10', 700);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (14, 16, '2024-10-10', 1500);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (15, 17, '2024-10-10', 2300);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (16, 18, '2024-10-10', 1300);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (17, 18, '2024-10-10', 2500);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (18, 19, '2024-10-10', 2500);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (19, 20, '2024-10-10', 1000);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (20, 21, '2024-10-10', 500);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (21, 22, '2024-10-10', 800);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (22, 23, '2024-10-10', 200);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (23, 24, '2024-10-10', 1000);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (24, 25, '2024-10-10', 2000);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (25, 26, '2024-10-10', 3500);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (26, 27, '2024-10-10', 2500);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (27, 28, '2024-10-10', 1500);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (28, 29, '2024-10-10', 1000);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (29, 30, '2024-10-10', 2000);
INSERT INTO Bill_details (bill_id, rent_id, bill_date, total) VALUES (30, 31, '2024-10-10', 2800);


-- Task 1
WITH RentTotals AS (
    SELECT
        YEAR(R.data_begin) AS year,
        MONTH(R.data_begin) AS month,
        ((MONTH(R.data_begin) - 1) / 3 + 1) AS quarter,
        CASE WHEN MONTH(R.data_begin) <= 6 THEN 1 ELSE 2 END AS half_year,
        SUM(B.total) AS monthly_rent_total,
        SUM(B.total) OVER (PARTITION BY YEAR(R.data_begin), ((MONTH(R.data_begin) - 1) / 3 + 1)) AS quarterly_rent_total,
        SUM(B.total) OVER (PARTITION BY YEAR(R.data_begin), CASE WHEN MONTH(R.data_begin) <= 6 THEN 1 ELSE 2 END) AS half_yearly_rent_total,
        SUM(B.total) OVER (PARTITION BY YEAR(R.data_begin)) AS yearly_rent_total
    FROM
        Rents R
    INNER JOIN Bill_details B ON R.rent_id = B.rent_id
    GROUP BY
        YEAR(R.data_begin), MONTH(R.data_begin), B.total
)
SELECT
    'Monthly' AS period_type,
    M.year,
    M.month,
    M.monthly_rent_total,
    'Quarterly' AS period_type,
    Q.year,
    Q.quarter,
    Q.quarterly_rent_total,
    'Half Yearly' AS period_type,
    H.year,
    H.half_year,
    H.half_yearly_rent_total,
    'Yearly' AS period_type,
    Y.year,
    NULL AS period,
    Y.yearly_rent_total
FROM
    (SELECT DISTINCT year, month, monthly_rent_total FROM RentTotals) M
JOIN
    (SELECT DISTINCT year, quarter, quarterly_rent_total FROM RentTotals) Q
    ON M.year = Q.year
JOIN
    (SELECT DISTINCT year, half_year, half_yearly_rent_total FROM RentTotals) H
    ON M.year = H.year
JOIN
    (SELECT DISTINCT year, yearly_rent_total FROM RentTotals) Y
    ON M.year = Y.year;

-- Task 2
WITH ServiceTotals AS (
    SELECT
        YEAR(R.data_begin) AS year,
        MONTH(R.data_begin) AS month,
        SUM(B.total) AS total_service
    FROM
        Rents R
    INNER JOIN Bill_details B ON R.rent_id = B.rent_id
    GROUP BY
        YEAR(R.data_begin), MONTH(R.data_begin)
),
TotalService AS (
    SELECT
        SUM(total_service) AS total
    FROM
        ServiceTotals
),
MaxService AS (
    SELECT
        MAX(total_service) AS max_total
    FROM
        ServiceTotals
)
SELECT
    ST.year,
    ST.month,
    ST.total_service AS service_volume,
    ROUND((ST.total_service / TS.total) * 100, 2) AS percentage_of_total,
    ROUND((ST.total_service / MS.max_total) * 100, 2) AS percentage_of_max
FROM
    ServiceTotals ST
CROSS JOIN
    TotalService TS
CROSS JOIN
    MaxService MS;

-- Subtasks
WITH ServiceTotals AS (
    SELECT
        YEAR(R.data_begin) AS year,
        MONTH(R.data_begin) AS month,
        SUM(B.total) AS total_service,
        ROW_NUMBER() OVER (PARTITION BY YEAR(R.data_begin), MONTH(R.data_begin) ORDER BY SUM(B.total) DESC) AS row_num
    FROM
        Rents R
    INNER JOIN
        Bill_details B ON R.rent_id = B.rent_id
    GROUP BY
        YEAR(R.data_begin), MONTH(R.data_begin)
),
TotalService AS (
    SELECT
        SUM(total_service) AS total
    FROM
        ServiceTotals
),
MaxService AS (
    SELECT
        MAX(total_service) AS max_total
    FROM
        ServiceTotals
)
SELECT
    ST.year,
    ST.month,
    ST.total_service AS service_volume,
    ROUND((ST.total_service / TS.total) * 100, 2) AS percentage_of_total,
    ROUND((ST.total_service / MS.max_total) * 100, 2) AS percentage_of_max
FROM
    ServiceTotals ST
CROSS JOIN
    TotalService TS
CROSS JOIN
    MaxService MS
WHERE
    ST.row_num = 1;


DECLARE @page_number INT = 1;

WITH ServiceTotals AS (
    SELECT
        YEAR(R.data_begin) AS year,
        MONTH(R.data_begin) AS month,
        SUM(B.total) AS total_service,
        ROW_NUMBER() OVER (ORDER BY YEAR(R.data_begin), MONTH(R.data_begin)) AS row_num
    FROM
        Rents R
    INNER JOIN
        Bill_details B ON R.rent_id = B.rent_id
    GROUP BY
        YEAR(R.data_begin), MONTH(R.data_begin)
),
TotalService AS (
    SELECT
        SUM(total_service) AS total
    FROM
        ServiceTotals
),
MaxService AS (
    SELECT
        MAX(total_service) AS max_total
    FROM
        ServiceTotals
)
SELECT
    ST.year,
    ST.month,
    ST.total_service AS service_volume,
    ROUND((ST.total_service / TS.total) * 100, 2) AS percentage_of_total,
    ROUND((ST.total_service / MS.max_total) * 100, 2) AS percentage_of_max
FROM
    ServiceTotals ST
CROSS JOIN
    TotalService TS
CROSS JOIN
    MaxService MS
WHERE
    ST.row_num BETWEEN ((@page_number - 1) * 20 + 1) AND (@page_number * 20);

-- Task 3
WITH Last6Months AS (
    SELECT DISTINCT
        YEAR(data_begin) AS year,
        MONTH(data_begin) AS month
    FROM
        Rents
    WHERE
        data_begin >= DATEADD(MONTH, -5, GETDATE()) -- последние 6 месяцев от текущей даты
),
ClientRentTotals AS (
    SELECT
        C.client_id,
        YEAR(R.data_begin) AS year,
        MONTH(R.data_begin) AS month,
        SUM(B.total) AS monthly_rent_total
    FROM
        Rents R
    INNER JOIN
        Bill_details B ON R.rent_id = B.rent_id
    INNER JOIN
        Clients C ON R.client_id = C.client_id
    WHERE
        EXISTS (
            SELECT 1
            FROM Last6Months L
            WHERE YEAR(R.data_begin) = L.year AND MONTH(R.data_begin) = L.month
        )
    GROUP BY
        C.client_id, YEAR(R.data_begin), MONTH(R.data_begin)
)
SELECT
    CR.client_id,
    CR.year,
    CR.month,
    CR.monthly_rent_total
FROM
    ClientRentTotals CR;

-- Task 4
WITH ApartmentRentCounts AS (
    SELECT
        apartment_id,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS row_num
    FROM
        Rents
    GROUP BY
        apartment_id
)
SELECT
    apartment_id
FROM
    ApartmentRentCounts
WHERE
    row_num = 1;