from nyc_geoclient import Geoclient
import os
import subprocess

APP_ID = os.environ['GEOCLIENT_APP_ID']
APP_KEY = os.environ['GEOCLIENT_APP_KEY']

p = subprocess.Popen('psql -d hpd -c "SELECT id, BusinessHouseNumber,BusinessStreetName,BusinessZip FROM hpd.corporate_owners" --no-align -t > corporate_owners.csv', shell=True)

p.wait()

# g = Geoclient(APP_ID, APP_KEY)
