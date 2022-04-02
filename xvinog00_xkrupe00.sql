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
    producer          VARCHAR(128),
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


SET serveroutput ON;