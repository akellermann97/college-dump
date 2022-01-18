-- Creates the CONTACT_INFO table

/* block comment
continued comment */

DROP TABLE IF EXISTS contact_info;

CREATE TABLE contact_info;

USE contact_info;

CREATE TABLE contact_info(
contactID int,
firstname varchar(15),
middleinitial char(1),
lastname varchar(25),
suffix_description varchar(5),
title_description varchar(5),
jobtitle varchar(35),
department varchar(30),
email varchar(40),
url varchar(55),
IMaddress varchar(25),
phone_number varchar(20),
phonetype_description varchar(8),
birthday date,
notes varchar(255),
companyname varchar(35),
street1 varchar(45),
street2 varchar(45),
city varchar(25),
state_province varchar(20),
zip_postalcode varchar(10),
country_region varchar(15),
company_url varchar(45),
company_phone varchar(12),
CONSTRAINT contact_info_pk PRIMARY KEY(contactID)
);