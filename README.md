# HPD 

Displays the top 'corporate owners' in the HPD building registration database

[Click here to see it online](https://hpd.ziggy.space/)

The data for this website was retrieved from: [HPD open data](http://www1.nyc.gov/site/hpd/about/open-data.page)

To setup database run or modify: setup.sh

## Setup

On OSX & linux:

Start up Postgres.

Rename config.sample.js to config.js and fill it in with your postgres connection information. 

```
npm install

bash setup.sh
```

#### LICENSE: GPLv3

HPD - Corporate Landlords Hidden In HPD Data
Copyright (C) 2015-2016  Ziggy Mintz

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
