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

-- CREATE TABLE

  CREATE TABLE airlines (
    /* Airline code in official IATA format; Example: CX */
    id    VARCHAR(2) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(id,'[A-Z0-9]{2}')),
    name       VARCHAR(100) NOT NULL,
    nationality     VARCHAR(100) NOT NULL
  );

  CREATE TABLE aircrafts (
    id                NUMBER NOT NULL PRIMARY KEY,
    producer          VARCHAR(100),
    model             VARCHAR(100),
    fclass_seats      NUMBER NOT NULL,  -- first class = 1.
    bclass_seats      NUMBER NOT NULL,  -- business class = 2.
    eclass_seats      NUMBER NOT NULL,  -- economy class = 3.
    airline           VARCHAR(2),

    CONSTRAINT aircraft_owner_airline_fk FOREIGN KEY (airline) REFERENCES airlines(id)
  );

  CREATE TABLE flight_tickets (
    /* Flight Number in IATA official format; Example: BA026 */
    flight_number     VARCHAR(6) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(flight_number, '[0-9a-zA-Z]{2}[0-9]{4}')),
    departure_time    TIMESTAMP WITH TIME ZONE NOT NULL,
    arrival_time      TIMESTAMP WITH TIME ZONE NOT NULL,
    airplane          NUMBER,
    airline           VARCHAR(2) NOT NULL,
    origin            VARCHAR(3) NOT NULL,
    destination       VARCHAR(3) NOT NULL,
    fclass_seats_free NUMBER,
    constraint fclass_uint_seats check (fclass_seats_free >= 0),
    bclass_seats_free NUMBER,
    constraint bclass_uint_seats check (bclass_seats_free >= 0),
    eclass_seats_free NUMBER,
    constraint eclass_uint_seats check (eclass_seats_free >= 0),

    CONSTRAINT flight_with_airplane_fk        FOREIGN KEY (airplane)    REFERENCES aircrafts(id),
    CONSTRAINT flight_operated_by_airline_fk  FOREIGN KEY (airline)     REFERENCES airlines(id)
  );

  CREATE TABLE customers (
    id               NUMBER PRIMARY KEY,
    first_name       VARCHAR(50) NOT NULL,
    last_name        VARCHAR(50) NOT NULL,
    email            VARCHAR(100) NOT NULL,
    addr_street      VARCHAR(100) NOT NULL,
    addr_town        VARCHAR(100) NOT NULL,
    addr_post_code   NUMBER NOT NULL,
    addr_state       VARCHAR(100) NOT NULL
  );

  CREATE OR REPLACE TRIGGER flight_ticket_trig BEFORE
        INSERT ON flight_tickets
        FOR EACH ROW
        BEGIN
            SELECT fclass_seats
            INTO : NEW.fclass_seats_free
            FROM aircrafts
            WHERE aircrafts.id = :NEW.aircraft;

            SELECT bclass_seats
            INTO : NEW.bclass_seats_free
            FROM aircrafts
            WHERE aircrafts.id = :NEW.aircraft;

            SELECT eclass_seats
            INTO : NEW.eclass_seats_free
            FROM aircrafts
            WHERE aircrafts.id = :NEW.aircraft;
        END;
    /
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