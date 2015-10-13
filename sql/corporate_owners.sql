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

ALTER TABLE corporate_owners ADD COLUMN uniqnames text[];

UPDATE corporate_owners SET uniqnames = corporationnames;

-- there appears to be at least row that causes an error with anyarray_unique, which is 'fixed' by the WHERE clause here.
UPDATE corporate_owners SET uniqnames = anyarray_uniq(corporationnames) WHERE array_length(corporationnames, 1) > 0;

COMMIT;
