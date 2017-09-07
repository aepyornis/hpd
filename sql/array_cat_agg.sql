--  see: https://stackoverflow.com/questions/22677463/how-to-merge-all-integer-arrays-from-all-records-into-single-array-in-postgres/22677955#22677955
DROP AGGREGATE IF EXISTS array_cat_agg(anyarray);
CREATE AGGREGATE array_cat_agg(anyarray) (
  SFUNC=array_cat,
  STYPE=anyarray
);
