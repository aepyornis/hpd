# HPD corporate-owner Geocoder

use: ``` python geocode.py file/to/geocode ```

This uses the Geoclient API, which requires you to have an API ID and APP KEY. geocode.py reads those values from these environment variables:

  * GEOCLIENT_APP_ID
  * GEOCLIENT_APP_KEY

The first four columns of file must be:

  * ID
  * house number
  * street
  * zipcode

It uses '|' as a delimiter.

You can extract the data from postgres with query like such:

``` sql
SELECT id, BusinessHouseNumber,BusinessStreetName,BusinessZip, businessapartment, array_length(uniqregids,1) as c FROM hpd.corporate_owners ORDER BY c DESC LIMIT 2000
```

See geocode.sh for a way to geocode the entire batch. A lot of address will not geocode, which is okay. Some of them are not NYC addresses.

NYC geocoding functionality is brought to you by this very convenient library by: [nyc-geoclient](https://github.com/talos/nyc-geoclient). For information about that library's license info see the github page or hpd/geocode/nyc_geoclient/LICENSE.txt

