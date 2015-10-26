// a small node program to extract the a JSON of corporate owners from postgres
// edit the pg contection details, query, and fileName as needed.

var fs = require('fs');
var pg = require('pg');

var conString = "postgres://mrbuttons@localhost/hpd";

var client = new pg.Client(conString);

// a= address
// zip = zip code
// num = number of contacts
// id = id
// nc = uniq names count
// the query counts all 'garden complex' ids..
//var query = "SELECT businesshousenumber || ' ' || businessstreetname as a, businesszip as zip, numberofcontacts as num, id, array_length(uniqnames, 1) as nc FROM corporate_owners ORDER BY numberofcontacts DESC LIMIT 500";

var query = "SELECT businesshousenumber || ' ' || businessstreetname as a, businesszip as zip, array_length(anyarray_uniq(regids), 1) as num, id, array_length(uniqnames, 1) as nc FROM corporate_owners ORDER BY num DESC LIMIT 500";

var fileName = 'html/data/top500.txt';

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
      console.log(fileName + ' saved!');
      client.end();
    });
        
  });
});

