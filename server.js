var restify = require('restify');
var fs = require('fs');
var pg = require('pg');
var async = require('async');
var _ = require('lodash');

// db settings
  pg.defaults.database =  'hpd';
  pg.defaults.host = process.env.OPENSHIFT_POSTGRESQL_DB_HOST || 'localhost';
  pg.defaults.user = process.env.OPENSHIFT_POSTGRESQL_DB_USERNAME || 'mrbuttons';
  pg.defaults.password = process.env.OPENSHIFT_POSTGRESQL_DB_PASSWORD || 'mrbuttons';
  if (process.env.OPENSHIFT_POSTGRESQL_DB_PORT) {
    pg.defaults.port = process.env.OPENSHIFT_POSTGRESQL_DB_PORT;
  }
// server settings
var server_port = process.env.OPENSHIFT_NODEJS_PORT || '8080';
var server_ip_address = process.env.OPENSHIFT_NODEJS_IP || 'localhost';

var server = restify.createServer({
  name: 'Inside-HPD-Data'
});

server.listen(server_port, server_ip_address);

// this functions runs for all requests
server.use(function(req, res, next){
  return next();
});

///////////
//routes//
/////////
 
// search by corporation name
server.get('/corplookup/:name', function(req, res, next){
  corporate_name_search(req.params.name, function(result){
    //console.log(result);
    res.send(result.rows[0]);
    next();
  });
});

// search by property address
server.get('/address/:bor/:add', function(req, res, next){
  address_search(req.params.add, req.params.bor, function(result){
    res.send(result);
    next();
  });
});

// corporate_owners names by corporate_owners id
server.get('/id/corpnames/:id', function(req, res, next){
  //console.log('request for: ' + req.params.id);
  get_corporate_names(req.params.id, function(result){
    res.send(result.rows[0].uniqnames);
    next();
  });
});

// list of buildings of corporate_owners by corporate_owners id
server.get('/id/buildings/:id', function(req, res, next){
  get_buildings_by_id(req.params.id, function(result){
    res.send(result.rows);
    next();
  });
});

// get lat/lng of corporate_owner by id
server.get('/id/latlng/:id', function(req,res,next){
  get_corporate_owner_lat_lng(req.paramns.id, function(result){
    res.send(result.rows[0]);
    next();
  });
});

//serves static files from html folder
server.get(/.*/, restify.serveStatic({
    'directory': __dirname + '/html',
  'default': 'index.html'
}));

//////////////
//FUNCTIONS//
////////////

function get_buildings_latlng(id, callback){
  var query = 'SELECT r. lat, r. lng FROM (select unnest (regids) as regid from corporate_owners where id = $1) as x JOIN registrations as r on r. registrationid = x. regid WHERE r. lat IS NOT NULL';
  var a =[];
  a.push(id);
  do_query(query, a, callback);
}


function get_corporate_owner_lat_lng (id, callback) {
  var query = "SELECT lat, lng FROM corporate_owners WHERE id = $1";
  var a = [];
  a.push(Number(id));
  do_query(query, a, callback);
}

// not currently used -- static file read instead
function retrive_corporate_owners_json(fileName, callback) {
  fs.readFile(fileName, 'utf8', function(err, data){
    if (err) throw Error;
    callback(JSON.parse(data));
  });
}

function get_corporate_names(id, callback) {
  var query = "SELECT uniqnames FROM corporate_owners WHERE id=$1";
  var a = [];
  a.push(Number(id));
  do_query(query, a, callback);
}

function get_buildings_by_id(id, callback) {
  var query = "SELECT corporate_owner.regid as regid, r.housenumber as h, r.streetname as st, r.zip as zip, r.boro as b, r.lat as lat, r.lng as lng, r.bbl as bbl, corporationname as corp FROM (SELECT  DISTINCT unnest(regids) as regid FROM corporate_owners WHERE id = $1) as corporate_owner JOIN (SELECT * FROM contacts WHERE registrationcontacttype = 'CorporateOwner') as c on corporate_owner.regid = c.registrationid JOIN registrations_grouped_by_bbl as r on corporate_owner.regid = r.registrationid";
  var a = [];
  a.push(Number(id));
  do_query(query, a, callback);
}

// change from ILIKE to fullcaps?
function corporate_name_search(name, callback) {
  var query = "SELECT id FROM corporate_owners where $1 ILIKE ANY(uniqnames)";
  var a = [];
  var prepared_name = '%' + name + '%';
  a.push(prepared_name);
  do_query(query, a, callback);
}

//address search

//this object is what's passed to the callback of address_search
/*
{
  regid: 12324,
  corporationname: 'blah LLC',
  ownerID: 444,
  buildingcount: number
  uniqnames: [text],
  businesshousenumber: '345'
  businessstreetname: 'PARK Ave'
  businesszip: '10101',
  status: "ok"
}
*/

function address_search(address, bor, callback) {
  // parse the address
  var add = /(\d+(?:-\d+)?)[ ](.+)/.exec(address);
  var house = add[1];
  var street = normalize_street_name(add[2]);
  
  //this is an async query that returns with the regid for the address searched
  get_regid_for_address(house, street, bor, function(pgdata){
    if (pgdata.rowCount === 0) {
      //handle address not in database
      var error_message = {'regid': 'error', 'message': 'No address found in database', 'status': 'No registration'};
      callback(error_message);
    } else {
      var regid = pgdata.rows[0].regid;
      parallel_query_abettor(regid, callback);
    }
  });
}
  
// do two SQL queries in parallel, searching the contacts table for the corporation_name and retrieving info from the corporate_owners table
function parallel_query_abettor(regid, whendone) {
  async.parallel([
    function corpname(callback) {
      get_corporation_name_for_regid(regid, function(pgdata){
        if (pgdata.rowCount === 0) {
          callback(null, null);
        } else {
          callback(null, pgdata.rows[0]);
        }
         
      });
    },
    function corpinfo(callback) {
      get_corporate_owner_info_for_regid(regid, function(pgdata){
        if (pgdata.rowCount === 0) {
          callback(null, null);
        } else {
          callback(null, pgdata.rows[0]);
        }
      });
    }
  ],
  // Results is an array from the data passed to it from the callback of each parallel function. In our case, it's two objects returned to us from postgres. We combine the two objects and then have parallel_query_abettor return the object in the whendone callback.
   function(err, results) {
     // if there is a registration but no 'corporate owner', query returns blank
     if (results[0] === null || results[1] === null) {
       whendone({
         'regid': regid,
         'status': 'No corporate owner'
       });
     } else {
       whendone(_.extend(results[0], results[1], {'regid': regid, 'status': 'ok'}));
     }
    
   });
}
  
// parse street name
function normalize_street_name(street) {
  //remove periods
  var normalized = street
        .toUpperCase()
        .replace(/\./g,'')
        .replace(/ (?:LA|LN)( (?:S|N|E|W).*)?$/g, ' LANE$1')
        .replace(/ PL( (?:S|N|E|W).*)?$/g, ' PLACE$1')
        .replace(/ (?:ST|STR)( (?:S|N|E|W).*)?$/g, ' STREET$1')
        .replace(/ RD( (?:S|N|E|W).*)?$/g, ' ROAD$1')
        .replace(/ PKWY( (?:S|N|E|W).*)?$/g, ' PARKWAY$1')
        .replace(/ BLVD( (?:S|N|E|W).*)?$/g, ' BOULEVARD$1')
        .replace(/ AVE( (?:S|N|E|W).*)?$/g, ' AVENUE$1')
        .replace(/ BCH /g, ' BEACH ')
        .replace(/^(.+ )S$/, '$1SOUTH')
        .replace(/^(.+ )E$/, '$1EAST')
        .replace(/^(.+ )N$/, '$1NORTH')
        .replace(/^(.+ )W$/, '$1WEST')
        .replace(/(\d+)(?:TH|RD|ND|ST)( .+)/g, '$1$2');
  return normalized;
}

// address search queries
// input: strings
function get_regid_for_address(house, street, bor, callback) {
  var query = "SELECT registrationid as regid from registrations where housenumber = $1 AND streetname = $2 AND boroid = $3";
  var values = [house, street, bor];
  do_query(query, values, callback);
  // regid is available at result.rows[0].regid
}

function get_corporation_name_for_regid(regid, callback){
  var query = "select corporationname from contacts where registrationcontacttype = 'CorporateOwner' and registrationid = $1";
  var values = [regid];
  do_query(query, values, callback);
}

function get_corporate_owner_info_for_regid(regid, callback) {
  var query = "SELECT id,  array_length(anyarray_uniq(regids), 1) as buildingcount, uniqnames, businesshousenumber, businessstreetname, businesszip FROM corporate_owners WHERE $1 = ANY(regids)";
  do_query(query, [regid], callback);
}

// POSTGRES QUERY
// input: string, array, callback
function do_query(sql, params, callback) {
  pg.connect(function(err, client, done){
    if(err) {
      return console.error('error fetching client from pool', err);
    }
    client.query(sql, params, function(err, result){
      if (err){
        console.error('query error', err);
        callback(null);
      } else {
        //callback with results
        callback(result);
      }
      done();
    });
  });
}

// exports for testing

module.exports = {
  address_search: address_search,
  parallel_query_abettor: parallel_query_abettor,
  get_regid_for_address: get_regid_for_address,
  get_corporation_name_for_regid: get_corporation_name_for_regid,
  get_corporate_owner_info_for_regid: get_corporate_owner_info_for_regid,
  get_corporate_names: get_corporate_names,
  normalize_street_name: normalize_street_name
};


