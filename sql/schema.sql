BEGIN;

create table registrations (
       registrationID integer,
       buildingID integer,
       boroID smallint,
       boro text,
       housenumber text,
       lowhousenumber text,
       highhousenumber text,
       streetname text,
       streetcode integer,
       zip text,
       block smallint,
       lot smallint,
       BIN integer,
       communityboard smallint,
       lastregistrationdate date,
       registrationenddate date
);

create table contacts (
       registrationcontactID integer,
       registrationID integer,
       registrationcontacttype text,
       ContactDescription text,
       CorporationName text,
       Title text,
       FirstName text,
       MiddleInitial text,
       LastName text,
       BusinessHouseNumber text,
       BusinessStreetName text,
       BusinessApartment text,
       BusinessCity text,
       BusinessState text,
       BusinessZip text
);

-- these paths need to be updated
COPY registrations FROM '/Users/zy/code/hpd/data/registrations/Registrations20151001/Registration20150930.txt'  (DELIMITER '|', FORMAT CSV, HEADER TRUE) ;

COPY contacts FROM '/Users/zy/code/hpd/data/registrations/Registrations20151001/RegistrationContact20150930.txt'  (DELIMITER '|', FORMAT CSV, HEADER TRUE);

COMMIT;
