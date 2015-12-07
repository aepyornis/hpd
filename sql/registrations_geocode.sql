-- generate BBL & add lat/lng from pluto
BEGIN;

ALTER TABLE hpd.registrations ADD COLUMN bbl text;

UPDATE hpd.registrations SET bbl = cast(boroid as text) || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');

ALTER TABLE hpd.registrations add COLUMN lat numeric;
ALTER TABLE hpd.registrations add COLUMN lng numeric;

UPDATE hpd.registrations SET lat = hpd.bbl_lookup.lat, lng = hpd.bbl_lookup.lng FROM hpd.bbl_lookup WHERE hpd.registrations.bbl = bbl_lookup.bbl;

DROP TABLE hpd.bbl_lookup;

COMMIT;

