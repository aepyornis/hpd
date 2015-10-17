--how many "unique" contacts
select count(DISTINCT registrationcontactId) from contacts;
-- rank in order
select  registrationcontactID, count( registrationcontactID ) as c FROM contacts GROUP BY  registrationcontactID ORDER BY c DESC;

-- group by address
select BusinessHouseNumber as house, BusinessStreetName as street, count(*) as count FROM contacts GROUP BY BusinessHouseNumber, BusinessStreetName ORDER BY count DESC;

select * from contacts where businesshousenumber = '1735' AND businessStreetname = 'PARK AVE';

-- List of contact types
select registrationcontacttype, count (*) as count FROM contacts GROUP BY registrationcontacttype

-- most common Corporation Names
select CorporationName, count(*) as count FROM contacts GROUP BY CorporationNam
e ORDER BY count desc

-- Group contacts by House, Street, City, State, Zip. count: 171,772
SELECT BusinessHouseNumber, BusinessStreetName, BusinessCity, BusinessState, BusinessZip, count (*) as count FROM contacts GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessCity, BusinessState, BusinessZip ORDER BY count desc

-- group contacts by House, Street, Zip. count: 156,343
SELECT BusinessHouseNumber, BusinessStreetName, BusinessZip, count (*) as count FROM contacts GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessZip ORDER BY count desc

-- group contacts by house, street, city. count: 167,598
SELECT BusinessHouseNumber, BusinessStreetName, BusinessCity, count (*) as count FROM contacts GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessCity ORDER BY count desc

-- nulls:
select COUNT(*) FROM contacts WHERE BusinessHouseNumber IS NULL AND BusinessStreetName IS NULL AND BusinessApartment IS NULL AND BusinessCity IS NULL AND BusinessState IS NULL AND BusinessZip IS NULL

/*CorporationName: 463249

BusinessHouseNumber: 134614
BusinessStreetName: 134348
BusinessApartment 410177,
BusinessCity: 134536,
BusinessState: 136553,
BusinessZip: 134909

all null: 133825
*/

--
SELECT BusinessHouseNumber, BusinessStreetName, BusinessCity, count (*) as count, array_agg(CorporationName) FROM contacts WHERE (BusinessHouseNumber IS NOT NULL AND  BusinessStreetName IS NOT NULL AND  BusinessCity IS NOT NULL) GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessCity ORDER BY count desc LIMIT 500;


SELECT BusinessHouseNumber,
       BusinessStreetName,
       BusinessZip, count (*) as count,
       (array_length(array_agg(CorporationName), 1) - array_length(array_remove(array_agg(CorporationName), NULL), 1)) as blanks,
       array_remove(array_agg(CorporationName), NULL)
FROM contacts
WHERE
        (BusinessHouseNumber IS NOT NULL AND BusinessStreetName IS NOT NULL AND  BusinessZip IS NOT NULL)
GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessZip
ORDER BY count desc
LIMIT 1000;

SELECT array_length(array_agg(CorporationName), 1) as mylength, count(*) as count, BusinessStreetName FROM contacts GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessCity LIMIT 10;

178,616
155,181

SELECT BusinessHouseNumber,
       BusinessStreetName,
       BusinessZip,
       BusinessApartment,
       count (*) as numberOfContacts,
       array_length(array_agg(CorporationName), 1) as name_array_length,
       (array_length(array_agg(CorporationName), 1) - array_length(array_remove(array_agg(CorporationName), NULL), 1)) as blanks,
       array_remove(array_agg(CorporationName), NULL)
FROM contacts
WHERE
(BusinessHouseNumber IS NOT NULL AND BusinessStreetName IS NOT NULL AND  BusinessZip IS NOT NULL) AND (registrationcontacttype === 'CorporateOwner') )
GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessZip, Busine


ORDER BY count desc

SELECT BusinessHouseNumber,
       BusinessStreetName,
       BusinessZip,
       BusinessApartment,
       count (*) as numberOfContacts,
       array_length(array_agg(CorporationName), 1) as name_array_length,
       (array_length(array_agg(CorporationName), 1) - array_length(array_remove(array_agg(CorporationName), NULL), 1)) as blanks,
       array_remove(array_agg(CorporationName), NULL) as list_of_names,
       array_agg(registrationID) as list_of_registrations
FROM contacts
WHERE
 (BusinessHouseNumber IS NOT NULL AND BusinessStreetName IS NOT NULL AND  BusinessZip IS NOT NULL) AND (registrationcontacttype = 'CorporateOwner') 
GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessZip, BusinessApartment
ORDER BY numberOfContacts DESC
LIMIT 500;


-- hunt for fuzzy matching...
--COMPARE GROUP BY COUNTS

SELECT count (*) as count FROM (SELECT BusinessHouseNumber, BusinessStreetName, BusinessZip, BusinessApartment FROM contacts2 GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessZip, BusinessApartment) as x;

--contacts:  179818 
--contacts2: 152161

-- provides list of registrations as IDs
SELECT BusinessHouseNumber,
       BusinessStreetName,
       BusinessZip,
       BusinessApartment,
       count (*) as numberOfContacts,
       (array_length(array_agg(CorporationName), 1) - array_length(array_remove(array_agg(CorporationName), NULL), 1)) as blanks,
       array_remove(array_agg(CorporationName), NULL) as list_of_names,
       array_agg(registrationID) as list_of_registrations
FROM contacts, registrations
WHERE
(BusinessHouseNumber IS NOT NULL AND BusinessStreetName IS NOT NULL AND  BusinessZip IS NOT NULL) AND (registrationcontacttype = 'CorporateOwner') 
GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessZip, BusinessApartment
ORDER BY numberOfContacts DESC;


SELECT c.BusinessHouseNumber,
       c.BusinessStreetName,
       c.BusinessZip,
       c.BusinessApartment,
       count (*) as numberOfContacts,
       (array_length(array_agg(c.CorporationName), 1) - array_length(array_remove(array_agg(c.CorporationName), NULL), 1)) as blanks,
       array_remove(array_agg(c.CorporationName), NULL) as list_of_names,
       array_agg(r.info) as info
FROM contacts as c
JOIN registrations as r on c.registrationID = r.registrationID
WHERE
(BusinessHouseNumber IS NOT NULL AND BusinessStreetName IS NOT NULL AND  BusinessZip IS NOT NULL) AND (registrationcontacttype = 'CorporateOwner')
GROUP BY c.BusinessHouseNumber, c.BusinessStreetName, c.BusinessZip, c.BusinessApartment
ORDER BY numberOfContacts DESC

-- add info to registrations

ALTER TABLE registrations ADD COLUMN info text;

UPDATE registrations set info =  housenumber || ' ' || streetname || ' ' || boro || ' (ID:' || registrationID || ')';


-- this query provides the list!!!!
SELECT c.BusinessHouseNumber,
       c.BusinessStreetName,
       c.BusinessZip,
       c.BusinessApartment,
       count (*) as numberOfContacts,
       array_remove(array_agg(c.CorporationName), NULL) as list_of_names,
       array_agg(r.info) as info
FROM contacts as c
JOIN registrations as r on c.registrationID = r.registrationID
WHERE
       (BusinessHouseNumber IS NOT NULL AND BusinessStreetName IS NOT NULL AND  BusinessZip IS NOT NULL)
        AND (registrationcontacttype = 'CorporateOwner')
GROUP BY c.BusinessHouseNumber, c.BusinessStreetName, c.BusinessZip, c.BusinessApartment
ORDER BY numberOfContacts DESC;


SELECT BusinessHouseNumber,
       BusinessStreetName,
       BusinessZip,
       BusinessApartment,
       count (*) as numberOfContacts,
       array_remove(array_agg(CorporationName), NULL) as corporationnames,
       array_agg(registrationID) as regids
FROM contacts
WHERE
(BusinessHouseNumber IS NOT NULL AND BusinessStreetName IS NOT NULL AND  BusinessZip IS NOT NULL)
AND (registrationcontacttype = 'CorporateOwner')
GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessZip, BusinessApartment

ORDER BY numberOfContacts DESC


create table corporate_owners AS (
SELECT BusinessHouseNumber,
      BusinessStreetName,
      BusinessZip,
      BusinessApartment,
      count (*) as numberOfContacts,
      array_remove(array_agg(CorporationName), NULL) as corporationnames,
      array_agg(registrationID) as regids
FROM contacts
WHERE
        (BusinessHouseNumber IS NOT NULL AND BusinessStreetName IS NOT NULL AND  BusinessZip IS NOT NULL)
                     AND (registrationcontacttype = 'CorporateOwner')
GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessZip, BusinessApartment
)


COPY 
(SELECT c.BusinessHouseNumber,
       c.BusinessStreetName,
       c.BusinessZip,
       c.BusinessApartment,
       count (*) as numberOfContacts,
       array_remove(array_agg(c.businessCity), NULL) as list_of_city
FROM contacts2 as c
WHERE
(BusinessHouseNumber IS NOT NULL AND BusinessStreetName IS NOT NULL AND  BusinessZip IS NOT NULL)
AND (registrationcontacttype = 'CorporateOwner')
GROUP BY c.BusinessHouseNumber, c.BusinessStreetName, c.BusinessZip, c.BusinessApartment
ORDER BY numberOfContacts DESC LIMIT 1000) to '/Users/zy/code/hpd/city_test.csv' CSV HEADER;

ALTER TABLE corporate_owners ADD COLUMN uniqnames text[]

UPDATE corporate_owners SET uniqnames = corporationnames;
UPDATE corporate_owners SET uniqnames = anyarray_uniq(corporationnames) WHERE array_length(corporationnames, 1) > 0;



SELECT regids FROM corporate_owners WHERE id = 40182;

SELECT unnest(regids) as regids FROM corporate_owners WHERE id = 40182;

SELECT corporate_owner.regid, r.housenumber, r.streetname, r.zip, r.boro FROM (SELECT DISTINCT unnest(regids) as regid FROM corporate_owners WHERE id = 40182) as corporate_owner JOIN registrations as r on corporate_owner.regid = r.registrationid;


SELECT id where $1 = ANY(uniqnames)

-- uniq
CREATE VIEW unique_names AS SELECT UNNEST(uniqnames), id FROM corporate_owners;

SELECT * FROM (SELECT UNNEST(uniqnames) as corpname, id FROM corporate_owners) as x WHERE x.corpname ilike '%gotham%'

