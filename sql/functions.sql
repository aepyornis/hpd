DROP FUNCTION IF EXISTS get_corporate_owner_info_for_regid(int);

CREATE OR REPLACE FUNCTION get_corporate_owner_info_for_regid(int)
RETURNS TABLE (id int, buildingscount int, uniqnames text[], businesshousenumber text, businessstreetname text, businesszip text) AS $$
      SELECT id,
      	     array_length(anyarray_uniq(regids), 1) as buildingcount,
	     uniqnames,
	     businesshousenumber,
	     businessstreetname,
	     businesszip
      FROM hpd_corporate_owners WHERE $1 = ANY(regids)
$$ LANGUAGE SQL;
