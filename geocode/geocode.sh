#!/bin/bash

psql -d hpd -c \
     "SELECT id, BusinessHouseNumber,BusinessStreetName,BusinessZip, businessapartment, array_length(uniqregids,1) as c FROM hpd.corporate_owners ORDER BY c DESC;" \
     --no-align -t  > corporate_owners.csv

split corporate_owners.csv

for file in $(ls x*); do
    python geocode.py ${file}
done


