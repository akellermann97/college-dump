-- Author: Alexander Kellermann Nieves

-- Task 1:
select location from quarter UNION select statecode from employer;

-- Task 2:
select employer.companyname, employer.division, employer.statecode, interview.salaryoffered FROM employer INNER JOIN interview ON employer.companyname = interview.companyname AND employer.division = interview.division;

-- Task 3:
select statecode, description from state where statecode NOT IN ( SELECT statecode from employer);

-- Task 4:
select distinct companyname, minhrsoffered from interview;

-- Task 5:
select statecode, description from state WHERE description REGEXP '^..[a,e,i,o,u]';

-- Task 6:
select quarter.qtrcode, quarter.location, state.description from quarter INNER JOIN state ON state.statecode = quarter.location;

-- Task 7:
select state.description, employer.companyname from state LEFT JOIN employer on state.statecode = employer.statecode;
