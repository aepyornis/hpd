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

BusinessHouseNumber: 134614
BusinessStreetName: 134348
BusinessApartment 410177,
BusinessCity: 134536,
BusinessState: 136553,
BusinessZip: 134909

all null: 133825

--
SELECT BusinessHouseNumber, BusinessStreetName, BusinessCity, count (*) as count, array_agg(CorporationName) FROM contacts WHERE (BusinessHouseNumber IS NOT NULL AND  BusinessStreetName IS NOT NULL AND  BusinessCity IS NOT NULL) GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessCity ORDER BY count desc LIMIT 500;

array_agg

COPY (SELECT BusinessHouseNumber,
BusinessStreetName,
BusinessCity, count (*) as count,
(array_length(array_agg(CorporationName), 1) - array_length(array_remove(array_agg(CorporationName), NULL),1)) as blanks,
array_remove(array_agg(CorporationName), NULL)
FROM contacts
WHERE
(BusinessHouseNumber IS NOT NULL AND BusinessStreetName IS NOT NULL AND  BusinessCity IS NOT NULL)
GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessCity
ORDER BY count desc
LIMIT 50) to '/Users/zy/code/hpd/names.csv' CSV HEADER;

SELECT BusinessHouseNumber,
       BusinessStreetName,
       BusinessCity, count (*) as count,
       (array_length(array_agg(CorporationName), 1) - array_length(array_remove(array_agg(CorporationName), NULL), 1)) as blanks,
       array_remove(array_agg(CorporationName), NULL)
FROM contacts
WHERE
        (BusinessHouseNumber IS NOT NULL AND BusinessStreetName IS NOT NULL AND  BusinessCity IS NOT NULL)
GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessCity
ORDER BY count desc
LIMIT 500;


SELECT array_length(array_agg(CorporationName), 1) as mylength, count(*) as count, BusinessStreetName FROM contacts GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessCity LIMIT 10;
