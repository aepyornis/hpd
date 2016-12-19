describe('this is a test', () => {
  it('works', () => {
    expect(true).to.eql(true);
  });
  it('fails', () => {
    expect(true).to.eql(false);
  });
});
