-- Author: Alexander Kellermann Nieves
-- Date: April 17th 2017
-- File: Kellermann_HW7.sql

DROP DATABASE IF EXISTS kellermann_ACMEOnline;

CREATE DATABASE kellermann_ACMEOnline;

USE kellermann_ACMEOnline;

-- This table has no foreign keys so we create it first
CREATE TABLE CATEGORY(
category_name varchar(35),
shippingperpound decimal(5,2),
offersallowed ENUM('y', 'n'),
CONSTRAINT category_name_pk PRIMARY KEY (category_name)
);

CREATE TABLE OFFER(
offercode varchar(15),
discount varchar(35) NOT NULL,
minamount decimal(5,2),
expirationdate DATE NOT NULL,
CONSTRAINT offercode_pk PRIMARY KEY (offercode)
);

-- Also has no foreign keys
CREATE TABLE CUSTOMER(
customerID INT unsigned auto_increment,
customer_name varchar(50) NOT NULL,
address varchar(150) NOT NULL,
email varchar(80),
CONSTRAINT customerID_pk PRIMARY KEY (customerID)
);

CREATE TABLE BUSINESS(
paymentterms varchar(50) NOT NULL,
customerID INT unsigned auto_increment,
CONSTRAINT business_customerID_pk FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID)
    ON UPDATE CASCADE,
CONSTRAINT business_customerID_pk PRIMARY KEY (customerID)
);

CREATE TABLE HOME(
creditcardnum char(16) NOT NULL,
cardexpiration char(6) NOT NULL,
customerID INT unsigned,
CONSTRAINT home_customerID_fk FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID)
    ON UPDATE CASCADE,
CONSTRAINT home_customerID_pk PRIMARY KEY (customerID)
);

CREATE TABLE PURCHASE_CONTACT(
contactname varchar(50),
contactphone char(12) NOT NULL,
customerID INT unsigned auto_increment,
CONSTRAINT purchase_contact_customerID_fk FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID)
    ON UPDATE CASCADE,
CONSTRAINT purchase_contact_pk PRIMARY KEY (contactname, customerID)
);

-- This table uses foreign keys from CATEGORY
CREATE TABLE ITEM(
item_number INT unsigned auto_increment,
item_name varchar(35) NOT NULL,
description varchar(255),
model varchar(50) NOT NULL,
price decimal(9,2) NOT NULL,
category_name varchar(35),
CONSTRAINT category_name_fk FOREIGN KEY (category_name) REFERENCES CATEGORY(category_name)
    ON UPDATE CASCADE,
CONSTRAINT item_number_pk PRIMARY KEY (item_number)
);

CREATE TABLE ORDERED(
total decimal (11,2),
offercode varchar(15),
orderID int UNSIGNED auto_increment,
customerID INT unsigned,
CONSTRAINT ordered_customerid_fk FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID)
    ON UPDATE CASCADE,
CONSTRAINT ordered_offercode_fk FOREIGN KEY (offercode) REFERENCES OFFER(offercode)
    ON UPDATE CASCADE, 
CONSTRAINT orderID_pk PRIMARY KEY (orderID)
);

CREATE TABLE LINE_ITEM(
orderID int UNSIGNED,
quantity TINYINT unsigned,
shipping_amount decimal(7,2),
item_number int unsigned,
CONSTRAINT line_item_orderID FOREIGN KEY (orderID) REFERENCES ORDERED(orderID)
    ON UPDATE CASCADE,
CONSTRAINT line_item_item_number FOREIGN KEY (item_number) REFERENCES ITEM(item_number)
    ON UPDATE CASCADE,
CONSTRAINT line_item_pk PRIMARY KEY (item_number, orderID)
);

CREATE TABLE GUARANTEE(
url varchar(50),
refundamount decimal(13,2),
orderID int UNSIGNED,
customerID INT unsigned,
CONSTRAINT guarantee_orderID_fk FOREIGN KEY (orderID) REFERENCES ORDERED (orderID)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

CONSTRAINT guarantee_customerID_fk FOREIGN KEY (customerID) REFERENCES CUSTOMER(customerID)
    ON UPDATE CASCADE,

CONSTRAINT guarantee_pk PRIMARY KEY (orderID, customerID)
);

INSERT INTO CATEGORY (category_name, shippingperpound, offersallowed) VALUES (
'Books',
0.99,
'y'
);

INSERT INTO CATEGORY (category_name, shippingperpound, offersallowed) VALUES (
'Home',
1.99,
'y'
);

INSERT INTO CATEGORY (category_name, shippingperpound, offersallowed) VALUES (
'Jewelry',
0.99,
'n'
);

INSERT INTO CATEGORY (category_name, shippingperpound, offersallowed) VALUES (
'Toys',
0.99,
'y'
);

INSERT INTO ITEM (item_name, description, model, price, category_name ) SELECT 
'Cabbage Patch Doll',
'Baby boy doll',
'Boy',
39.95,
category_name FROM CATEGORY where category_name='Toys'
;

INSERT INTO ITEM (item_name, description, model, price, category_name ) SELECT 
'The Last Lecture',
'Written by Randy Pausch',
'Hardcover',
9.95,
category_name FROM CATEGORY where category_name='Books'
;

INSERT INTO ITEM (item_name, description, model, price, category_name ) SELECT 
'Keurig Beverage Maker',
'Keurig Platinum Edition Beverage Maker in Red',
'Platinum Edition',
299.95,
category_name FROM CATEGORY where category_name='Home'
;

INSERT INTO ITEM (item_name, description, model, price, category_name ) SELECT 
'1ct diamond ring in white gold',
'diamond is certified vvs, D, round',
'64gt32',
4000.00,
category_name FROM CATEGORY where category_name='Jewelry'
;

INSERT INTO OFFER(offercode, discount, minamount, expirationdate) VALUES (
345743213,
'20% off',
20.00,
'2013-12-31'
);

INSERT INTO OFFER(offercode, discount, minamount, expirationdate) VALUES (
4567890123,
'30% off',
30.00,
'2013-12-31'
);

START TRANSACTION;
INSERT INTO CUSTOMER(customer_name, address, email) VALUES (
'Janine Jeffers',
'152 Lomb Memorial Dr., Rochester, NY  14623',
'jxj1234@rit.edu'
);

INSERT INTO HOME(creditcardnum, cardexpiration, customerID) SELECT
'123456789023456',
'012014',
customerID FROM CUSTOMER where customer_name='Janine Jeffers';

INSERT INTO ORDERED(total, offercode) SELECT
4919.75,
offercode FROM OFFER where expirationdate='2013-12-31';
-- // There is an error here // customerID FROM CUSTOMER where customer_name='Janine Jeffers';

COMMIT;
