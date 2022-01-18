-- Question 1:
select HeadOfState as 'Head Of State' from Country where Name = 'United States';

-- Question 2:
UPDATE Country SET HeadOfState='Barack H. Obama II' where HeadOfState='George W. Bush';

-- Question 3:
SELECT Name AS 'Country Name' FROM Country WHERE IndepYear IS NULL;

-- Question 4:
select Name,Continent from Country WHERE LifeExpectancy > 70 AND LifeExpectancy < 80 AND Population > 1000000000;

-- Question 5:
select Name as NAME from Country where Continent='North America' OR Continent='South America';
