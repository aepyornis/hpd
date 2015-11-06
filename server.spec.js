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
      r.rows[0].regids.length.should.eql(19);
      r.rows[0].businesszip.should.eql('10154');
      done();
    });
  });
});

describe('parallel_query_abettor', function(){
  this.timeout(10000);
  it('should execute two queries in parallel', function(done){
    s.parallel_query_abettor(112823, function(r){
      r.regid.should.eql(112823);
      r.corporationname.should.eql('40 PARK AVENUE LLC');
      r.regids.length.should.eql(19);
      r.businesszip.should.eql('10154');
      r.uniqnames.length.should.eql(19);
      done();
    });
  });
});
