
-- we will use a table instead of a view for better performance
/*
CREATE OR REPLACE VIEW
       registrations_grouped_by_bbl
as SELECT
   first(housenumber) as housenumber,
   first(streetname) as streetname,
   first(zip) as zip,
   first( boro) as boro,
   lat,
   lng,
   registrationid,
   bbl
 FROM
   registrations
 GROUP BY bbl, lat, lng, registrationid;
 
*/

DROP TABLE IF EXISTS hpd_registrations_grouped_by_bbl;

CREATE TABLE hpd_registrations_grouped_by_bbl
as SELECT
   first(housenumber) as housenumber,
   first(streetname) as streetname,
   first(zip) as zip,
   first( boro) as boro,
   lat,
   lng,
   registrationid,
   bbl
FROM hpd_registrations
GROUP BY bbl, lat, lng, registrationid;

create index on hpd_registrations_grouped_by_bbl (registrationid);
