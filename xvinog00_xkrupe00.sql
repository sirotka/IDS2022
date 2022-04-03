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
        id NUMBER PRIMARY KEY,
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
        street VARCHAR(128) NOT NULL,
        town VARCHAR(128) NOT NULL,
        post_code NUMBER NOT NULL,
        country VARCHAR(2) NOT NULL CHECK (REGEXP_LIKE(country, '[A-Z]{2}'))
    );

    CREATE TABLE reservations (
        id NUMBER PRIMARY KEY,
        status NUMBER NOT NULL CHECK(status = 0 or status = 1), -- true or false
        created_at TIMESTAMP NOT NULL,
        owner NUMBER,

        CONSTRAINT FK_RESERVATION_OWNER FOREIGN KEY(owner) REFERENCES customers(id)
    );

    CREATE TABLE flight_tickets (
        flight_code VARCHAR(6) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(flight_code, '[0-9a-zA-Z]{2}[0-9]{4}')),
        dep_time TIMESTAMP WITH TIME ZONE NOT NULL,
        arr_time TIMESTAMP WITH TIME ZONE NOT NULL,
        aircraft NUMBER,
        airline VARCHAR(2) NOT NULL,
        price NUMBER NOT NULL,
        dep_loc VARCHAR(3) NOT NULL,
        arr_loc VARCHAR(3) NOT NULL,
        seat_number VARCHAR(3) CHECK(REGEXP_LIKE(seat_number, '[0-9][0-9][A-Z]')),
        passenger NUMBER,
        reservation NUMBER NOT NULL,

        CONSTRAINT FK_TICKET_START_LOC FOREIGN KEY(dep_loc) REFERENCES airports(airport_code),
        CONSTRAINT FK_TICKET_DESTINATION_LOC FOREIGN KEY(arr_loc) REFERENCES airports(airport_code),
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

--INSERT PART

--TODO airports and reservation

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, country)
        VALUES('Leonardo', 'Blue', 'leotheleader@gmail.com', 'Bayport Lane', 'New York', 10461, 'US');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, country)
        VALUES('Raphael', 'Red', 'raphtherebel@gmail.com', 'Cemetery Dr.', 'Waltham', 02453, 'GB');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, country)
        VALUES('Donatello', 'Purple', 'donnythenerd@gmail.com', 'Maintongoon Road', 'Vesper', 3833, 'AU');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, country)
        VALUES('Michelangelo', 'Orange', 'mickeythejollier@gmail.com', 'MacLaren Street', 'Ottawa', 00157, 'CA');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, country)
        VALUES('Splinter', 'Master', 'splintertherat@gmail.com', 'Hakulintie', 'Turku', 20210, 'FI');


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

--TODO: tickets insert "пиздец лень доделывать эти сраные билеты"
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation)
        VALUES('BA2490',
               TO_TIMESTAMP(:ts_val, '2022-03-20 0924:05:00'),
               TO_TIMESTAMP(:ts_val, '2022-03-20 1024:55:00'),
               1,
               'FA',
               100,
               'TKU',
               'LHR',
               '17A',
               1,
               1);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation)
        VALUES('RG2700',
               TO_TIMESTAMP(:ts_val, '2022-03-21 1024:25:00'),
               TO_TIMESTAMP(:ts_val, '2022-03-21 1324:50:00'),
               2,
               'UA',
               50,
               'JFK',
               'YOW',
               '09B',
               2,
               2);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation)
        VALUES('SD1489',
               TO_TIMESTAMP(:ts_val, '2022-03-23 1524:35:00'),
               TO_TIMESTAMP(:ts_val, '2022-03-24 1124:35:00'),
               3,
               'AA',
               200,
               'SYD',
               'JFK',
               '13C',
               3,
               3);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation)
        VALUES('EQ1337',
                TO_TIMESTAMP(:ts_val, '2022-03-27 1924:45:00'),
                TO_TIMESTAMP(:ts_val, '2022-03-20 1724:10:00'),
                4,
                'CAN',
                300,
                'YOW',
                'TKU',
                '01A',
                4,
                4);
INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation)
        VALUES('UI2020',
                TO_TIMESTAMP(:ts_val, '2022-03-29 0724:00:00'),
                TO_TIMESTAMP(:ts_val, '2022-03-30 0224:35:00'),
                5,
                'KA',
                375,
                'LHR',
                'SYD',
                '22E',
                5,
                5);

    INSERT INTO reservations(status, created_at, owner)
        VALUES(1, TO_TIMESTAMP(:ts_val, '2022-03-13 1524:24:33'), 1);

    INSERT INTO reservations(status, created_at, owner)
        VALUES(0, TO_TIMESTAMP(:ts_val, '2022-03-16 0724:13:11'), 2);

    INSERT INTO reservations(status, created_at, owner)
        VALUES(1, TO_TIMESTAMP(:ts_val, '2022-03-20 0224:01:58'), 3);

    INSERT INTO reservations(status, created_at, owner)
        VALUES(0, TO_TIMESTAMP(:ts_val, '2022-03-18 1224:37:42'), 4);

    INSERT INTO reservations(status, created_at, owner)
        VALUES(1, TO_TIMESTAMP(:ts_val, '2022-03-20 2124:56:22'), 5);


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


    INSERT INTO aircrafts(type, model, airline)
        VALUES('Boeing', '737 MAX', 'KA');

    INSERT INTO aircrafts(type, model, airline)
        VALUES('Airbus', 'A3xx', 'UA');

    INSERT INTO aircrafts(type, model, airline)
        VALUES('Airbus', 'A350', 'CA');

    INSERT INTO aircrafts(type, model, airline)
        VALUES('Boeing', '200LR', 'UK');

    INSERT INTO aircrafts(type, model, airline)
        VALUES('Airbus', 'e.g.', 'AA');