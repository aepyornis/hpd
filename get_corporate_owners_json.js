// a small node program to extract the a JSON of corporate owners from postgres. Read as static file by server.js
// edit the pg connection details, query, and fileName as needed.
var fs = require('fs');
var pg = require('pg');
var config = require('./config');

if (process.env.OPENSHIFT_POSTGRESQL_DB_URL) {
  var conString = process.env.OPENSHIFT_POSTGRESQL_DB_URL + "/hpd";
} else {
  var conString = "postgres://" + config.pg.user + ":" + config.pg.password +"@localhost/" + config.pg.database;
}

var client = new pg.Client(conString);

// a= address
// zip = zip code
// num = number of contacts
// id = id
// nc = uniq names count

// the query counts all 'garden complex' ids..
//var query = "SELECT businesshousenumber || ' ' || businessstreetname as a, businesszip as zip, numberofcontacts as num, id, array_length(uniqnames, 1) as nc FROM corporate_owners ORDER BY numberofcontacts DESC LIMIT 500";

// this treats garden complexes as a single one. 
var query = "SELECT businesshousenumber || ' ' || businessstreetname as a, businesszip as zip, array_length(anyarray_uniq(regids), 1) as num, id, array_length(uniqnames, 1) as nc FROM hpd.corporate_owners ORDER BY num DESC LIMIT 500";

//var geocode_query = "SELECT businesshousenumber as house, businessstreetname as street, businesszip as zip, array_length(anyarray_uniq(regids), 1) as num, id, array_length(uniqnames, 1) as nc FROM corporate_owners ORDER BY num DESC LIMIT 500";

var fileName =  __dirname + '/html/data/top500.txt';

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
