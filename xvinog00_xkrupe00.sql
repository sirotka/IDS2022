-- IDS project #35

-- Project name: Ticket reservation.

-- Authors:
--          Ekaterina Krupenko (xkrupe00)
--          Alina Vinogradova  (xvinog00)

-- Project part 2 - SQL script for creating basic database schema objects
/*
                Tables:
                    Airlines
                    Aircrafts
                    Airports
                    Customers
                    Reservations
                    Flight_tickets
 */

/*
                 PART ONE:
                 SIMPLE SQL SCRIPT TO CREATE AND FILL TABLES
*/

-- DELETE TABLES

    DROP TABLE FLIGHT_TICKETS;
    DROP TABLE AIRCRAFTS;
    DROP TABLE AIRLINES;
    DROP TABLE AIRPORTS;
    DROP TABLE RESERVATIONS;
    DROP TABLE CUSTOMERS;

    DROP SEQUENCE flight_ticket_id;


    CREATE SEQUENCE flight_ticket_id START WITH 1 INCREMENT BY 1 NOCYCLE;

-- CREATE TABLES


    CREATE TABLE airlines (
        -- id according to IATA standard
        airline_code VARCHAR(3) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(airline_code,'[A-Z0-9]{3}')),
        name VARCHAR(128) NOT NULL,
        nationality VARCHAR(2) NOT NULL
    );

    CREATE TABLE aircrafts (
        aircraft_id NUMBER GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
        type VARCHAR(128) NOT NULL,
        model VARCHAR(128) NOT NULL,
        airline_code VARCHAR(3) NOT NULL,

        CONSTRAINT FK_AIRCRAFT_OWNER_AIRLINE FOREIGN KEY (airline_code) REFERENCES airlines(airline_code)
    );

    CREATE TABLE airports (
        -- airport_codes according to IATA standard
        airport_code VARCHAR(3) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(airport_code,'[A-Z]{3}')),
        name VARCHAR(128) NOT NULL,
        city VARCHAR(128) NOT NULL,
        -- countries according to ISO 3166-1 Alpha-2 code standard
        country VARCHAR(2) NOT NULL CHECK (REGEXP_LIKE(country, '[A-Z]{2}'))
    );

    CREATE TABLE customers (
        id NUMBER GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
        first_name VARCHAR(128) NOT NULL,
        last_name VARCHAR(128) NOT NULL,
        email VARCHAR(128) NOT NULL CHECK(REGEXP_LIKE(email, '^[a-z]+[a-z0-9\.]*@[a-z0-9\.-]+\.[a-z]{2,}$', 'i')),
        street VARCHAR(128) NOT NULL,
        town VARCHAR(128) NOT NULL,
        post_code NUMBER NOT NULL,
        user_country VARCHAR(2) NOT NULL CHECK (REGEXP_LIKE(user_country, '[A-Z]{2}'))
    );

    CREATE TABLE reservations (
        id NUMBER GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
        payment_status NUMBER NOT NULL CHECK(payment_status = 0 or payment_status = 1), -- true or false
        created_at TIMESTAMP NOT NULL,
        owner NUMBER NOT NULL,


        CONSTRAINT FK_RESERVATION_OWNER FOREIGN KEY(owner) REFERENCES customers(id)
    );

    CREATE TABLE flight_tickets (
        id NUMBER NOT NULL PRIMARY KEY,
        flight_code VARCHAR(6) NOT NULL CHECK(REGEXP_LIKE(flight_code, '[0-9a-zA-Z]{2}[0-9]{4}')),
        dep_time TIMESTAMP WITH TIME ZONE NOT NULL,
        arr_time TIMESTAMP WITH TIME ZONE NOT NULL,
        aircraft NUMBER NOT NULL,
        airline VARCHAR(3) NOT NULL,
        price NUMBER NOT NULL,
        dep_loc VARCHAR(3) NOT NULL,
        arr_loc VARCHAR(3) NOT NULL,
        seat_number VARCHAR(3) NOT NULL CHECK(REGEXP_LIKE(seat_number, '[0-9]{2}[A-Z]')),
        passenger NUMBER NOT NULL ,
        reservation_code NUMBER NOT NULL,

        CONSTRAINT FK_TICKET_START_LOC FOREIGN KEY(dep_loc) REFERENCES airports(airport_code),
        CONSTRAINT FK_TICKET_DESTINATION_LOC FOREIGN KEY(arr_loc) REFERENCES airports(airport_code),
        CONSTRAINT FK_TICKET_WITH_AIRCRAFT FOREIGN KEY(aircraft) REFERENCES aircrafts(aircraft_id),
        CONSTRAINT FK_TICKET_OWNER FOREIGN KEY(passenger) REFERENCES customers(id),
        CONSTRAINT FK_TICKET_CREATOR FOREIGN KEY(airline) REFERENCES airlines(airline_code),
        CONSTRAINT FK_TICKET_RESERVATION FOREIGN KEY (reservation_code) REFERENCES reservations(id)
    );

-- TRIGGER

-- First trigger automatically generates
-- ID for flight tickets
-- and uses increment in sequence flight_ticket_id

CREATE OR REPLACE TRIGGER flight_trig
    BEFORE INSERT
    ON flight_tickets
	FOR EACH ROW
    WHEN ( NEW.id IS NULL )
    BEGIN
        SELECT flight_ticket_id.NEXTVAL
        INTO : NEW.id
        FROM dual;
    END;
/

-- The second trigger indicates that the reservation was outdated
-- compare two dates, reservation date and flight date

CREATE OR REPLACE TRIGGER checking_reservations BEFORE
    INSERT OR UPDATE OF reservation_code,dep_time ON flight_tickets
    FOR EACH ROW
DECLARE
    reservation_time TIMESTAMP;
BEGIN
    SELECT created_at INTO reservation_time FROM reservations WHERE reservations.id = :NEW.reservation_code;

    IF ( :NEW.dep_time < reservation_time )
    THEN dbms_output.put_line('Reservation has an outdated ticket.');
    END IF;
END;
/

-- FILL TABLES

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Leonardo', 'Blue', 'leotheleader@gmail.com', 'Bayport Lane', 'New York', 10461, 'US');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Raphael', 'Red', 'raphtherebel@mail.uk', 'Cemetery Dr.', 'Waltham', 02453, 'GB');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Donatello', 'Purple', 'donnythenerd@gmail.com', 'Maintongoon Road', 'Vesper', 3833, 'AU');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Michelangelo', 'Orange', 'mickeythejollier@gmail.com', 'MacLaren Street', 'Ottawa', 00157, 'CA');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Splinter', 'Master', 'splintertherat@gmail.com', 'Hakulintie', 'Turku', 20210, 'FI');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Jean', 'Medeiros', 'maeve.spore1@hotmail.com', 'Gnatty Creek', 'New York', 11530, 'US');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Carlene', 'Bashaw', 'violette.schust@gmail.com', 'Woodland Avenue', 'Metairie', 70001, 'US');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Aceline', 'Baril', 'AcelineBaril@jourrapide.com', 'avenue Jules Ferry', 'Stains', 93240, 'FR');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Lilly', 'Champ', 'LillyChamp@teleworm.us', 'Eshelby Drive', 'Cannonvale', 4802, 'AU');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Johan', 'Makinen', 'JohanMakinen@rhyta.com', 'Kluuvikatu', 'Vantaa', 01520, 'FI');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Katri', 'Somervuori', 'KatriSomervuori@teleworm.us', 'Pohjoisesplanadi', 'Helsinki', 00130, 'FI');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Otakar', 'Sedivy', 'OtakarSedivy@armyspy.com', 'Strojírenská', 'Nove Veseli', 59214, 'CZ');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Zuzana', 'Mikova', 'ZuzanaMikova@armyspy.com', 'Masarykova', 'Zabreh', 78901, 'CZ');


    -- AIRPORTS
    INSERT INTO airports(airport_code, name, city, country)
        VALUES('JFK', 'John F. Kennedy International Airport', 'New York', 'US');

    INSERT INTO airports(airport_code, name, city, country)
        VALUES('LHR', 'London Heathrow Airport', 'London', 'GB');

    INSERT INTO airports(airport_code, name, city, country)
        VALUES('SYD', 'Sydney Airport', 'Sydney', 'AU');

    INSERT INTO airports(airport_code, name, city, country)
        VALUES('YOW', 'Ottawa International Airport', 'Ottawa','CA');

    INSERT INTO airports(airport_code, name, city, country)
        VALUES('TKU', 'Turku Airport', 'Turku', 'FI');

    INSERT INTO airports(airport_code, name, city, country)
        VALUES('CDG', 'Paris Charles de Gaulle Airport', 'Paris', 'FR');

    INSERT INTO airports(airport_code, name, city, country)
        VALUES('IST', 'Istanbul Airport', 'Istanbul', 'TR');

    INSERT INTO airports(airport_code, name, city, country)
        VALUES('PRG', 'Vaclav Havel Airport Prague', 'Prague', 'CZ');

    -- RESERVATIONS
--ispravitt
    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(1, TIMESTAMP'2022-03-21 15:24:33', 1);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(0, TIMESTAMP'2022-03-16 07:13:11', 2);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(1, TIMESTAMP'2022-03-28 03:45:02', 3);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(1, TIMESTAMP'2022-03-20 21:56:22', 4);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(1, TIMESTAMP'2022-03-20 21:56:22', 5);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(0, TIMESTAMP'2022-03-08 23:59:42', 6);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(1, TIMESTAMP'2022-03-02 08:37:03', 7);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(0, TIMESTAMP'2022-03-06 13:48:12', 8);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(1, TIMESTAMP'2022-03-20 21:56:22', 9);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(0, TIMESTAMP'2022-03-14 19:58:26', 10);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(1, TIMESTAMP'2022-03-28 03:45:02', 11);

    -- AIRLINES
    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('FIA', 'FINLAND AIRLINE', 'FI');

    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('USA', 'USA AIRLINE', 'US');

    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('UKA', 'UK AIRLINE', 'UK');

    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('AUA', 'AUSTRALIAN AIRLINE', 'AU');

    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('CAA', 'CANADIAN AIRLINE', 'CA');

    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('FRA', 'FRANCE AIRLINE', 'FR');

    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('TRA', 'TURKEY AIRLINE', 'TR');

    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('CZA', 'CZECH AIRLINE', 'CZ');

    -- AIRCRAFTS
    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '737 MAX', 'UKA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Airbus', 'A3xx', 'USA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Airbus', 'A350', 'CAA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '200LR', 'FRA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Airbus', 'A300', 'AUA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '200LR', 'USA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '737 MAX', 'AUA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Airbus', 'A318', 'FRA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '777', 'TRA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '787', 'CZA');

    -- FLIGHT TICKETS
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('BA2490',
               TIMESTAMP'2022-03-20 09:05:00',
               TIMESTAMP'2022-03-20 10:55:00',
               1,
               'FIA',
               100,
               'TKU',
               'LHR',
               '17A',
               1,
               1);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('RG2700',
               TIMESTAMP'2022-03-21 10:25:00',
               TIMESTAMP'2022-03-21 10:50:00',
               2,
               'USA',
               50,
               'JFK',
               'YOW',
               '09B',
               2,
               2);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('SD1489',
               TIMESTAMP'2022-03-23 15:35:00',
               TIMESTAMP'2022-03-24 11:35:00',
               3,
               'AUA',
               200,
               'SYD',
               'JFK',
               '13C',
               3,
               3);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('EQ1337',
                TIMESTAMP'2022-03-27 19:45:00',
                TIMESTAMP'2022-03-27 17:10:00',
                4,
                'CAA',
                300,
                'YOW',
                'TKU',
                '01A',
                4,
                4);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('UI2030',
                TIMESTAMP'2022-03-29 07:00:00',
                TIMESTAMP'2022-03-30 02:35:00',
                5,
                'UKA',
                375,
                'LHR',
                'YOW',
                '22E',
                5,
                5);

    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('EQ1347',
                TIMESTAMP'2022-03-27 00:45:00',
                TIMESTAMP'2022-03-27 02:10:00',
                6,
                'FRA',
                834,
                'CDG',
                'IST',
                '17D',
                6,
                6);

    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('KC8475',
                TIMESTAMP'2022-03-29 20:00:00',
                TIMESTAMP'2022-03-30 00:12:00',
                7,
                'TRA',
                538,
                'IST',
                'PRG',
                '09C',
                7,
                7);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('EF1537',
                TIMESTAMP'2022-03-19 23:45:00',
                TIMESTAMP'2022-03-20 07:10:00',
                8,
                'CZA',
                566,
                'PRG',
                'LHR',
                '29B',
                8,
                8);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('EG2214',
                TIMESTAMP'2022-03-29 00:00:01',
                TIMESTAMP'2022-03-29 03:35:00',
                9,
                'CZA',
                386,
                'PRG',
                'YOW',
                '01I',
                9,
                9);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('IP2415',
                TIMESTAMP'2022-03-20 01:45:00',
                TIMESTAMP'2022-03-20 07:10:00',
                10,
                'AUA',
                284,
                'SYD',
                'IST',
                '34B',
                10,
                10);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('GF5169',
                TIMESTAMP'2022-03-29 02:00:00',
                TIMESTAMP'2022-03-29 07:35:00',
                1,
                'AUA',
                925,
                'SYD',
                'JFK',
                '11A',
                11,
                11);

/*
                 PART 3:
                 SQL SELECTIONS USING DIFFERENT FUNCTIONS AND METHODS:
                 - 2 queries using a join of two tables
                 - 1 query using a join of three tables
                 - 2 queries with GROUP BY clause and aggregation function
                 - 1 query containing the predicate EXISTS
                 - 1 query with IN predicate with nested SELECT
*/


-- #1: Shows the names of airlines that have registered Boeing aircraft
--     also specifying the particular model.

--     Using NATURAL JOIN, the AIRCRAFT and AIRLINES tables are joined
--     into a common table, from which only those rows where the Boeing
--     aircraft type exists are selected. As a result, only the name of
--     the airline and the specific model of the plane are shown.

SELECT DISTINCT NAME, MODEL FROM AIRCRAFTS NATURAL JOIN AIRLINES WHERE
    type = 'Boeing';

-- #2: Shows the airports and departure times of all Finnish citizens
--     who have a valid ticket.

--     Using the existing key (ID in the CUSTOMERS table and
--     PASSENGER in the FLIGHT_TICKETS table), two tables are connected
--     and only those rows are being selected, that match the condition
--     (USER_COUNTRY = 'FI') that the user must be from Finland.
--     As a result the data about where and at what time passengers
--     from Finland will fly are shown.
SELECT FIRST_NAME, LAST_NAME, DEP_LOC DEPARTURE_LOCATION, TO_CHAR(DEP_TIME, 'YYYY-MM-DD HH24:MI') DEPARTURE_TIME FROM CUSTOMERS C, FLIGHT_TICKETS F WHERE
    C.ID = F.PASSENGER AND USER_COUNTRY = 'FI' ;

-- #3: Shows the user's name and surname and the code
--     of the flight whose reservation was paid by the user

--     The three tables are connected through keys. Only those values
--     of the final joined table are selected that are known to have been paid for
SELECT FLIGHT_CODE, FIRST_NAME, LAST_NAME FROM FLIGHT_TICKETS F, RESERVATIONS R, CUSTOMERS C  WHERE
    F.RESERVATION_CODE = R.ID AND
    R.OWNER = C.ID AND
    R.PAYMENT_STATUS = 1;

-- #4: Shows how many users are registered with each country

--     Using GROUP BY, we specify what we want to aggregate
--     according to the USER_COUNTRY column. ORDER BY determines
--     the sorting of the table by the first column (COUNT)
SELECT COUNT(ID) COUNT, USER_COUNTRY FROM CUSTOMERS GROUP BY USER_COUNTRY ORDER BY COUNT;

-- #5: Shows the total price of all reservations made at one time

--     Use GROUP BY to designate the CREATED_AT variable,
--     which will be used to aggregate the table connected
--     from FLIGHT_TICKETS and RESERVATIONS. Use ORDER BY to sort
--     the table from the RESERVATION_DATE variable, which was
--     previously converted to CHAR from TIMESTAMP CREATED_AT
SELECT TO_CHAR(CREATED_AT, 'YYYY-MM-DD HH24:MI:SS') RESERVATION_DATE, SUM(PRICE) SUM FROM FLIGHT_TICKETS F, RESERVATIONS R WHERE
    F.RESERVATION_CODE = R.ID
    GROUP BY CREATED_AT
    ORDER BY RESERVATION_DATE;

-- #6: Shows all existing users who, according to their place of residence,
--     live in a city that also has an airport

--     EXISTS checks if there is at least one row in the AIRPORTS table
--     with a CITY value equal to the TOWN value from the CUSTOMERS table.
--     If such a row exists, the customer's data from that row goes into SELECT
SELECT FIRST_NAME, LAST_NAME, TOWN FROM CUSTOMERS WHERE EXISTS(
    SELECT * FROM AIRPORTS WHERE TOWN = CITY);

-- #7: Shows the current list of airlines by codes flying to Ottawa

--     IN determines the city in which the plane arrives.
--     The construct can be useful when there may be several different airports in one city
SELECT AIRLINE FROM FLIGHT_TICKETS WHERE
        ARR_LOC IN (SELECT AIRPORT_CODE FROM AIRPORTS WHERE CITY = 'Ottawa');



/*
                 PART 4:
                 SQL SCRIPT FOR CREATING ADVANCED DATABASE SCHEMA OBJECTS:
                 - 2 non-trivial database triggers including their demonstration
                 - 2 non-trivial stored procedures including their demonstration
                   (with at least one: cursor, exception handling and use of a
                   variable with a data type referring to a table row or column type)
                 - EXPLAIN PLAN for listing the execution plan of a database query
                   with a join of at least two tables, an aggregation function and a GROUP BY clause
                 - explicit creation of at least 1 index
                 - definition of access rights to database objects for the other team member
                 - 1 materialized view belonging to the other team member and using the tables defined by the first team member
*/

-- Demonstration of the first trigger
SELECT id FROM flight_tickets;
-- the operation of the second trigger is
-- a message to output after 1 reservation
-- where date is irrelevant

CREATE OR REPLACE PROCEDURE "ticket_avg_cost" AS
    "tickets_count" NUMBER;
    "tickets_sum_cost" NUMBER;
    "avg_ticket_cost" NUMBER(8, 2); -- up to $999.999,99
    BEGIN
        SELECT COUNT(*) INTO "tickets_count" FROM flight_tickets;
        SELECT SUM(price) INTO "tickets_sum_cost" FROM flight_tickets;

        "avg_ticket_cost" := "tickets_sum_cost" / "tickets_count";

        DBMS_OUTPUT.PUT_LINE('Tickets count: '|| "tickets_count"    || chr(13)||chr(10) ||
                                ' Total amount: '|| "tickets_sum_cost" || chr(13)||chr(10) ||
                                ' Average value per ticket: '|| "avg_ticket_cost" || chr(13)||chr(10));

        EXCEPTION WHEN ZERO_DIVIDE THEN BEGIN
            IF "tickets_count" = 0 THEN
                DBMS_OUTPUT.PUT_LINE('No tickets were found');
            END IF;
        END;
    END;

BEGIN "ticket_avg_cost"; END;


CREATE OR REPLACE PROCEDURE "aircrafts_in_airline"("airline_code_arg" IN VARCHAR) AS
    "all_aircrafts" NUMBER;
    "target_aircrafts" NUMBER := 0;
    "airline_id" airlines.airline_code%TYPE;
    "target_airline_id" airlines.airline_code%TYPE;

    CURSOR "cursor_airlines" IS SELECT airline_code FROM AIRCRAFTS;
    BEGIN
        SELECT COUNT(*) INTO "all_aircrafts" FROM AIRCRAFTS;

        SELECT airline_code INTO "target_airline_id" FROM AIRLINES WHERE airline_code = "airline_code_arg";

        OPEN "cursor_airlines";
        LOOP
            FETCH "cursor_airlines" INTO "airline_id";
            EXIT WHEN "cursor_airlines"%NOTFOUND;

            IF "airline_id" = "target_airline_id" THEN
                "target_aircrafts" := "target_aircrafts" + 1;
            END IF;
        END LOOP;
        CLOSE "cursor_airlines";
        DBMS_OUTPUT.PUT_LINE('Airline ' || "airline_code_arg" || ' has ' || "target_aircrafts" || ' aircraft(s) in total.');

        EXCEPTION WHEN NO_DATA_FOUND THEN BEGIN
            DBMS_OUTPUT.PUT_LINE('Airline '|| "airline_code_arg" || ' not found');
        END;
    END;

-- Example outputs for 1. procedure
-- shows the number of planes that are registered with the company with the code specified by the user

BEGIN "aircrafts_in_airline"('USA'); END;
BEGIN "aircrafts_in_airline"('CAA'); END;
BEGIN "aircrafts_in_airline"('FRA'); END;

EXPLAIN PLAN FOR


SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

DROP VIEW customers_from_xkrupe00;
DROP MATERIALIZED VIEW customers_from_xkrupe00_mat;

--DROP MATERIALIZED VIEW customers_from_xkrupe00;

GRANT ALL ON FLIGHT_TICKETS TO XVINOG00;
GRANT ALL ON AIRCRAFTS TO XVINOG00;
GRANT ALL ON AIRLINES TO XVINOG00;
GRANT ALL ON AIRPORTS TO XVINOG00;
GRANT ALL ON RESERVATIONS TO XVINOG00;
GRANT ALL ON CUSTOMERS TO XVINOG00;

GRANT ALL ON FLIGHT_TICKETS TO XKRUPE00;
GRANT ALL ON AIRCRAFTS TO XKRUPE00;
GRANT ALL ON AIRLINES TO XKRUPE00;
GRANT ALL ON AIRPORTS TO XKRUPE00;
GRANT ALL ON RESERVATIONS TO XKRUPE00;
GRANT ALL ON CUSTOMERS TO XKRUPE00;

-- Materialized View

CREATE VIEW customers_from_xkrupe00 AS
    SELECT aircraft_id FROM XKRUPE00.AIRCRAFTS WHERE
    type = 'Boeing';

CREATE MATERIALIZED VIEW customers_from_xkrupe00_mat AS
    SELECT aircraft_id FROM XKRUPE00.AIRCRAFTS WHERE
    type = 'Boeing';

-- New aircraft for demonstration

INSERT INTO XKRUPE00.AIRCRAFTS(type, model, airline_code)
    VALUES ('Boeing', '200HT', 'AUA');

-- Demonstration of Materialized View

SELECT aircraft_id FROM customers_from_xkrupe00;
SELECT aircraft_id FROM customers_from_xkrupe00_mat;