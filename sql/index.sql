create index on corporate_owners(numberofcontacts desc);

create index on contacts(registrationcontacttype);
create index on contacts(registrationid);
create index on contacts(registrationid) WHERE  registrationcontacttype = 'CorporateOwner';

create index on registrations(registrationid);
create index on registrations(lat);
create index on registrations(registrationid) where lat IS NOT NULL;
