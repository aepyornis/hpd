#!/bin/bash

createdb hpd

psql -d hpd -f 'sql/schema.sql'

# cleanup contact addresses:
psql -d hpd -f 'sql/address_cleanup.sql'

# add fucntion anyarray_uniq()
psql -d hpd -f 'sql/anyarray_uniq.sql'

# create corporate_owners table
psql -d hpd -f 'sql/corporate_owners.sql'

# index
psql -d hpd -f 'sql/index.sql'

