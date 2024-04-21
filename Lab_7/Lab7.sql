-- Task 1
WITH BaseData AS (
    SELECT
        R.client_id,
        EXTRACT(MONTH FROM data_begin) AS rental_month,
        EXTRACT(YEAR FROM data_begin) AS rental_year,
        A.day_cost
    FROM
        Rents R
    JOIN
        Apartments A ON R.apartment_id = A.apartment_id
),
LastYearData AS (
    SELECT
        client_id,
        rental_month,
        AVG(day_cost) AS avg_day_cost_last_year
    FROM
        BaseData
    WHERE
        rental_year = EXTRACT(YEAR FROM CURRENT_DATE) - 1
    GROUP BY
        client_id,
        rental_month
),
ProjectedData AS (
    SELECT
        bd.client_id,
        bd.rental_month,
        (lad.avg_day_cost_last_year * 1.1) AS projected_day_cost
    FROM
        BaseData bd
    JOIN
        LastYearData lad ON bd.client_id = lad.client_id AND bd.rental_month = lad.rental_month
)
SELECT
    client_id,
    rental_month,
    projected_day_cost
FROM
    ProjectedData
ORDER BY
    client_id,
    rental_month;


INSERT INTO RENTS (APARTMENT_ID, STATUS, DATA_BEGIN, END_DATE, CLIENT_ID) VALUES (2, 'Active', DATE '2023-04-01', DATE '2023-04-15', 2);
INSERT INTO RENTS (APARTMENT_ID, STATUS, DATA_BEGIN, END_DATE, CLIENT_ID) VALUES (3, 'active', DATE '2023-05-10', DATE '2023-05-20', 3);
SELECT * FROM RENTS;
INSERT INTO BILL_DETAILS (RENT_ID, BILL_DATE, TOTAL) VALUES (33, DATE '2023-04-15', 1500);
INSERT INTO BILL_DETAILS (RENT_ID, BILL_DATE, TOTAL) VALUES (34, DATE '2023-05-20', 1200);

-- Task 2
SELECT *
FROM RENTS
MATCH_RECOGNIZE (
  PARTITION BY APARTMENT_ID
  ORDER BY DATA_BEGIN
  MEASURES
    FIRST(DAY_COST) AS начальный_балл,
    LAST(DAY_COST) AS предыдущий_балл,
    DAY_COST AS текущий_балл,
    CLASSIFIER() AS pattern_match
  ONE ROW PER MATCH
  AFTER MATCH SKIP TO NEXT ROW
  PATTERN (Старт Рост* Падение* Рост*)
  DEFINE
    Старт AS DAY_COST IS NOT NULL,
    Рост AS DAY_COST > PREV(DAY_COST),
    Падение AS DAY_COST < PREV(DAY_COST)
);

SELECT * FROM APARTMENTS;
SELECT * FROM RENTS;