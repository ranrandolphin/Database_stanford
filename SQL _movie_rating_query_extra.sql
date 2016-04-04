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
