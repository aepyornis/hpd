create index on hpd_corporate_owners(numberofcontacts desc);

create index on hpd_contacts(registrationcontacttype);
create index on hpd_contacts(registrationid);
create index on hpd_contacts(registrationid) WHERE  registrationcontacttype = 'CorporateOwner';

create index on hpd_registrations(registrationid);
create index on hpd_registrations(lat);
create index on hpd_registrations(registrationid) where lat IS NOT NULL;
