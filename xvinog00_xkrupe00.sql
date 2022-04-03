-- IDS project #35

-- Project name: Ticket reservation.

-- Authors:
--          Ekaterina Krupenko (xkrupe00)
--          Alina Vinogradova  (xvinog00)


-- Project part 2 - SQL script for creating basic database schema objects
/*
    Tables:
        Customers
        Flight tickets
        Aircrafts
        Airlines

 */


-- DELETE TABLES

    DROP TABLE customers CASCADE CONSTRAINTS;
    DROP TABLE flight_tickets CASCADE CONSTRAINTS;
    DROP TABLE aircrafts CASCADE CONSTRAINTS;
    DROP TABLE airlines CASCADE CONSTRAINTS;

    DROP SEQUENCE customer_seq;
    CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1 NOCYCLE;

    DROP SEQUENCE aircraft_seq;
    CREATE SEQUENCE aircraft_seq START WITH 1 INCREMENT BY 1 NOCYCLE;

    DROP SEQUENCE flight_ticket_seq;
    CREATE SEQUENCE flight_ticket_seq START WITH 1 INCREMENT BY 1 NOCYCLE;

-- CREATE TABLE

  CREATE TABLE airlines (
    id    VARCHAR(2) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(id,'[A-Z0-9]{2}')),
    name       VARCHAR(100) NOT NULL
  );

  CREATE TABLE aircrafts (
    id                NUMBER NOT NULL PRIMARY KEY,
    type              VARCHAR(128),
    model             VARCHAR(128),
    airline           VARCHAR(2),

    CONSTRAINT aircraft_owner_airline_fk FOREIGN KEY (airline) REFERENCES airlines(id)
  );

  CREATE TABLE customers (
    id               NUMBER PRIMARY KEY,
    first_name       VARCHAR(128) NOT NULL,
    last_name        VARCHAR(128) NOT NULL,
    email            VARCHAR(128) NOT NULL,
    addr_street      VARCHAR(128) NOT NULL,
    addr_town        VARCHAR(128) NOT NULL,
    addr_post_code   NUMBER NOT NULL,
    addr_state       VARCHAR(128) NOT NULL
  );

  CREATE TABLE flight_tickets (
    flight_number     VARCHAR(6) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(flight_number, '[0-9a-zA-Z]{2}[0-9]{4}')),
    departure_time    TIMESTAMP WITH TIME ZONE NOT NULL,
    arrival_time      TIMESTAMP WITH TIME ZONE NOT NULL,
    aircraft          NUMBER,
    airline           VARCHAR(2) NOT NULL,
    starting_loc      VARCHAR(128) NOT NULL,
    destination_loc   VARCHAR(128) NOT NULL,
    seat_number       VARCHAR(3) CHECK(REGEXP_LIKE(seat_number, '[0-9][0-9][A-K]')),
    passenger         NUMBER,

    CONSTRAINT flight_with_airplane_fk        FOREIGN KEY (aircraft)    REFERENCES aircrafts(id),
    CONSTRAINT flight_tickets_passenger_fk    FOREIGN KEY (passenger)   REFERENCES customers(id),
    CONSTRAINT flight_operated_by_airline_fk  FOREIGN KEY (airline)     REFERENCES airlines(id)
  );


    CREATE OR REPLACE TRIGGER aircraft_trig BEFORE
        INSERT ON aircrafts
        FOR EACH ROW
        BEGIN
            SELECT aircraft_seq.NEXTVAL
            INTO : NEW.id
            FROM dual;
        END;
    /
    CREATE OR REPLACE TRIGGER customer_trig BEFORE
        INSERT ON customers
        FOR EACH ROW
        BEGIN
            SELECT customer_seq.NEXTVAL
            INTO : NEW.id
            FROM dual;
        END;
    /


-- SET serveroutput ON;

    INSERT INTO customers(id, first_name, last_name, email, addr_street, addr_town, addr_post_code, addr_state)
        VALUES(00001, 'Leonardo', 'Blue', 'leotheleader@gmail.com', 'Bayport Lane', 'New York', 10461, 'USA');

    INSERT INTO customers(id, first_name, last_name, email, addr_street, addr_town, addr_post_code, addr_state)
        VALUES(00002, 'Raphael', 'Red', 'raphtherebel@gmail.com', 'Cemetery Dr.', 'Waltham', 02453, 'UK');

    INSERT INTO customers(id, first_name, last_name, email, addr_street, addr_town, addr_post_code, addr_state)
        VALUES(00003, 'Donatello', 'Purple', 'donnythenerd@gmail.com', 'Maintongoon Road', 'Vesper', 3833, 'Australia');

    INSERT INTO customers(id, first_name, last_name, email, addr_street, addr_town, addr_post_code, addr_state)
        VALUES(00004, 'Michelangelo', 'Orange', 'mickeythejollier@gmail.com', 'MacLaren Street', 'Ottawa', 00157, 'Canada');

    INSERT INTO customers(id, first_name, last_name, email, addr_street, addr_town, addr_post_code, addr_state)
        VALUES(00005, 'Splinter', 'Master', 'splintertherat@gmail.com', 'Hakulintie', 'Turku', 20210, 'Finland');

--TODO: tickets insert "пиздец лень доделывать эти сраные билеты"
    INSERT INTO flight_tickets(flight_number, departure_time, arrival_time, aircraft, airline, starting_loc, destination_loc, seat_number, passenger)
        VALUES('KF8495', TIMESTAMP '2022-04-10 11:00:00.00 +01:00', TIMESTAMP '2022-04-10 15:00:00.00 +03:00', 001, 'LA', 'KDF', 'RTG');

    INSERT INTO flight_tickets(flight_number, departure_time, arrival_time, aircraft, airline, starting_loc, destination_loc, seat_number, passenger)
        VALUES('KF8495', TIMESTAMP '2022-04-10 11:00:00.00 +01:00', TIMESTAMP '2022-04-10 15:00:00.00 +03:00', 002, 'LA', 'KDF', 'RTG');

    INSERT INTO flight_tickets(flight_number, departure_time, arrival_time, aircraft, airline, starting_loc, destination_loc, seat_number, passenger)
        VALUES('KF8495', TIMESTAMP '2022-04-10 11:00:00.00 +01:00', TIMESTAMP '2022-04-10 15:00:00.00 +03:00', 003, 'LA', 'KDF', 'RTG');

    INSERT INTO flight_tickets(flight_number, departure_time, arrival_time, aircraft, airline, starting_loc, destination_loc, seat_number, passenger)
        VALUES('KF8495', TIMESTAMP '2022-04-10 11:00:00.00 +01:00', TIMESTAMP '2022-04-10 15:00:00.00 +03:00', 004, 'LA', 'KDF', 'RTG');

    INSERT INTO flight_tickets(flight_number, departure_time, arrival_time, aircraft, airline, starting_loc, destination_loc, seat_number, passenger)
        VALUES('KF8495', TIMESTAMP '2022-04-10 11:00:00.00 +01:00', TIMESTAMP '2022-04-10 15:00:00.00 +03:00', 005, 'LA', 'KDF', 'RTG');


    INSERT INTO airlines(id, name)
        VALUES('FA', 'FINLAND AIRLINE');

    INSERT INTO airlines(id, name)
        VALUES('UA', 'USA AIRLINE');

    INSERT INTO airlines(id, name)
        VALUES('KA', 'UK AIRLINE');

    INSERT INTO airlines(id, name)
        VALUES('AA', 'AUSTRALIAN AIRLINE');

    INSERT INTO airlines(id, name)
        VALUES('CA', 'CANADIAN AIRLINE');


    INSERT INTO aircrafts(id, type, model, airline)
        VALUES(001, 'Boeing', '737 MAX', 'KA');

    INSERT INTO aircrafts(id, type, model, airline)
        VALUES(002, 'Airbus', 'A3xx', 'UA');

    INSERT INTO aircrafts(id, type, model, airline)
        VALUES(003, 'Airbus', 'A350', 'CA');

    INSERT INTO aircrafts(id, type, model, airline)
        VALUES(004, 'Boeing', '200LR', 'UK');

    INSERT INTO aircrafts(id, type, model, airline)
        VALUES(005, 'Airbus', 'e.g.', 'AA');