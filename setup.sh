#!/bin/bash

# createdb hpd

psql -d hpd -f 'sql/schema.sql'

# cleanup contact addresses:
psql -d hpd -f 'sql/address_cleanup.sql'

# add function anyarray_uniq()
psql -d hpd -f 'sql/anyarray_uniq.sql'

# add function anyarray_remove_null
psql -d hpd -f 'sql/anyarray_remove_null.sql'

# create corporate_owners table
psql -d hpd -f 'sql/corporate_owners.sql'

# geocodes corporate_owners
psql -d hpd -f 'sql/google_geocode.sql'

# geocodes registrations via pluto
psql -d hpd -f 'sql/registrations_geocode.sql'

# index
psql -d hpd -f 'sql/index.sql'

echo 'generating top 500 file'
node get_corporate_owners_json.js 
