/* 
    Script by Alexander Kellermann Nieves
    Akn1736
 */

DROP DATABASE IF EXISTS HW2;
CREATE DATABASE HW2;
USE HW2;


CREATE TABLE ITEM(
ItemID VARCHAR(25) NOT NULL,
ItemName VARCHAR(25),
Name VARCHAR(25),
Street VARCHAR(25),
City VARCHAR(25),
Colors VARCHAR(25),
State CHAR(2),
Zipcode CHAR(2),
Cost VARCHAR(10),
Retail_Price VARCHAR(10),
Notes VARCHAR(255),
Desciption VARCHAR(255),
Returnable CHAR(1),
Perishable CHAR(1),
Shelf_Qty INT,
CONSTRAINT pk_ItemID PRIMARY KEY (ItemID),
CHECK (Shelf_Qty > 0),
CHECK (Shelf_Qty < 50000)
);
