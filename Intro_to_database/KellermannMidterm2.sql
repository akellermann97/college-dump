-- Midterm Part 2
-- Alexander K Kellermann Nieves
-- Question 1:

select interviewID from interview where qtrcode IS NULL;

-- Question 2:

select companyname 'Company Name', salaryoffered 'Salary Offered' from interview where division='Management' AND salaryoffered >= 12.15;

-- Question 3:

update interview SET division='R and D' where division='RandD';

-- Question 4:

select interviewdate 'Interview Date', companyname 'Company Name' from interview where MONTH(interviewdate) = 8;

-- Question 5: 

drop database co_op;