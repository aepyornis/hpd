var s = require('./server');
var should = require('should');


describe('get_corporate_names', function(){
  it('returns correct names for 65798', function(done){
    s.get_corporate_names(65798, function(result){
      result.rows[0].uniqnames[0].should.eql('ENY DEVELOPMENT LLC');
      done();
    });
  });
});

describe('get_regid_for_address', function(){
  it('returns correct ID for 40 park avenue', function(done){
    //this.timeout(5000);
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
  it('should return correct info', function(done){
    s.get_corporate_owner_info_for_regid(112823, function(r){
      r.rows[0].id.should.eql(54457);
      r.rows[0].buildingcount.should.eql(19);
      r.rows[0].businesszip.should.eql('10154');
      done();
    });
  });
});

describe('parallel_query_abettor', function(){
  it('should execute two queries in parallel', function(done){
    s.parallel_query_abettor(112823, function(r){
      r.regid.should.eql(112823);
      r.corporationname.should.eql('40 PARK AVENUE LLC');
      r.buildingcount.should.eql(19);
      r.businesszip.should.eql('10154');
      r.uniqnames.length.should.eql(19);
      done();
    });
  });
});

describe('address_search', function(){
  it('should search 40 park avenue and return correct object', function(done){
    s.address_search('40 PARK AVENUE', '1', function(result){
      result.regid.should.eql(112823);
      result.corporationname.should.eql('40 PARK AVENUE LLC');
      result.buildingcount.should.eql(19);
      result.businesszip.should.eql('10154');
      result.uniqnames.length.should.eql(19);
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
    normalize('text.text').should.eql('texttext');
    normalize('t.ext.tex.t').should.eql('texttext');
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
})
