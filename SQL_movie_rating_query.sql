-- Movie ( mID, title, year, director ) 
-- English: There is a movie with ID number mID, a title, a release year, and a director. 

-- Reviewer ( rID, name ) 
-- English: The reviewer with ID number rID has a certain name. 

-- Rating ( rID, mID, stars, ratingDate ) 
-- English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

-- Q3. Find the titles of all movies that have no ratings. 
SELECT title
FROM Movie
WHERE mID NOT IN (SELECT mID FROM Rating);

SELECT title
FROM Movie
LEFT JOIN Rating ON Movie.mID = Rating.mID
WHERE stars IS NULL;

-- Q4. Some reviewers didn't provide a date with their rating. 
-- Find the names of all reviewers who have ratings with a NULL value for the date. 
SELECT name
FROM Reviewer
LEFT JOIN Rating using(rID)
WHERE Rating.ratingDate IS NULL;

SELECT name
FROM Reviewer
WHERE rID IN (SELECT rID FROM Rating WHERE ratingDate IS NULL);

-- Q5. reviewer name, movie title, stars, and ratingDate. 
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 

SELECT r.name, m.title, rat.stars, rat.ratingDate
FROM Movie m
JOIN Rating rat using(mID)
JOIN Reviewer r using(rID)
ORDER BY r.name, m.title, rat.stars;

-- Q6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
-- return the reviewer's name and the title of the movie. 
SELECT r.name, m.title
FROM Rating rat1
JOIN Reviewer r using(rID) -- create a table combine with reviewers
JOIN Rating rat2 using(rID) 
JOIN Movie m using(mID)
WHERE rat1.mID = rat2.mID
AND rat1.ratingDate < rat2.ratingDate
AND rat1.stars < rat2.stars

--=====================================--
SELECT name, title
FROM Movie
INNER JOIN Rating R1 USING(mId)
INNER JOIN Rating R2 USING(rId, mId)
INNER JOIN Reviewer USING(rId)
WHERE R1.ratingDate < R2.ratingDate AND R1.stars < R2.stars;

-- Q7. For each movie that has at least one rating, find the highest number of stars that movie received. 
-- Return the movie title and number of stars. Sort by movie title. 
SELECT m.title, MAX(r1.stars)
FROM Movie m
JOIN Rating r1 using(mID)
GROUP BY m.mID
HAVING count(r1.stars) > 1
ORDER BY m.title;

-- Q8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
-- Sort by rating spread from highest to lowest, then by movie title. 
SELECT m.title, MAX(r.stars) - MIN(r.stars) as rating_spread
FROM Movie m
JOIN Rating r using(mID)
GROUP BY r.mID
ORDER BY rating_spread DESC, m.title;

-- Q9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
-- (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
-- Don't just calculate the overall average rating before and after 1980.) 
SELECT abs(AVG(Before.avg) - AVG(After.avg))
FROM 
    (SELECT avg(r1.stars) AS avg FROM Rating r1 JOIN Movie using(mID)
    WHERE Movie.year > 1980
    GROUP BY mID) AS Before,
    (SELECT avg(r2.stars) AS avg FROM Rating r2 JOIN Movie using(mID)
    WHERE Movie.year < 1980
    GROUP BY mID) AS After;
