DROP FUNCTION IF EXISTS get_corporate_owner_info_for_regid(int);

CREATE OR REPLACE FUNCTION get_corporate_owner_info_for_regid(regid int)
RETURNS TABLE (id int, buildingscount int, uniqnames text[], businesshousenumber text, businessstreetname text, businesszip text) AS $$
      SELECT id,
      	     array_length(anyarray_uniq(regids), 1) as buildingcount,
	     uniqnames,
	     businesshousenumber,
	     businessstreetname,
	     businesszip
      FROM hpd_corporate_owners WHERE get_corporate_owner_info_for_regid.regid = ANY(regids)
$$ LANGUAGE SQL;

-- Returns address info from an array of regids, which are supplied as a
-- comma delineated string
-- NOTE: now using combined_search.sql to populated the addr info from the regid instead
DROP FUNCTION IF EXISTS get_addrs_from_regids(text);

CREATE OR REPLACE FUNCTION get_addrs_from_regids(_regids text)
RETURNS TABLE (
  housenumber text,
  streetname text,
  boro text,
  zip text,
  lat numeric,
  lng numeric,
  regid int,
  bbl text,
  corpnames text[],
  ownernames json
) AS $$
  SELECT
    housenumber,
    streetname,
    boro,
    zip,
    lat,
    lng,
    regid,
    bbl,
    corpnames,
    ownernames
  FROM hpd_registrations_grouped_by_bbl_with_contacts AS r
  INNER JOIN (
    SELECT unnest(string_to_array(_regids, ','))::int AS regid
  ) regids ON (r.registrationid = regids.regid)
$$ LANGUAGE SQL;
