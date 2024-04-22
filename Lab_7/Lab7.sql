-- Task 1
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (1, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 90);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (1, TO_DATE('2023-02-10', 'YYYY-MM-DD'), 95);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (1, TO_DATE('2024-01-20', 'YYYY-MM-DD'), 80);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (1, TO_DATE('2024-02-05', 'YYYY-MM-DD'), 85);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (2, TO_DATE('2023-01-10', 'YYYY-MM-DD'), 85);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (2, TO_DATE('2023-02-05', 'YYYY-MM-DD'), 90);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (2, TO_DATE('2024-01-25', 'YYYY-MM-DD'), 75);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (2, TO_DATE('2024-02-15', 'YYYY-MM-DD'), 80);
COMMIT;
TRUNCATE TABLE RENTALS;

SELECT *
FROM (
  SELECT CLIENT_ID,
         TRUNC(rental_date, 'MM') AS Month,
         AVG(rental_cost) AS Rental_cost
  FROM RENTALS
  GROUP BY client_id, TRUNC(rental_date, 'MM')
)
MODEL
  PARTITION BY (client_id)
  DIMENSION BY (ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY Month) AS row_number)
  MEASURES (Rental_cost, Month)
  RULES (
    Rental_cost[row_number > 1] = CASE
                                WHEN Month[CV() - 1] < ADD_MONTHS(TRUNC(SYSDATE,'YEAR'), -1) THEN LEAST(100, Rental_cost[CV() - 1] * 1.1)
                                ELSE Rental_cost[CV() - 1]
                             END
  )
ORDER BY client_id, Month;

-- Task 2
SELECT *
FROM Rentals
MATCH_RECOGNIZE (
  PARTITION BY client_id
  ORDER BY rental_date
  MEASURES
    START_ROW.rental_date AS start_date,
    END_ROW.rental_date AS end_date,
    START_ROW.rental_cost AS start_cost,
    BOTTOM_ROW.rental_cost AS max_cost,
    END_ROW.rental_cost AS end_cost
  PATTERN (START_ROW UP BOTTOM_ROW DOWN END_ROW)
  DEFINE
    UP AS UP.rental_cost > PREV(UP.rental_cost),
    DOWN AS DOWN.rental_cost < PREV(DOWN.rental_cost)
) MR
ORDER BY client_id, start_date;

-- Вставка данных для демонстрации работы запроса
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (1, TO_DATE('2023-01-01', 'YYYY-MM-DD'), 100.00);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (1, TO_DATE('2023-02-01', 'YYYY-MM-DD'), 110.00);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (1, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 90.00);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (1, TO_DATE('2023-04-01', 'YYYY-MM-DD'), 120.00);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (1, TO_DATE('2023-05-01', 'YYYY-MM-DD'), 130.00);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (1, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 110.00);

INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (2, TO_DATE('2023-01-01', 'YYYY-MM-DD'), 90.00);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (2, TO_DATE('2023-02-01', 'YYYY-MM-DD'), 80.00);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (2, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 100.00);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (2, TO_DATE('2023-04-01', 'YYYY-MM-DD'), 70.00);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (2, TO_DATE('2023-05-01', 'YYYY-MM-DD'), 75.00);
INSERT INTO Rentals (client_id, rental_date, rental_cost) VALUES (2, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 80.00);

COMMIT;
