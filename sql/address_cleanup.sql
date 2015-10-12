-- BusinessStreetName

-- Fix avenue

--SELECT BusinessStreetName, regexp_replace( BusinessStreetName, ' AVE$|-AVE$| -AVE$', ' AVENUE') as fixed FROM contacts WHERE BusinessStreetName ~ ' AVE$|-AVE$| -AVE$'

UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, ' AVE$|-AVE$| -AVE$', ' AVENUE') WHERE BusinessStreetName ~ '.*(AVE$|-AVE$| -AVE$)';

-- The Saints Come Matching
--regexp_replace( BusinessStreetName, '^ST.? ', 'SAINT ', 'g')

--SELECT BusinessStreetName,regexp_replace( BusinessStreetName, '^ST.? ', 'SAINT ', 'g') as fixed FROM contacts WHERE BusinessStreetName ~  '^ST.? .*'

UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, '^ST.? ', 'SAINT ', 'g') WHERE BusinessStreetName ~  '^ST.? .*';

-- remove periods

UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, '\.', '', 'g');

-- remove TH ST RD ND

--SELECT businessStreetName, array_to_string(regexp_matches(BusinessStreetName, '(.*)(\d+)(?:TH|RD|ND|ST)( .+)'), '') as fixed FROM contacts WHERE BusinessStreetName ~ '.*(\d+)(?:TH|RD|ND|ST)( .+).*'

UPDATE contacts SET BusinessStreetName = array_to_string(regexp_matches(BusinessStreetName, '(.*)(\d+)(?:TH|RD|ND|ST)( .+)'), '') WHERE BusinessStreetName ~ '.*(\d+)(?:TH|RD|ND|ST)( .+).*';

-- LANE, STREET, ROAD, PARKWAY, BOULEVARD, PLACE, BEACH

UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, ' LA$', ' LANE', 'g');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, ' LN$', ' LANE', 'g');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, ' PL$', ' PLACE', 'g');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, ' ST$| STR$', ' STREET', 'g');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, ' RD$', ' ROAD', 'g');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, ' PKWY$', 'PARKWAY', 'g');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, ' PKWY ', ' PARKWAY ', 'g');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, ' BLVD$', ' BOULEVARD', 'g');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, ' BLVD ', ' BOULEVARD ', 'g');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, '^BCH ', 'BEACH ', 'g');

-- DIRECTIONS
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, '^E ', 'EAST ');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, '^W ', 'WEST ');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, '^N ', 'NORTH ');
UPDATE contacts SET BusinessStreetName = regexp_replace( BusinessStreetName, '^S ', 'SOUTH ');

-- BusinessApartment

-- remove underscores and periods
-- SELECT BusinessApartment, regexp_replace( BusinessApartment, '_|\.', '', 'g') as fixed FROM contacts where BusinessApartment IS NOT NULL 

UPDATE contacts SET BusinessApartment = regexp_replace( BusinessApartment, '_|\.', '', 'g');

-- remove spaces between floor
--SELECT BusinessApartment, array_to_string(regexp_matches( BusinessApartment, '(.*)(\d+)(?:TH|RD|ND|ST)?(?: ?)(FL)R?'), '') as fixed from contacts where BusinessApartment ~ '.*(\d+)(?:TH|RD|ND|ST)?(?: ?)(FL)R?.*';

UPDATE contacts SET BusinessApartment = array_to_string(regexp_matches( BusinessApartment, '(.*)(\d+)(?:TH|RD|ND|ST)?(?: ?)(FL)R?'), '') where BusinessApartment ~ '.*(\d+)(?:TH|RD|ND|ST)?(?: ?)(FL)R?.*';

-- BusinessHouseNumber
-- remove dashes or spaces. Sorry Queens!

UPDATE contacts SET BusinessHouseNumber = regexp_replace( BusinessHouseNumber, '-| ', '', 'g');
