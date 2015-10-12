// a small node program to extract the a JSON of corporate owners from postgres
// edit the pg contection details, query, and fileName as needed.

var fs = require('fs');
var pg = require('pg');

var conString = "postgres://mrbuttons@localhost/hpd";

var client = new pg.Client(conString);

var query = 'SELECT businesshousenumber as h, businessstreetname as st, businesszip as zip, numberofcontacts as num, id FROM corporate_owners ORDER BY numberofcontacts DESC LIMIT 500';

var fileName = 'top500.txt';

client.connect(function(err) {
  if(err) {
    return console.error('could not connect to postgres', err);
  }
  client.query(query, function(err, result) {
    if(err) {
      return console.error('error running query', err);
    }
    
    var wrapped_data = {
      data:  result.rows
    };
    
    fs.writeFile(fileName, JSON.stringify(wrapped_data), function (err) {
      if (err) throw err;
      console.log('top500.txt  saved!');
      client.end();
    });
        
  });
});

