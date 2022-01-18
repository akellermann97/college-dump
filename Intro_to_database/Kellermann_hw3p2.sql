-- Question 1
INSERT INTO contact_info
(
    contactID, firstname, middleinitial, lastname,
    suffix_description, title_description,
    jobtitle, department, email, url, IMaddress,
    phone_number, phonetype_description,
    birthday, notes, companyname, street1,
    street2, city, state_province, zip_postalcode,
    country_region, company_url, company_phone
) VALUES 
(
    2,
    'Eli',
    'T',
    'Wallowby',
    'III',
    'Mr.',
    'Director',
    'Finance',
    'etwallowby@concor.com',
    'www.concor.com/~wallowby',
    'etwallowby',
    '505-546-3322 ext. 23',
    'work',
    '1956-03-26',
    'All meetings must be scheduled through  his assistant',
    'Concor International',
    '152 Main Street',
    '',
    'Beverly Hills',
    'CA',
    '90210-3715',
    'USA',
    'www.concor.com',
    '323-555-6115'
);

INSERT INTO contact_info
(
    contactID, firstname, middleinitial, lastname,
    suffix_description, title_description,
    jobtitle, department, email, url, IMaddress,
    phone_number, phonetype_description,
    birthday, notes, companyname, street1,
    street2, city, state_province, zip_postalcode,
    country_region, company_url, company_phone
) VALUES 
(
    3,
    'Eve',
    'C',
    'Sampson',
    '',
    'Mrs.',
    'Assistant to Finance Director',
    'Finance',
    'esampson@concor.com',
    '',
    'esampson',
    '505-546-3322 ext. 30',
    'work',
    '1972-05-11',
    'Very Helpful',
    'Concor International',
    '152 Main Street',
    '',
    'Beverly Hills',
    'CA',
    '90210-3715',
    'USA',
    'www.concor.com',
    '323-555-5000'
);
INSERT INTO contact_info
(
    contactID, firstname, middleinitial, lastname,
    suffix_description, title_description,
    jobtitle, department, email, url, IMaddress,
    phone_number, phonetype_description,
    birthday, notes, companyname, street1,
    street2, city, state_province, zip_postalcode,
    country_region, company_url, company_phone
) VALUES 
(
    4,
    'Carson',
    'B',
    'Campbell',
    'III',
    'Dr.',
    'Chief of Medicine',
    'Geriatrics',
    'cbc232@mvch.org',
    '',
    '',
    '585-222-2121',
    'Home',
    '1955-01-05',
    'Wife: Lisa Kids: Lucas, Lucy, and Lucinda',
    'Mountain View Hospital',
    '',
    '',
    '',
    '',
    '',
    '',
    'www.mvch.org',
    ''
);
INSERT INTO contact_info
(
    contactID, firstname, middleinitial, lastname,
    suffix_description, title_description,
    jobtitle, department, email, url, IMaddress,
    phone_number, phonetype_description,
    birthday, notes, companyname, street1,
    street2, city, state_province, zip_postalcode,
    country_region, company_url, company_phone
) VALUES 
(
    5,
    'Alexander',
    'K',
    'Kellermann',
    '',
    'Mr.',
    'Student',
    'Computing',
    'akn1736@g.rit.edu',
    '',
    '',
    '911',
    'Cell',
    '1997-07-28',
    'Avaliable foir Hire',
    'Rochester IT',
    'Nunya Business Avenue',
    '',
    '',
    '',
    '',
    '',
    'www.google.com',
    ''
);
-- Question 2
ALTER table contact_info ADD nickname VARCHAR(20) default 'To Be Determined';

-- Question 3
ALTER table contact_info MODIFY firstname varchar(15) NOT NULL;
ALTER table contact_info MODIFY lastname varchar(25) NOT NULL;

-- Question 4
UPDATE contact_info SET nickname='Bill' WHERE firstname='William' AND lastname='Destler'

-- Question 5
delete from contact_info where companyname LIKE '%Concor%';