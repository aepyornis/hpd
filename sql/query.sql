--how many "unique" contacts
select count(DISTINCT registrationcontactId) from contacts;
-- rank in order
select  registrationcontactID, count( registrationcontactID ) as c FROM contacts GROUP BY  registrationcontactID ORDER BY c DESC;

-- group by address
select BusinessHouseNumber as house, BusinessStreetName as street, count(*) as count FROM contacts GROUP BY BusinessHouseNumber, BusinessStreetName ORDER BY count DESC;

select * from contacts where businesshousenumber = '1735' AND businessStreetname = 'PARK AVE';

select * from contacts where businesshousenumber = '594' AND businessStreetname = 'BROADWAY';
