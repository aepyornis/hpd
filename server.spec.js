'use strict';

const s = require('./server');
const should = require('should');


describe('get_corporate_names', function(){
  let sampleID = 50000;

  it('returns only one row', (done) => {
    s.get_corporate_names(sampleID, (r) => {
      r.rows.should.have.lengthOf(1);
      done();
    });
  });  

  it('contains an array of strings', done => {
    s.get_corporate_names(sampleID, (r) => {
      r.rows[0].uniqnames.should.be.an.Array();
      r.rows[0].uniqnames.length.should.be.aboveOrEqual(1);
      r.rows[0].uniqnames.forEach(name => name.should.be.a.String());
      done();
    });
  });
});

describe('get_regid_for_address', function(){
  it('returns correct ID for 40 park avenue', function(done){
    s.get_regid_for_address('40', 'PARK AVENUE', '1', function(result){
      result.rows[0].regid.should.eql(112823);
      done();
    });
  });
});

describe('get_corporation_name_for_regid', function(){
  it('should return correct corpoation name', function(done){
    s.get_corporation_name_for_regid(112823, function(r){
      r.rows[0].corporationname.should.eql('40 PARK AVENUE LLC');
      done();
    });
  });
});

describe('get_corporate_owner_info_for_regid', function(){
  it('returns result with correct shape', done => {
    s.get_corporate_owner_info_for_regid(112823, r => {
      r.rows[0].id.should.be.a.Number();
      r.rows[0].buildingcount.should.aboveOrEqual(1);
      r.rows[0].businesszip.should.be.a.String();
      r.rows[0].businesszip.length.should.eql(5);
      done();
    });
  });
  
});

describe('parallel_query_abettor', function(){
  it('should execute two queries in parallel', done => {
    s.parallel_query_abettor(112823, r => {
      r.regid.should.eql(112823);
      r.corporationname.should.be.a.String();
      r.buildingcount.should.aboveOrEqual(1);
      r.businesszip.should.have.lengthOf(5);
      r.uniqnames.should.be.an.Array();
      r.status.should.eql('ok');
      done();
    });
  });
  it('returns error json if invald regid', done => {
    s.parallel_query_abettor(1, r => {
      r.regid.should.eql(1);
      r.status.should.eql('No corporate owner');
      done();
    });
  });
});

describe('address_search', function(){
  it('return object with correct type of data', function(done){
    s.address_search('40 PARK AVENUE', '1', function(result){
      result.regid.should.be.a.Number();
      result.id.should.be.a.Number();
      result.corporationname.should.be.a.String();
      result.buildingcount.should.aboveOrEqual(1);
      result.businesszip.length.should.eql(5);
      result.uniqnames.should.be.an.Array();
      result.businesshousenumber.should.be.a.String();
      result.businessstreetname.should.be.a.String();
      result.status.should.eql('ok');
      done();
    });
  });

  it('returns error message for address not in db', done => {
    s.address_search('NOT REAL', '1', r => {
      r.regid.should.eql('error');
      r.status.should.eql('No registration');
      done();
    });
  });
});

describe('normalize street name', function(){
  var normalize = s.normalize_street_name;
  it('la, ln to lane', function(){
    normalize('BROWN LA S').should.eql('BROWN LANE SOUTH');
    normalize('ANY LN').should.eql('ANY LANE');
  });
  it('pl to place', function(){
    normalize('MY PL').should.eql('MY PLACE');
  });
  it('ST STR to street', function(){
    normalize('44 ST').should.eql('44 STREET');
  });
  it('rd to ROAD', function(){
    normalize('A REALLY GREAT RD').should.eql('A REALLY GREAT ROAD');
  });
  it('prk, blvd, bch', function(){
    normalize('EASTERN PKWY').should.eql('EASTERN PARKWAY');
    normalize('ROCKAWAY BCH BLVD').should.eql('ROCKAWAY BEACH BOULEVARD');
  });
  it('directions', function(){
    normalize('NICE LANE E').should.eql('NICE LANE EAST');
    normalize('NICE LANE S').should.eql('NICE LANE SOUTH');
    normalize('NICE LANE W').should.eql('NICE LANE WEST');
    normalize('NICE LANE N').should.eql('NICE LANE NORTH');
  });
  it('no more periods', function(){
    normalize('text.text').should.eql('TEXTTEXT');
    normalize('t.ext.tex.t').should.eql('TEXTTEXT');
  });
  it('ave to AVENUE', function(){
    normalize('1 AVE').should.eql('1 AVENUE');
  });
  it('removes TH RD ND ST', function(){
    normalize('1ST RD').should.eql('1 ROAD');
    normalize('2ND RD').should.eql('2 ROAD');
    normalize('3RD RD').should.eql('3 ROAD');
    normalize('4TH RD').should.eql('4 ROAD');
  });
  it('works on whole examples', function(){
    normalize('33RD ST. S').should.eql('33 STREET SOUTH');
    normalize('1ST RD').should.eql('1 ROAD');
  });  
});
