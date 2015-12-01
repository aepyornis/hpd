--how many "unique" contacts
select count(DISTINCT registrationcontactId) from contacts;
-- rank in order
select registrationcontactID,
       count(registrationcontactID) as c
FROM contacts
GROUP BY registrationcontactID
ORDER BY c DESC;

-- Contacts, group by housenumber, streetname 
select BusinessHouseNumber as house,
       BusinessStreetName as street,
       count(*) as count
FROM contacts
GROUP BY BusinessHouseNumber, BusinessStreetName
ORDER BY count DESC;

-- List of contact types
select registrationcontacttype,
       count (*) as count
FROM contacts
GROUP BY registrationcontacttype

-- most common Corporation Names
select CorporationName,
       count(*) as count
FROM contacts
GROUP BY CorporationName
ORDER BY count desc

-- Group contacts by House, Street, City, State, Zip. count: 171,772
SELECT BusinessHouseNumber,
       BusinessStreetName,
       BusinessCity,
       BusinessState,
       BusinessZip,
       count (*) as count
FROM contacts
GROUP BY BusinessHouseNumber,
         BusinessStreetName,
         BusinessCity,
         BusinessState,
         BusinessZip
ORDER BY count desc

-- group contacts by House, Street, Zip. count: 156,343
SELECT BusinessHouseNumber,
       BusinessStreetName,
       BusinessZip,
       count (*) as count
FROM contacts
GROUP BY BusinessHouseNumber,
         BusinessStreetName,
         BusinessZip
ORDER BY count desc

-- group contacts by house, street, city. count: 167,598
SELECT BusinessHouseNumber,
       BusinessStreetName,
       BusinessCity,
       count (*) as count
FROM contacts
GROUP BY BusinessHouseNumber,
         BusinessStreetName,
         BusinessCity
ORDER BY count desc

-- nulls:
select COUNT(*)
FROM contacts
WHERE BusinessHouseNumber IS NULL
      AND BusinessStreetName IS NULL
      AND BusinessApartment IS NULL
      AND BusinessCity IS NULL
      AND BusinessState IS NULL
      AND BusinessZip IS NULL

/*
CorporationName: 463249
BusinessHouseNumber: 134614
BusinessStreetName: 134348
BusinessApartment 410177,
BusinessCity: 134536,
BusinessState: 136553,
BusinessZip: 134909

all null: 133825
*/

--Corporate Name lookup:

SELECT *
FROM (
     SELECT UNNEST(uniqnames) as corpname,
            id
     FROM corporate_owners
) as x
WHERE x.corpname ilike $1


--Get regid for address (house number, streetname, boroid)
SELECTregistrationid
from registrations
where housenumber = $1 AND streetname = $2 AND boroid = $3;


--get corporation name for regid
select corporationname
from contacts
where registrationcontacttype = 'CorporateOwner' and registrationid = $1


--get corporate_owner id, regids, uniqnames, businesshousenumber, businessstreetname, zip
SELECT id,
       regids,
       uniqnames,
       businesshousenumber,
       businessstreetname,
       businesszipzip
FROM corporate_owners
WHERE $1 = ANY(regids)


--Corporate_owners
SELECT BusinessHouseNumber,
       BusinessStreetName,
       BusinessZip,
       BusinessApartment,
       count (*) as numberOfContacts,
       anyarray_remove_null(array_agg(CorporationName)) as corporationnames,
       array_agg(registrationID) as regids,
       anyarray_uniq(array_agg(registrationID)) as uniqregids
FROM contacts
WHERE (
      BusinessHouseNumber IS NOT NULL
      AND BusinessStreetName IS NOT NULL
      AND BusinessZip IS NOT NULL
      ) AND (registrationcontacttype = 'CorporateOwner')
GROUP BY
      BusinessHouseNumber,
      BusinessStreetName,
      BusinessZip,
      BusinessApartment

-- Registrations grouped by BBL
SELECT  first(housenumber) as housenumber,
        first(streetname) as streetname,
        first(zip) as zip,
        first( boro) as boro,
        lat,
        lng,
        registrationid,
        bbl
FROM registrations
GROUP BY
      bbl,
      lat,
      lng,
      registrationid;

--List of Corporate Owners (treats garden complex as a single on)
SELECT businesshousenumber || ' ' || businessstreetname as a,
       businesszip as zip,
       array_length(anyarray_uniq(regids), 1) as num,
       id,
       array_length(uniqnames, 1) as nc
FROM corporate_owners
ORDER BY num DESC
LIMIT 500

---GET Lat,Lng from Corporate Owners
SELECT lat,
       lng
FROM corporate_owners
WHERE id = $1;

---Get Buildings by Corporate Owner ID
SELECT corporate_owner.regid as regid,
       r.housenumber as h,
       r.streetname as st,
       r.zip as zip,
       r.boro as b,
       r.lat as lat,
       r.lng as lng,
       r.bbl as bbl,
       corporationname as corp
FROM (
     SELECT DISTINCT unnest(regids) as regid
     FROM corporate_owners
     WHERE id = $1
) as corporate_owner
JOIN (
     SELECT *
     FROM contacts
     WHERE registrationcontacttype = 'CorporateOwner'
) as c
  on corporate_owner.regid = c.registrationid
JOIN registrations_grouped_by_bbl as r
on corporate_owner.regid = r.registrationid



SELECT corporate_owner.regid as regid,
r.housenumber as h,
r.streetname as st,
r.zip as zip,
r.boro as b,
r.lat as lat,
r.lng as lng,
r.bbl as bbl,
corporationname as corp
FROM (
SELECT DISTINCT unnest(regids) as regid
FROM corporate_owners
WHERE id = 58408
) as corporate_owner
JOIN (
SELECT *
FROM contacts
WHERE registrationcontacttype = 'CorporateOwner'
) as c
on corporate_owner.regid = c.registrationid
JOIN registrations_grouped_by_bbl_materialized as r
on corporate_owner.regid = r.registrationid



CREATE MATERIALIZED VIEW
registrations_grouped_by_bbl_materialized
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












y









 
29600.00..191770.59
