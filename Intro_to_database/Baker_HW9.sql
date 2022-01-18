-- Author: Alexander Kellermann Nieves
-- Homework 9

-- Task 1
select CONCAT(city, ', ', statecode) as 'Location', Count(City) as 'Count' from publisher group by city, statecode order by count(city) asc;

-- Task 2 (not displaying NULL values)
select b.title, count(bookreview.rating) as 'Total Ratings', Min(bookreview.rating) as 'Low', Max(bookreview.rating) as 'High', AVG(bookreview.rating) as 'Average' from book b, bookreview LEFT JOIN Book ON book.isbn = bookreview.isbn WHERE bookreview.isbn = book.isbn group by title  order by count(bookreview.rating) DESC;


-- Task 3
select name as 'Publisher Name', Count(book.title) as 'Book Count' from publisher, book where publisher.publisherID = book.publisherID group by name having count(book.title) > 2 order by count(book.title) DESC;

-- Task 4
select title, length(title) as 'length', substr(title,substr(title,'bill')+4) as 'After bill' from book where title LIKE '%bill%';

-- Task 5 (out of order)
select distinct title from book, ownersbook where book.isbn = ownersbook.isbn;

