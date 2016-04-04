-- 1. Find the names of all reviewers who rated Gone with the Wind. 

SELECT DISTINCT Reviewer.name
FROM Movie
JOIN Rating on Movie.mID = Rating.mID
JOIN Reviewer on Rating.rID = Reviewer.rID
WHERE Movie.title = "Gone with the Wind"
AND Rating.stars IS NOT NULL;

-- 2. For any rating where the reviewer is the same as the director of the movie, 
-- return the reviewer name, movie title, and number of stars. 
SELECT Reviewer.name, Movie.title, Rating.stars 
FROM Reviewer 
JOIN Rating ON Reviewer.rID = Rating.rID
JOIN Movie ON Movie.mID = Rating.mID
WHERE Reviewer.name = Movie.director;

-- 3. Return all reviewer names and movie names together in a single list, alphabetized. 
-- (Sorting by the first name of the reviewer and first word in the title is fine; 
-- no need for special processing on last names or removing "The".) 
SELECT name FROM Reviewer 
UNION
SELECT title FROM Movie
ORDER BY name;

-- 4. Find the titles of all movies not reviewed by Chris Jackson. 
SELECT Movie.title
FROM Movie
WHERE Movie.mID NOT IN
    (SELECT Rating.mID
    FROM Rating
    JOIN Reviewer USING(rID)
    WHERE Reviewer.name = "Chris Jackson");
    
-- 5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, 
-- return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, 
-- and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
SELECT DISTINCT re1.name, re2.name
FROM Reviewer re1
JOIN Rating r1 ON r1.rID = re1.rID
JOIN Rating r2 ON r2.mID = r1.mID
JOIN Reviewer re2 ON re2.rID = r2.rID
WHERE r1.mID = r2.mID AND re1.name < re2.name
ORDER BY re1.name;

-- ===== Alternatively =====
select nameFirst, nameSecond
from (select distinct nameFirst, nameSecond
from (select R1.rID as rIDFirst, R2.rID as rIDSecond
from Rating R1 join Rating R2 using(mID)
where R1.mID = R2.mID and R1.rID <> R2.rID)
join
(select rID as rIDFirst, name as nameFirst
from Reviewer) using(rIDFirst)
join
(select rID as rIDSecond, name as nameSecond
from Reviewer) using(rIDSecond)
order by nameFirst)
where nameFirst < nameSecond

-- 6. For each rating that is the lowest (fewest stars) currently in the database, 
-- return the reviewer name, movie title, and number of stars. 
SELECT Reviewer.name, Movie.title, re2.stars
FROM Reviewer JOIN Rating re2 USING(rID)
JOIN Movie USING(mID)
WHERE re2.stars IN (SELECT min(re1.stars) FROM Rating re1);

-- 7. List movie titles and average ratings, from highest-rated to lowest-rated. 
-- If two or more movies have the same average rating, list them in alphabetical order. 
SELECT Movie.title, avg(re1.stars)
FROM Movie
JOIN Rating re1 USING(mID)
GROUP BY re1.mID
ORDER BY avg(re1.stars) DESC, Movie.title;
-- Note: ORDER BY is running by order, first avg, and then moveie title

-- 8. Find the names of all reviewers who have contributed three or more ratings. 
-- (As an extra challenge, try writing the query without HAVING or without COUNT.) 

SELECT r1.name
FROM Reviewer r1 JOIN Rating re1 USING(rID)
GROUP BY re1.rID
HAVING count(*) >= 3;
