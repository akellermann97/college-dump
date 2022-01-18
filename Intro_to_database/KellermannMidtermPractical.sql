-- Question 1: --
create database KellermannMP;

-- Question 2: --
use KellermannMP;
GO;

-- Question 3: --
create table Product(
ProductID int,
Brand varchar(50) NOT NULL,
Description varchar(60) NOT NULL,
Discount decimal(5,2) NOT NULL DEFAULT 1.00,
ExpDate date,
Type char(2)
);
GO;

-- This is part of the above question, I just like to do this seperately
ALTER TABLE Product ADD CONSTRAINT P_ID PRIMARY KEY (ProductID);
GO;

-- Question 4: --
DESCRIBE product;
GO;

-- Question 5 -- 
INSERT INTO product(ProductID, Brand, Description, ExpDate) VALUES (1,'PandG', 'Crest', '2020-12-31');
GO;

-- Question 6 --
ALTER TABLE Product add column quantity smallint unsigned default 1;
GO;

-- Question 7 --
DELETE FROM Product WHERE ExpDate < '2021-10-21';


