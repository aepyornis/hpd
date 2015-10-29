BEGIN;

ALTER TABLE corporate_owners ADD COLUMN formatted_address text;
ALTER TABLE corporate_owners ADD COLUMN lat numeric;
ALTER TABLE corporate_owners ADD COLUMN lng numeric;

CREATE TABLE geocode (
       id integer PRIMARY KEY,
       address text,
       lat numeric,
       lng numeric
);


COPY geocode FROM '/var/lib/openshift/562fedcc89f5cfb811000141/app-root/repo/data/geocoded.csv' (FORMAT CSV, QUOTE '"', HEADER FALSE);

UPDATE corporate_owners SET formatted_address = geocode.address, lat = geocode.lat, lng = geocode.lng FROM geocode WHERE corporate_owners.id = geocode.id;

DROP TABLE geocode;

COMMIT;
