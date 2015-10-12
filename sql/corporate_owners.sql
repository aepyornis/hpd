BEGIN;


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
                GROUP BY BusinessHouseNumber, BusinessStreetName, BusinessZip, BusinessApartment);

ALTER TABLE corporate_owners ADD COLUMN id serial;

UPDATE corporate_owners SET id = DEFAULT;

ALTER TABLE corporate_owners ADD PRIMARY KEY (id);

COMMIT;
