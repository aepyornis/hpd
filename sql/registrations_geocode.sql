-- generate BBL & add lat/lng from pluto
ALTER TABLE hpd_registrations ADD COLUMN bbl text;

UPDATE hpd_registrations SET bbl = cast(boroid as text) || lpad(cast(block as text), 5, '0') || lpad(cast(lot as text), 4, '0');

ALTER TABLE hpd_registrations add COLUMN lat numeric;
ALTER TABLE hpd_registrations add COLUMN lng numeric;

UPDATE hpd_registrations SET lat = hpd_bbl_lookup.lat, lng = hpd_bbl_lookup.lng FROM hpd_bbl_lookup WHERE hpd_registrations.bbl = hpd_bbl_lookup.bbl;

DROP TABLE hpd_bbl_lookup;
