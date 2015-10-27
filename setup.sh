#!/bin/bash

createdb hpd

psql -d hpd -f 'sql/schema.sql'

# cleanup contact addresses:
psql -d hpd -f 'sql/address_cleanup.sql'

# add fucntion anyarray_uniq()
psql -d hpd -f 'sql/anyarray_uniq.sql'

# create corporate_owners table
psql -d hpd -f 'sql/corporate_owners.sql'

# geocodes corporate_owners
psql -d hpd -f 'sql/google_geocode.sql'

# geocodes registrations via pluto
psql -d hpd -f 'sql/registrations_geocode.sql'

# index
psql -d hpd -f 'sql/index.sql'
