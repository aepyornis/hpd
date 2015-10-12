var restify = require('restify');
var fs = require('fs');
//var pg = require('pg');

var server = restify.createServer({
  name: 'Inside-HPD-Data'
});

server.listen(8080);

// this functions runs for all requests
server.use(function(req, res, next){
  return next();
});

var corporate_owners;
retrive_corporate_owners_json('top500.txt', function(data){
  corporate_owners = data;
});


server.get('/top500', function(req, res, next){
  res.send(corporate_owners);
  return next();
});

//serves static files from html folder
server.get(/.*/, restify.serveStatic({
  'directory': __dirname + '/html',
  'default': 'index.html'
}))


function retrive_corporate_owners_json(fileName, callback) {
  fs.readFile(fileName, 'utf8', function(err, data){
    if (err) throw Error;
    callback(data);
  });
}

