BEGIN;

ALTER TABLE corporate_owners ADD COLUMN formatted_address text;
ALTER TABLE corporate_owners ADD COLUMN lat numeric;
ALTER TABLE corporate_owners ADD COLUMN lng numeric;

COMMIT;
