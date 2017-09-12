-- http://blog.scoutapp.com/articles/2016/07/12/how-to-make-text-searches-in-postgresql-faster-with-trigram-similarity
-- http://www.postgresonline.com/journal/archives/169-Fuzzy-string-matching-with-Trigram-and-Trigraphs.html

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS people_last_name_idx ON hpd_contacts USING GIN(lastname gin_trgm_ops);
CREATE INDEX IF NOT EXISTS people_first_name_idx ON hpd_contacts USING GIN(firstname gin_trgm_ops);


-- This should be fairly self-explanatory. Provide name, use triagram lookup to get assoc. regids
DROP FUNCTION IF EXISTS get_regids_from_name(text, text);

CREATE OR REPLACE FUNCTION get_regids_from_name(_firstname text, _lastname text)
RETURNS TABLE (
  uniqregids integer[]
) AS $$
  SELECT
    array_agg(q.registrationid) as uniqregids
  FROM (
    SELECT DISTINCT ON (registrationid) registrationid FROM hpd_contacts
    WHERE firstname % _firstname AND similarity(firstname, _firstname) > 0.5 
      AND lastname % _lastname AND similarity(lastname, _lastname) > 0.5
  ) AS q;
$$ LANGUAGE SQL;


-- Given a registrationid, return associated properties from the names of CorporateOwners, HeadOfficers, and IndividualOwners
-- The reason we include CorporateOwner is that sometimes they'll register a person name, this is useful
DROP FUNCTION IF EXISTS get_regids_from_regid_by_owners(integer);

CREATE OR REPLACE FUNCTION get_regids_from_regid_by_owners(_regid integer)
RETURNS TABLE (
  uniqregids integer[]
) AS $$
  SELECT
    anyarray_uniq(array_cat_agg(q.uniqregids)) as uniqregids
  FROM (
    SELECT c.firstname, c.lastname, f.uniqregids
    FROM hpd_contacts c,
    LATERAL get_regids_from_name(c.firstname, c.lastname) f
    WHERE c.registrationid = _regid AND
    firstname IS NOT NULL and lastname IS NOT NULL AND
    (c.registrationcontacttype = 'CorporateOwner' OR c.registrationcontacttype = 'HeadOfficer' OR c.registrationcontacttype = 'IndividualOwner')
  ) AS q;
$$ LANGUAGE SQL;
