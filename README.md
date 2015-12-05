# HPD 

Displays the top 'corporate owners' in the HPD building registration database

[Click here to see it online](https://hpd-elephantbird.rhcloud.com/)

The data for this website was retrieved from: [HPD open data](http://www1.nyc.gov/site/hpd/about/open-data.page)

To setup database run or modify: setup.sh

## Setup

```brew install pgql
npm install
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
bash setup.sh```




