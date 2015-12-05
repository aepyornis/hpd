
#!/bin/bash

# data fold can be downloaded here: https://drive.google.com/file/d/0BxVeQ41wSvbuS2I1SENqYkVyX3c/view?usp=sharing

# create the database if needed
# createdb hpd
set -e

# file paths will need to be changed in schema.sql, google_geocode.sql, and registrations_geocode.sql  

printf 'create table and COPY data'
psql -d hpd -f 'sql/schema.sql'
wd=${PWD##*/} 

if [ ! -f registrations.zip ]; then
	printf 'Downloading data'
	wget -O registrations.zip http://www1.nyc.gov/assets/hpd/downloads/misc/Registrations20151201.zip
fi
if [ ! -f Registration20151130.txt ]; then
	unzip registrations.zip
fi

# printf 'Cleaning data files'
# sed -i '' 's/\"//g' RegistrationContact20151130.txt

printf 'Inserting data'
psql -d hpd -c "COPY hpd.registrations FROM '$(pwd)/Registration20151130.txt' (DELIMITER '|', FORMAT CSV, HEADER TRUE);"
psql -d hpd -c "COPY hpd.contacts FROM '$(pwd)/contacts.txt' (DELIMITER '|', FORMAT CSV, HEADER TRUE);"
psql -d hpd -c "COPY hpd.bbl_lookup FROM '$(pwd)/bbl_lat_lng.txt' (FORMAT CSV,  HEADER TRUE);"

# printf 'cleanup contact addresses'
# psql -d hpd -f 'sql/address_cleanup.sql'

# printf 'cleanup registration addresses'
# psql -d hpd -f 'sql/registrations_clean_up.sql'

printf 'Add function anyarray_uniq()'
psql -d hpd -f 'sql/anyarray_uniq.sql'

printf 'Add function anyarray_remove_null'
psql -d hpd -f 'sql/anyarray_remove_null.sql'

printf 'Add aggregate functions first() and last()'
psql -d hpd -f 'sql/first_last.sql'

printf 'Creating corporate_owners table'
psql -d hpd -f 'sql/corporate_owners.sql'

printf 'Geocodes corporate_owners'
psql -d hpd -f 'sql/google_geocode.sql'

printf 'Geocodes registrations via pluto'
psql -d hpd -f 'sql/registrations_geocode.sql'

printf 'Creating view registrations_grouped_by_bbl'
psql -d hpd -f 'sql/registrations_grouped_by_bbl.sql'

printf 'Indexing tables'
psql -d hpd -f 'sql/index.sql'

printf 'Creating top500.txt file'
mkdir -p html/data
node get_corporate_owners_json.js 

