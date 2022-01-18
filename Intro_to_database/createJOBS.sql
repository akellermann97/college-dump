DROP DATABASE jobs;
CREATE DATABASE jobs;
USE jobs;

CREATE TABLE state (
statecode   CHAR(2),
description VARCHAR(30) NOT NULL,
CONSTRAINT state_pk PRIMARY KEY (statecode));

CREATE TABLE quarter (
qtrcode     VARCHAR(5),
location    CHAR(2),
minsal      DECIMAL(6,2) NOT NULL,
minhrs      TINYINT UNSIGNED   NOT NULL,
CONSTRAINT quarter_pk PRIMARY KEY (qtrcode),
CONSTRAINT quarter_location_fk FOREIGN KEY (location) REFERENCES state
(statecode));

CREATE TABLE employer (
companyname     VARCHAR(30) NOT NULL,
division        VARCHAR(30) NOT NULL,
address         VARCHAR(30),
city            VARCHAR(20),
statecode       CHAR(2) NOT NULL,
zipcode         VARCHAR(10),
CONSTRAINT employer_pk PRIMARY KEY (companyname, division),
CONSTRAINT employer_statecode_fk FOREIGN KEY (statecode) REFERENCES state(statecode));

CREATE TABLE interview (
interviewID   INTEGER UNSIGNED ,
interviewdate DATE,
companyname   VARCHAR(30) NOT NULL,
division      VARCHAR(30) NOT NULL,
qtrcode       VARCHAR(5),
salaryoffered DECIMAL(8,2),
minhrsoffered TINYINT UNSIGNED,
listing       ENUM('y', 'n'),
jobdesc       VARCHAR(255),
CONSTRAINT interview_pk PRIMARY KEY (interviewID),
CONSTRAINT interview_companyname_division_fk FOREIGN KEY (companyname, division) REFERENCES employer(companyname, division),
CONSTRAINT interview_qtrcode_fk FOREIGN KEY (qtrcode) REFERENCES quarter(qtrcode));

INSERT INTO state(description,statecode) VALUES('ALABAMA','AL');
INSERT INTO state(description,statecode) VALUES('ALASKA','AK');
INSERT INTO state(description,statecode) VALUES('AMERICAN SAMOA','AS');
INSERT INTO state(description,statecode) VALUES('ARIZONA','AZ');
INSERT INTO state(description,statecode) VALUES('ARKANSAS','AR');
INSERT INTO state(description,statecode) VALUES('CALIFORNIA','CA');
INSERT INTO state(description,statecode) VALUES('COLORADO','CO');
INSERT INTO state(description,statecode) VALUES('CONNECTICUT','CT');
INSERT INTO state(description,statecode) VALUES('DELAWARE','DE');
INSERT INTO state(description,statecode) VALUES('DISTRICT OF COLUMBIA','DC');
INSERT INTO state(description,statecode) VALUES('FEDERATED STATES OF MICRONESIA','FM');
INSERT INTO state(description,statecode) VALUES('FLORIDA','FL');
INSERT INTO state(description,statecode) VALUES('GEORGIA','GA');
INSERT INTO state(description,statecode) VALUES('GUAM','GU');
INSERT INTO state(description,statecode) VALUES('HAWAII','HI');
INSERT INTO state(description,statecode) VALUES('IDAHO','ID');
INSERT INTO state(description,statecode) VALUES('ILLINOIS','IL');
INSERT INTO state(description,statecode) VALUES('INDIANA','IN');
INSERT INTO state(description,statecode) VALUES('IOWA','IA');
INSERT INTO state(description,statecode) VALUES('KANSAS','KS');
INSERT INTO state(description,statecode) VALUES('KENTUCKY','KY');
INSERT INTO state(description,statecode) VALUES('LOUISIANA','LA');
INSERT INTO state(description,statecode) VALUES('MAINE','ME');
INSERT INTO state(description,statecode) VALUES('MARSHALL ISLANDS','MH');
INSERT INTO state(description,statecode) VALUES('MARYLAND','MD');
INSERT INTO state(description,statecode) VALUES('MASSACHUSETTS','MA');
INSERT INTO state(description,statecode) VALUES('MICHIGAN','MI');
INSERT INTO state(description,statecode) VALUES('MINNESOTA','MN');
INSERT INTO state(description,statecode) VALUES('MISSISSIPPI','MS');
INSERT INTO state(description,statecode) VALUES('MISSOURI','MO');
INSERT INTO state(description,statecode) VALUES('MONTANA','MT');
INSERT INTO state(description,statecode) VALUES('NEBRASKA','NE');
INSERT INTO state(description,statecode) VALUES('NEVADA','NV');
INSERT INTO state(description,statecode) VALUES('NEW HAMPSHIRE','NH');
INSERT INTO state(description,statecode) VALUES('NEW JERSEY','NJ');
INSERT INTO state(description,statecode) VALUES('NEW MEXICO','NM');
INSERT INTO state(description,statecode) VALUES('NEW YORK','NY');
INSERT INTO state(description,statecode) VALUES('NORTH CAROLINA','NC');
INSERT INTO state(description,statecode) VALUES('NORTH DAKOTA','ND');
INSERT INTO state(description,statecode) VALUES('NORTHERN MARIANA ISLANDS','MP');
INSERT INTO state(description,statecode) VALUES('OHIO','OH');
INSERT INTO state(description,statecode) VALUES('OKLAHOMA','OK');
INSERT INTO state(description,statecode) VALUES('OREGON','OR');
INSERT INTO state(description,statecode) VALUES('PALAU','PW');
INSERT INTO state(description,statecode) VALUES('PENNSYLVANIA','PA');
INSERT INTO state(description,statecode) VALUES('PUERTO RICO','PR');
INSERT INTO state(description,statecode) VALUES('RHODE ISLAND','RI');
INSERT INTO state(description,statecode) VALUES('SOUTH CAROLINA','SC');
INSERT INTO state(description,statecode) VALUES('SOUTH DAKOTA','SD');
INSERT INTO state(description,statecode) VALUES('TENNESSEE','TN');
INSERT INTO state(description,statecode) VALUES('TEXAS','TX');
INSERT INTO state(description,statecode) VALUES('UTAH','UT');
INSERT INTO state(description,statecode) VALUES('VERMONT','VT');
INSERT INTO state(description,statecode) VALUES('VIRGIN ISLANDS','VI');
INSERT INTO state(description,statecode) VALUES('VIRGINIA','VA');
INSERT INTO state(description,statecode) VALUES('WASHINGTON','WA');
INSERT INTO state(description,statecode) VALUES('WEST VIRGINIA','WV');
INSERT INTO state(description,statecode) VALUES('WISCONSIN','WI');
INSERT INTO state(description, statecode) VALUES('WYOMING','WY');

INSERT INTO quarter VALUES('19951', 'NY', 11.00,40);
INSERT INTO quarter VALUES('19953', 'CA', 11.50,30);
INSERT INTO quarter VALUES('19961', 'NY', 12.00,30);
INSERT INTO quarter VALUES('19963', 'MA', 12.75,40);
INSERT INTO quarter VALUES('19964', 'NY', 13.50,40);

INSERT INTO employer VALUES('Acme Information Source', 'Customer Support', '132 Commerical Way', 'Cleveland','OH',44234);
INSERT INTO employer VALUES('Ajax Software, Inc.', 'RandD', '2421 West Industrial Way', 'Berkeley','CA',94710);
INSERT INTO employer VALUES('Ajax Software, Inc.', 'Production', '2421 West Industrial Way', 'Berkeley','CA',94710);
INSERT INTO employer VALUES('Bay Software Inc.', 'Production', '4223 Halster Way', 'Berkeley','CA',94710);
INSERT INTO employer VALUES('Bay Software Inc.', 'RandD', '4223 Halster Way', 'Berkeley','CA',94710);
INSERT INTO employer VALUES('Braddock Information Assoc.', 'Payroll', '1 Washington Complex','Boston','MA',02101); 
INSERT INTO employer VALUES('Yankee Software', 'Development', '1 Braddock Circle','Kenmore','NY',14223);
INSERT INTO employer VALUES('Yankee Software', 'RandD', '1 Braddock Circle','Kenmore','NY',14223);
INSERT INTO employer VALUES('Yankee Software', 'Management', '1 Braddock Circle','Kenmore','NY',14223);
INSERT INTO employer VALUES('Buffalo Software Assoc.','Payroll','45511 Delaware Ave.','Buffalo','NY',14221);
INSERT INTO employer VALUES('Cameron Industries', 'Management', '3112 West Helm Street', 'Kingwood','TX',77339);
INSERT INTO employer VALUES('Cameron Industries', 'Customer Support', '3112 West Helm Street', 'Kingwood','TX',77339);
INSERT INTO employer VALUES('CCC Software', 'Production', '41 Golem Terrace', 'New York', 'NY',10012);
INSERT INTO employer VALUES('DC Security Applications','RandD','1602 Jackson Ave.','Arlington','VA',22202);
INSERT INTO employer VALUES('Davis-Klein Software', 'RandD', '8871 West Grange Drive', 'Cairo', 'NY',12413);
INSERT INTO employer VALUES('Jersey Computer Services','Customer Support','44 WhiteStallion Pike','Lindenwold','NJ',08021);
INSERT INTO employer VALUES('Flordia Software Designs', 'Development', '45A Sturgeon Dr., Bldg. 5', 'Ft. Pierce', 'FL',34951);
INSERT INTO employer VALUES('Flordia Software Designs', 'RandD', '45A Sturgeon Dr., Bldg. 5', 'Ft. Pierce', 'FL',34951);
INSERT INTO employer VALUES('Focused Applications, Inc.','Production','776 West Ninth St.','Myrtle Beach','SC', 29579);
INSERT INTO employer VALUES('Georgia Software Design','RandD','6665 Peachtree Lane','Atlanta','GA',30328);
INSERT INTO employer VALUES('ApplDesign','RandD','3 Mapleview Drive','Huntsville','AL',35803);
INSERT INTO employer VALUES('Long Island Apps, Inc.','Development','67 Merrifield Ave.','Oceanside','NY',11572);
INSERT INTO employer VALUES('Manhattan-Made Software','Customer Support','35 West 9th St.','New York','NY',10012);
INSERT INTO employer VALUES('Manhattan-Made Software','Payroll','35 West 9th St.','New York','NY',10012);
INSERT INTO employer VALUES('Michigan Application Design','Development','5531 E. Lansing Ave.','Ypsilanti','MI',48197);
INSERT INTO employer VALUES('Midtown Software Development','Customer Support','7554 West 9th St.','New York','NY',10003);
INSERT INTO employer VALUES('Mountainside Magic Software','Customer Support','4 Rocky Way','Colorado Springs','CO',80941);
INSERT INTO employer VALUES('Mountainside Magic Software','Management','4 Rocky Way','Colorado Springs','CO',80941);
INSERT INTO employer VALUES('Nantucket Applications, Inc.','RandD','45521 Pilgrim Circle','Nantucket','MA',02554);
INSERT INTO employer VALUES('PennState Programming, Inc.','Management','3 Carnegie Circle','Pittsburgh','PA',15108);
INSERT INTO employer VALUES('PSWD, Inc.','Management','15 Carnegie Circle','Pittsburgh','PA',15108);
INSERT INTO employer VALUES('Rochester Software Design','Development','16 Broad Street','Rochester','NY',14621);
INSERT INTO employer VALUES('Rochester Application Software','Production','16 Broad Street','Rochester','NY',14621);
INSERT INTO employer VALUES('Sandy Shore Software','Development','5665 MassPike Circle','Waterford','CT',06482);
INSERT INTO employer VALUES('Vegas Programming and Design','Development','3 Desert Trail','Las Vegas','NV',89117);
INSERT INTO employer VALUES('Virginia Software Industries','Production','3 Confederate Ave.','Roanoke','VA',24010);
INSERT INTO employer VALUES('Western New York Applications','RandD','44 Rockman Blvd.','Rochester','NY',14623);

INSERT INTO INTERVIEW VALUES(01,'1995-06-01','Acme Information Source', 'Customer Support', '19951',12,40,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(02,'1995-06-01','Braddock Information Assoc.', 'Payroll', '19951',10.75,40,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(03,'1995-06-30','Ajax Software, Inc.', 'Production', '19951',11,40,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(04,'1995-06-30','Ajax Software, Inc.', 'RandD', '19951',11.5,40,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(05,'1995-07-01','Bay Software Inc.', 'Production', '19951',11.75,20,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(06,'1995-08-01','Vegas Programming and Design', 'Development', '19951',11,40,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(07,'1995-08-01','Mountainside Magic Software', 'Management', '19951',11.5,20,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(08,'1995-08-02','Mountainside Magic Software', 'Customer Support', '19951',10.75,40,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(09,'1995-12-01','Cameron Industries', 'Management', '19953',13.25,35,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(10,'1995-12-02','Cameron Industries', 'Customer Support', '19953',13,35,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(11,'1995-12-04','CCC Software', 'Production', '19953',11.5,40,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(12,'1996-01-21','DC Security Applications', 'RandD', '19953',11.5,30,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(13,'1996-02-01','Davis-Klein Software', 'RandD', '19953',11.25,20,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(14,'1996-02-02','Flordia Software Designs', 'RandD', '19953',11.75,30,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(15,'1996-07-01','Rochester Software Design', 'Development', '19961',12,30,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(16,'1996-07-01','Focused Applications, Inc.', 'Production', '19961',12,30,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(17,'1996-08-01','Georgia Software Design', 'RandD', '19961',11.75,40,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(18,'1996-08-08','ApplDesign', 'RandD', '19961',11.5,30,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(19,'1996-08-11','Long Island Apps, Inc.', 'Development', '19961',12.25,40,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(20,'1997-01-01','Jersey Computer Services', 'Customer Support', '19963',12.5,35,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(21,'1997-01-01','Flordia Software Designs', 'Development', '19963',12.75,30,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(22,'1997-01-31','Manhattan-Made Software', 'Customer Support', '19963',12.5,40,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(23,'1997-02-01','Manhattan-Made Software', 'Payroll', '19963',13.25,40,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(24,'1997-03-24','Nantucket Applications, Inc.', 'RandD', '19964',13,40,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(25,'1997-03-31','PennState Programming, Inc.', 'Management', '19964',13,40,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(26,'1997-04-20','Sandy Shore Software', 'Development', '19964',12.75,35,'n','Job Desc');
INSERT INTO INTERVIEW VALUES(27,'1997-04-22','Buffalo Software Assoc.', 'Payroll', '19964',12.75,35,'y','Job Desc');
INSERT INTO INTERVIEW VALUES(28,'1997-05-01','Virginia Software Industries', 'Production', '19964',13.75,40,'n','Job Desc');
