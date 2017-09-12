DROP TABLE IF EXISTS hpd_registrations_grouped_by_bbl_with_contacts;

-- This is mainly used as an easy way to provide contact info on request, not a replacement
-- for cross-table analysis. Hence why the corpnames, businessaddrs, and ownernames are simplified
-- with JSON and such.
CREATE TABLE hpd_registrations_grouped_by_bbl_with_contacts
as SELECT
  registrations.housenumber,
  registrations.streetname,
  registrations.zip,
  registrations.boro,
  registrations.lat,
  registrations.lng,
  registrations.registrationid,
  registrations.bbl,
  contacts.corpnames,
  contacts.businessaddrs,
  contacts.ownernames
FROM hpd_registrations_grouped_by_bbl AS registrations
LEFT JOIN (
  SELECT
    -- collect the various corporation names
    anyarray_uniq(anyarray_remove_null(array_agg(corporationname))) as corpnames,

    -- concat_ws ignores NULL values
    anyarray_uniq(anyarray_remove_null(
      array_agg(
        nullif(concat_ws(' ', businesshousenumber, businessstreetname, businessapartment, businesszip), '')
      )
    ))
    as businessaddrs,

    -- craziness! json in postgres!
    -- this will filter out the (typically blank) CorporateOwner human names and any other blanks
    -- using json makes this nice to get from a query but also allows us to store key/value pairs
    -- which both the title and owner's concatenated first and last name.
    json_agg(json_build_object('title', registrationcontacttype, 'value', (firstname || ' ' || lastname)))
      FILTER (
        WHERE registrationcontacttype != 'CorporateOwner' AND
        firstname IS NOT NULL AND
        lastname IS NOT NULL
      )
      AS ownernames,
    registrationid
  FROM hpd_contacts
  GROUP BY registrationid
) contacts ON (registrations.registrationid = contacts.registrationid);

create index on hpd_registrations_grouped_by_bbl_with_contacts (registrationid);
