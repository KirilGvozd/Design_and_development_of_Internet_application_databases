INSERT INTO Apartments (day_cost, room_number, house_number, street, city, number_of_rooms, description) VALUES (100.00, 1, '123', 'Main Street', 'New York', 1, 'Cozy studio apartment');
INSERT INTO Apartments (day_cost, room_number, house_number, street, city, number_of_rooms, description) VALUES (150.00, 2, '456', 'Broadway', 'Los Angeles', 2, 'Spacious 2-bedroom apartment');
INSERT INTO Apartments (day_cost, room_number, house_number, street, city, number_of_rooms, description) VALUES (200.00, 3, '789', 'Park Avenue', 'Chicago', 3, 'Luxurious 3-bedroom penthouse');
INSERT INTO Clients (surname, name, passport_number, phone_number) VALUES ('Smith', 'John', 'ABC123', '1234567890');
INSERT INTO Clients (surname, name, passport_number, phone_number) VALUES ('Johnson', 'Emily', 'DEF456', '2345678901');
INSERT INTO Clients (surname, name, passport_number, phone_number) VALUES ('Williams', 'Michael', 'GHI789', '3456789012');
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2020-01-01', DATE '2024-12-01', 2);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (3, 'Active', DATE '2020-02-01', DATE '2024-12-01', 3);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (4, 'Active', DATE '2020-03-01', DATE '2024-12-01', 4);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2020-04-01', DATE '2024-12-01', 2);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2020-05-01', DATE '2024-12-01', 2);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2020-06-01', DATE '2024-12-01', 2);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (3, 'Active', DATE '2020-07-01', DATE '2024-12-01', 3);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (3, 'Active', DATE '2020-08-01', DATE '2024-12-01', 3);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (3, 'Active', DATE '2020-09-01', DATE '2024-12-01', 3);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2020-10-01', DATE '2024-12-01', 4);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2020-11-01', DATE '2024-12-01', 4);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2020-12-01', DATE '2024-12-01', 4);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (3, 'Active', DATE '2021-01-01', DATE '2024-12-01', 2);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (3, 'Active', DATE '2021-02-01', DATE '2024-12-01', 2);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (3, 'Active', DATE '2021-03-01', DATE '2024-12-01', 2);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (4, 'Active', DATE '2021-04-01', DATE '2024-12-01', 3);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (4, 'Active', DATE '2021-05-01', DATE '2024-12-01', 3);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (4, 'Active', DATE '2021-06-01', DATE '2024-12-01', 3);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2021-07-01', DATE '2024-12-01', 4);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2021-08-01', DATE '2024-12-01', 4);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2021-09-01', DATE '2024-12-01', 4);

INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2024-01-01', DATE '2024-12-01', 2);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2024-02-01', DATE '2024-12-01', 3);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2024-03-01', DATE '2024-12-01', 4);
INSERT INTO Rents (apartment_id, status, data_begin, end_date, client_id) VALUES (2, 'Active', DATE '2024-04-01', DATE '2024-12-01', 2);

INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (7, DATE '2024-12-01', 3945);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (8, DATE '2024-12-01', 4573);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (9, DATE '2024-12-01', 4963);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (10, DATE '2024-12-01', 1892);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (11, DATE '2024-12-01', 7988);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (12, DATE '2024-12-01', 2634);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (13, DATE '2024-12-01', 2491);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (14, DATE '2024-12-01', 2743);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (15, DATE '2024-12-01', 2548);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (16, DATE '2024-12-01', 8991);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (17, DATE '2024-12-01', 3155);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (18, DATE '2024-12-01', 273);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (19, DATE '2024-12-01', 9062);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (20, DATE '2024-12-01', 712);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (21, DATE '2024-12-01', 6620);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (22, DATE '2024-12-01', 2475);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (23, DATE '2024-12-01', 5510);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (24, DATE '2024-12-01', 7988);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (25, DATE '2024-12-01', 2363);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (26, DATE '2024-12-01', 9909);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (27, DATE '2024-12-01', 7804);

INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (28, DATE '2024-12-01', 5000);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (29, DATE '2024-12-01', 1200);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (30, DATE '2024-12-01', 6000);
INSERT INTO Bill_details (rent_id, bill_date, total) VALUES (31, DATE '2024-12-01', 5000);

COMMIT;

-- First query
WITH MonthlyRentSum AS (
    SELECT
        TO_CHAR(data_begin, 'YYYY-MM') AS month,
        SUM(total) OVER (PARTITION BY TO_CHAR(data_begin, 'YYYY-MM')) AS monthly_sum,
        SUM(total) OVER (PARTITION BY TO_CHAR(data_begin, 'YYYY'), TO_CHAR(data_begin, 'Q')) AS quarterly_sum,
        SUM(total) OVER (PARTITION BY TO_CHAR(data_begin, 'YYYY'), CASE WHEN TO_CHAR(data_begin, 'MM') <= 6 THEN 1 ELSE 2 END) AS half_yearly_sum,
        SUM(total) OVER (PARTITION BY TO_CHAR(data_begin, 'YYYY')) AS yearly_sum
    FROM
        Rents
        JOIN Bill_details ON Rents.rent_id = Bill_details.rent_id
)
SELECT
    month,
    monthly_sum,
    quarterly_sum,
    half_yearly_sum,
    yearly_sum
FROM
    MonthlyRentSum
GROUP BY
    month, monthly_sum, quarterly_sum, half_yearly_sum, yearly_sum
ORDER BY
    month;

-- Second query
WITH MonthlyRentSum AS (
    SELECT
        TO_CHAR(data_begin, 'YYYY-MM') AS month,
        SUM(total) AS monthly_sum,
        (SELECT SUM(total) FROM Bill_details) AS total_sum,
        MAX(SUM(total)) OVER () AS max_monthly_sum
    FROM
        Rents
        JOIN Bill_details ON Rents.rent_id = Bill_details.rent_id
    GROUP BY
        TO_CHAR(data_begin, 'YYYY-MM')
)
SELECT
    month,
    monthly_sum AS rent_volume,
    ROUND(monthly_sum / total_sum * 100, 2) AS percentage_of_total,
    ROUND(monthly_sum / max_monthly_sum * 100, 2) AS percentage_of_max
FROM
    MonthlyRentSum
ORDER BY
    month;

-- Third query
WITH Last6Months AS (
    SELECT
        TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -level), 'YYYY-MM') AS month
    FROM
        dual
    CONNECT BY
        level <= 5
    UNION ALL
    SELECT
        TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYY-MM') AS month
    FROM
        dual
),
ClientRentSum AS (
    SELECT
        c.client_id,
        lm.month,
        NVL(SUM(b.total), 0) AS rent_sum
    FROM
        Clients c
    CROSS JOIN
        Last6Months lm
    LEFT JOIN
        Rents r ON c.client_id = r.client_id
    LEFT JOIN
        Bill_details b ON r.rent_id = b.rent_id AND TO_CHAR(r.data_begin, 'YYYY-MM') = lm.month
    GROUP BY
        c.client_id, lm.month
)
SELECT
    client_id,
    month,
    rent_sum
FROM
    ClientRentSum
ORDER BY
    client_id, month;

-- Fourth query
WITH ApartmentRentCounts AS (
    SELECT
        apartment_id,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rent_rank
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
    rent_rank = 1;