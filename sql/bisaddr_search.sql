-- Given a regid, cross reference with uniqregid fields in the business_address table
DROP FUNCTION IF EXISTS get_regids_from_regid_by_bisaddr(integer);

CREATE OR REPLACE FUNCTION get_regids_from_regid_by_bisaddr(_regid integer)
RETURNS TABLE (
  uniqregids integer[]
) AS $$
  SELECT
    anyarray_uniq(array_cat_agg(q.uniqregids)) as uniqregids
  FROM (
    SELECT rbas.uniqregids
    FROM hpd_business_addresses AS rbas
    WHERE _regid = any(rbas.uniqregids)
  ) AS q;
$$ LANGUAGE SQL;
