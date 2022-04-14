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

    DROP TABLE FLIGHT_TICKETS;
    DROP TABLE AIRCRAFTS;
    DROP TABLE AIRLINES;
    DROP TABLE AIRPORTS;
    DROP TABLE RESERVATIONS;
    DROP TABLE CUSTOMERS;

-- CREATE TABLE

    CREATE TABLE airlines (
        -- id according to IATA standard
        airline_code VARCHAR(2) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(airline_code,'[A-Z0-9]{2}')),
        name VARCHAR(128) NOT NULL,
        nationality VARCHAR(2) NOT NULL
    );

    CREATE TABLE aircrafts (
        aircraft_id NUMBER GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
        type VARCHAR(128) NOT NULL,
        model VARCHAR(128) NOT NULL,
        airline_code VARCHAR(2) NOT NULL,

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
        email VARCHAR(128) NOT NULL,
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
        flight_code VARCHAR(6) NOT NULL PRIMARY KEY CHECK(REGEXP_LIKE(flight_code, '[0-9a-zA-Z]{2}[0-9]{4}')),
        dep_time TIMESTAMP WITH TIME ZONE NOT NULL,
        arr_time TIMESTAMP WITH TIME ZONE NOT NULL,
        aircraft NUMBER NOT NULL,
        airline VARCHAR(2) NOT NULL,
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

-- INSERT VALUES

    -- CUSTOMERS
    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Leonardo', 'Blue', 'leotheleader@gmail.com', 'Bayport Lane', 'New York', 10461, 'US');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Raphael', 'Red', 'raphtherebel@gmail.com', 'Cemetery Dr.', 'Waltham', 02453, 'GB');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Donatello', 'Purple', 'donnythenerd@gmail.com', 'Maintongoon Road', 'Vesper', 3833, 'AU');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Michelangelo', 'Orange', 'mickeythejollier@gmail.com', 'MacLaren Street', 'Ottawa', 00157, 'CA');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Splinter', 'Master', 'splintertherat@gmail.com', 'Hakulintie', 'Turku', 20210, 'FI');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Jean', 'Medeiros', 'maeve.spore1@hotmail.com', 'Gnatty Creek', 'New York', '11530', 'US');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Carlene', 'Bashaw', 'violette.schust@gmail.com', 'Woodland Avenue', 'Metairie', '70001', 'US');

    INSERT INTO customers(first_name, last_name, email, street, town, post_code, user_country)
        VALUES('Aceline', 'Baril', 'AcelineBaril@jourrapide.com', 'avenue Jules Ferry', 'Stains', '93240', 'FR');


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
    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(1, TIMESTAMP'2022-03-13 15:24:33.00', 1);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(0, TIMESTAMP'2022-03-16 07:13:11.00', 2);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(1, TIMESTAMP'2022-03-20 02:01:58.00', 3);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(0, TIMESTAMP'2022-03-18 12:37:42.00', 4);

    INSERT INTO reservations(payment_status, created_at, owner)
        VALUES(1, TIMESTAMP'2022-03-20 21:56:22.00', 5);

    -- AIRLINES
    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('FA', 'FINLAND AIRLINE', 'FI');

    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('UA', 'USA AIRLINE', 'US');

    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('KA', 'UK AIRLINE', 'UK');

    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('AA', 'AUSTRALIAN AIRLINE', 'AU');

    INSERT INTO airlines(airline_code, name, nationality)
        VALUES('CA', 'CANADIAN AIRLINE', 'CA');

    -- AIRCRAFTS
    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '737 MAX', 'KA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Airbus', 'A3xx', 'UA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Airbus', 'A350', 'CA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '200LR', 'KA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Airbus', 'A300', 'AA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '200LR', 'UA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '737 MAX', 'AA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Airbus', 'A318', 'FA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '777', 'FA');

    INSERT INTO aircrafts(type, model, airline_code)
        VALUES('Boeing', '787', 'CA');

    -- FLIGHT TICKETS
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('BA2490',
               TIMESTAMP'2022-03-20 09:05:00.00 +01:00',
               TIMESTAMP'2022-03-20 10:55:00 +01:00',
               1,
               'FA',
               100,
               'TKU',
               'LHR',
               '17A',
               1,
               1);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('RG2700',
               TIMESTAMP'2022-03-21 10:25:00.00 +01:00',
               TIMESTAMP'2022-03-21 10:50:00.00 +01:00',
               2,
               'UA',
               50,
               'JFK',
               'YOW',
               '09B',
               2,
               2);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('SD1489',
               TIMESTAMP'2022-03-23 15:35:00.00 +01:00',
               TIMESTAMP'2022-03-24 11:35:00.00 +02:00',
               3,
               'AA',
               200,
               'SYD',
               'JFK',
               '13C',
               3,
               3);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('EQ1337',
                TIMESTAMP'2022-03-27 19:45:00.00 +05:00',
                TIMESTAMP'2022-03-20 17:10:00 +05:00',
                4,
                'CA',
                300,
                'YOW',
                'TKU',
                '01A',
                4,
                4);
    INSERT INTO flight_tickets(flight_code, dep_time, arr_time, aircraft, airline, price, dep_loc, arr_loc, seat_number, passenger, reservation_code)
        VALUES('UI2020',
                TIMESTAMP'2022-03-29 07:00:00.00 -01:00',
                TIMESTAMP'2022-03-30 02:35:00.00 +01:00',
                5,
                'KA',
                375,
                'LHR',
                'SYD',
                '22E',
                5,
                5);


-- SELECT NAME, AIRLINE_CODE FROM AIRCRAFTS NATURAL JOIN AIRLINES WHERE
--     type = 'Boeing';

-- SELECT L.NAME, P.NAME, CITY FROM AIRLINES L, AIRPORTS P WHERE
--     L.NATIONALITY = P.COUNTRY;

-- SELECT FLIGHT_CODE, DEP_LOC, FIRST_NAME, LAST_NAME FROM FLIGHT_TICKETS F, RESERVATIONS R, CUSTOMERS C  WHERE
--     F.RESERVATION_CODE = R.ID AND
--     R.OWNER = C.ID AND
--     R.PAYMENT_STATUS = 1;

