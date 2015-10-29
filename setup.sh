#!/bin/bash

# create the database if needed
# createdb hpd

# file paths will need to be changed in schema.sql, google_geocode.sql, and registrations_geocode.sql  

# create table and COPY data
psql -d hpd -f 'sql/schema.sql'

# cleanup contact addresses:
psql -d hpd -f 'sql/address_cleanup.sql'

# add function anyarray_uniq()
psql -d hpd -f 'sql/anyarray_uniq.sql'

# add function anyarray_remove_null
psql -d hpd -f 'sql/anyarray_remove_null.sql'

# adds aggregate functions first() and last()
psql -d hpd -f 'sql/first_last.sql'

# create corporate_owners table
psql -d hpd -f 'sql/corporate_owners.sql'

# geocodes corporate_owners
psql -d hpd -f 'sql/google_geocode.sql'

# geocodes registrations via pluto
psql -d hpd -f 'sql/registrations_geocode.sql'

# creates view registrations_grouped_by_bbl
psql -d hpd -f 'registrations_grouped_by_bbl.sql'

# index
psql -d hpd -f 'sql/index.sql'

# create top500.txt file
mkdir html/data
node get_corporate_owners_json.js 
