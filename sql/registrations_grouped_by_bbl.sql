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
 
