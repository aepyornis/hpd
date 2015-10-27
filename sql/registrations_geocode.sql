-- generate BBL & add lat/lng from pluto
BEGIN;

ALTER TABLE registrations ADD COLUMN bbl text;

UPDATE  registrations SET bbl = cast(boroid as text) || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');

CREATE TABLE bbl_lookup (
       lat numeric,
       lng numeric,
       bbl text PRIMARY KEY
);

COPY  bbl_lookup FROM 'C:\cygwin64\home\ziggy\code\hpd\data\bbl_lat_lng.txt' (FORMAT CSV,  HEADER TRUE);

ALTER TABLE registrations add COLUMN lat numeric;
ALTER TABLE registrations add COLUMN lng numeric;

UPDATE  registrations SET lat = bbl_lookup.lat, lng = bbl_lookup.lng FROM bbl_lookup WHERE registrations.bbl = bbl_lookup.bbl;

DROP TABLE bbl_lookup;

COMMIT;

