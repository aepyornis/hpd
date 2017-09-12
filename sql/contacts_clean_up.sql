-- Various things to clean up hpd contacts craziness

-- For some reason there are a lot of #'s instead of names
UPDATE hpd_contacts SET firstname = regexp_replace(firstname, '#', '', 'g');
UPDATE hpd_contacts SET lastname = regexp_replace(lastname, '#', '', 'g');
