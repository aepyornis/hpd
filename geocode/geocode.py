"""
Geocodes HPD corporate owner addresses using the NYC geoclient API
Copyright (C) 2016 Ziggy Mintz

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""
from nyc_geoclient import Geoclient
import os
import sys
import csv
import time

GEOCODE_FILE = sys.argv[1]

APP_ID = os.environ['GEOCLIENT_APP_ID']
APP_KEY = os.environ['GEOCLIENT_APP_KEY']


g = Geoclient(APP_ID, APP_KEY)

ERRORS = 0
PROCESSED = 0

def geocode():
    with open(GEOCODE_FILE + '-geocoded.csv', 'a') as geocode_file:
        writer = csv.writer(geocode_file, delimiter="|")
        with open(GEOCODE_FILE, 'r') as f:
            csv_file = csv.reader(f, delimiter="|")
            for row in csv_file:
                id = row[0]
                house_number = row[1]
                street = row[2]
                zipcode = row[3]
                info = g.address_zip(house_number, street, zipcode)
                try:
                    bbl = info['bbl']
                    xcoord = info['xCoordinate']
                    ycoord = info['yCoordinate']
                    council_district = info['cityCouncilDistrict']
                    community_district = info['communityDistrict']
                    writer.writerow(row + [bbl, xcoord, ycoord, council_district, community_district])
                except KeyError as e:
                    global ERRORS
                    ERRORS += 1
                    try:
                        print("error: " + str(house_number) + " " + str(street) + " - " + info['message'])
                    except KeyError as e:
                        print('A key error occurred with this dictionary:')
                        print(info)
                finally:
                    global PROCESSED
                    PROCESSED += 1
                    if PROCESSED % 25 == 0:
                        time.sleep(5)

try:
    geocode()
    print("A total of " + str(PROCESSED) + " addresses were processed.")
    print("there were " + str(ERRORS) + " addresses that did not geocode")
except Exception:
    print('something went wrong with ' + GEOCODE_FILE)
    raise
