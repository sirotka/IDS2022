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


-- DELETE TABLE

-- TODO airports and reservation

    DROP TABLE customers CASCADE CONSTRAINTS;
    DROP TABLE flight_tickets CASCADE CONSTRAINTS;
    DROP TABLE aircrafts CASCADE CONSTRAINTS;
    DROP TABLE airlines CASCADE CONSTRAINTS;
    DROP TABLE airports CASCADE CONSTRAINTS;
    DROP TABLE reservations CASCADE CONSTRAINTS;

    DROP SEQUENCE customer_seq;
        CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1 NOCYCLE;

    DROP SEQUENCE aircraft_seq;
        CREATE SEQUENCE aircraft_seq START WITH 1 INCREMENT BY 1 NOCYCLE;

    DROP SEQUENCE flight_ticket_seq;
        CREATE SEQUENCE flight_ticket_seq START WITH 1 INCREMENT BY 1 NOCYCLE;

    DROP SEQUENCE reservation_seq;
        CREATE SEQUENCE reservation_seq START WITH 1 INCREMENT BY 1 NOCYCLE;

-- CREATE TABLE

-- TODO airports and reservation

    CREATE TABLE airlines (
        -- id according to IATA standard
        id VARCHAR(2) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(id,'[A-Z0-9]{2}')),
        name VARCHAR(128) NOT NULL
    );

    CREATE TABLE aircrafts (
        id NUMBER NOT NULL PRIMARY KEY,
        type VARCHAR(128),
        model VARCHAR(128),
        airline VARCHAR(2),

        CONSTRAINT aircraft_owner_airline_fk FOREIGN KEY (airline) REFERENCES airlines(id)
    );

    CREATE TABLE airports (
        -- airport_codes according to IATA standard
        airport_code VARCHAR(2) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(airport_code,'[A-Z]{3}')),
        name VARCHAR(128) NOT NULL,
        city VARCHAR(128),
        -- countries according to ISO 3166-1 Alpha-2 code standard
        country VARCHAR(2) NOT NULL CHECK (REGEXP_LIKE(country, '[A-Z]{2}'))
    );

    CREATE TABLE customers (
        id NUMBER PRIMARY KEY,
        first_name VARCHAR(128) NOT NULL,
        last_name VARCHAR(128) NOT NULL,
        email VARCHAR(128) NOT NULL,
        addr_street VARCHAR(128) NOT NULL,
        addr_town VARCHAR(128) NOT NULL,
        addr_post_code NUMBER NOT NULL,
        addr_state VARCHAR(128) NOT NULL
    );

    CREATE TABLE reservations (
        id NUMBER NOT NULL PRIMARY KEY,
        status NUMBER NOT NULL CHECK(status = 0 or status = 1), -- true or false
        created_at TIMESTAMP NOT NULL,
        owner NUMBER,

        CONSTRAINT FK_RESERVATION_OWNER FOREIGN KEY(owner) REFERENCES customers(id)
    );

    CREATE TABLE flight_tickets (
        flight_number VARCHAR(6) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(flight_number, '[0-9a-zA-Z]{2}[0-9]{4}')),
        departure_time TIMESTAMP WITH TIME ZONE NOT NULL,
        arrival_time TIMESTAMP WITH TIME ZONE NOT NULL,
        aircraft NUMBER,
        airline VARCHAR(2) NOT NULL,
        price NUMBER NOT NULL,
        start_loc VARCHAR(3) NOT NULL,
        destination_loc VARCHAR(3) NOT NULL,
        seat_number VARCHAR(3) CHECK(REGEXP_LIKE(seat_number, '[0-9][0-9][A-Z]')),
        passenger NUMBER,
        reservation NUMBER NOT NULL,

        CONSTRAINT FK_TICKET_START_LOC FOREIGN KEY(start_loc) REFERENCES airports(airport_code),
        CONSTRAINT FK_TICKET_DESTINATION_LOC FOREIGN KEY(destination_loc) REFERENCES airports(airport_code),
        CONSTRAINT FK_TICKET_WITH_AIRCRAFT FOREIGN KEY(aircraft) REFERENCES aircrafts(id),
        CONSTRAINT FK_TICKET_OWNER FOREIGN KEY(passenger) REFERENCES customers(id),
        CONSTRAINT FK_TICKET_CREATOR FOREIGN KEY(airline) REFERENCES airlines(id),
        CONSTRAINT FK_TICKET_RESERVATION FOREIGN KEY (reservation) REFERENCES reservations(id)
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
    CREATE OR REPLACE TRIGGER reservation_trig BEFORE
        INSERT ON reservations
        FOR EACH ROW
        BEGIN
            SELECT reservation_seq.NEXTVAL
            INTO : NEW.id
            FROM dual;
        END;
    /

--TODO figure out whether to write exceptions?

--INSERT PART

--TODO airports and reservation

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


    INSERT INTO airports(airport_code, name, city, country)
        VALUES('', '');

    INSERT INTO airports(airport_code, name, city, country)
        VALUES('', '');

    INSERT INTO airports(airport_code, name, city, country)
        VALUES('', '');

    INSERT INTO airports(airport_code, name, city, country)
        VALUES('', '');

    INSERT INTO airports(airport_code, name, city, country)
        VALUES('', '');


--TODO: tickets insert "пиздец лень доделывать эти сраные билеты"
    INSERT INTO flight_tickets(flight_number, departure_time, arrival_time, aircraft, airline, start_loc, destination_loc, seat_number, passenger)
        VALUES('KF8495', TIMESTAMP '2022-04-10 11:00:00.00 +01:00', TIMESTAMP '2022-04-10 15:00:00.00 +03:00', 001, 'LA', 'KDF', 'RTG');

    INSERT INTO flight_tickets(flight_number, departure_time, arrival_time, aircraft, airline, start_loc, destination_loc, seat_number, passenger)
        VALUES('KF8495', TIMESTAMP '2022-04-10 11:00:00.00 +01:00', TIMESTAMP '2022-04-10 15:00:00.00 +03:00', 002, 'LA', 'KDF', 'RTG');

    INSERT INTO flight_tickets(flight_number, departure_time, arrival_time, aircraft, airline, start_loc, destination_loc, seat_number, passenger)
        VALUES('KF8495', TIMESTAMP '2022-04-10 11:00:00.00 +01:00', TIMESTAMP '2022-04-10 15:00:00.00 +03:00', 003, 'LA', 'KDF', 'RTG');

    INSERT INTO flight_tickets(flight_number, departure_time, arrival_time, aircraft, airline, start_loc, destination_loc, seat_number, passenger)
        VALUES('KF8495', TIMESTAMP '2022-04-10 11:00:00.00 +01:00', TIMESTAMP '2022-04-10 15:00:00.00 +03:00', 004, 'LA', 'KDF', 'RTG');

    INSERT INTO flight_tickets(flight_number, departure_time, arrival_time, aircraft, airline, start_loc, destination_loc, seat_number, passenger)
        VALUES('KF8495', TIMESTAMP '2022-04-10 11:00:00.00 +01:00', TIMESTAMP '2022-04-10 15:00:00.00 +03:00', 005, 'LA', 'KDF', 'RTG');


    INSERT INTO reservations(id, status, created_at, owner)
        VALUES(00001, '1', timestamp'2022-07-20 13:30:00.00', '00003');

    INSERT INTO reservations(id, status, created_at, owner)
        VALUES(00001, '1', timestamp'2022-07-20 13:30:00.00', '00003');

    INSERT INTO reservations(id, status, created_at, owner)
        VALUES(00001, '1', timestamp'2022-07-20 13:30:00.00', '00003');

    INSERT INTO reservations(id, status, created_at, owner)
        VALUES(00001, '1', timestamp'2022-07-20 13:30:00.00', '00003');

    INSERT INTO reservations(id, status, created_at, owner)
        VALUES(00001, '1', timestamp'2022-07-20 13:30:00.00', '00003');


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