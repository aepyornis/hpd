create index on hpd.corporate_owners(numberofcontacts desc);

create index on hpd.contacts(registrationcontacttype);
create index on hpd.contacts(registrationid);
create index on hpd.contacts(registrationid) WHERE  registrationcontacttype = 'CorporateOwner';

create index on hpd.registrations(registrationid);
create index on hpd.registrations(lat);
create index on hpd.registrations(registrationid) where lat IS NOT NULL;
