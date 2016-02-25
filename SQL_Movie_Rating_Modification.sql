-- Movie ( mID, title, year, director ) 
-- English: There is a movie with ID number mID, a title, a release year, and a director. 

-- Reviewer ( rID, name ) 
-- English: The reviewer with ID number rID has a certain name. 

-- Rating ( rID, mID, stars, ratingDate ) 
-- English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

-- Q1. Add the reviewer Roger Ebert to your database, with an rID of 209. 
insert into Reviewer(rID, name) values (209, 'Roger Ebert');
