# 1. Find the names of all reviewers who rated Gone with the Wind. 

SELECT DISTINCT Reviewer.name
FROM Movie
JOIN Rating on Movie.mID = Rating.mID
JOIN Reviewer on Rating.rID = Reviewer.rID
WHERE Movie.title = "Gone with the Wind"
AND Rating.stars IS NOT NULL;
