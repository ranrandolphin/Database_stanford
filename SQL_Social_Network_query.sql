-- Highschooler ( ID, name, grade ) 
-- English: There is a high school student with unique ID and a given first name in a certain grade. 

-- Friend ( ID1, ID2 ) 
-- English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

-- Likes ( ID1, ID2 ) 
-- English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, 
-- so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 

-- Q1. Find the names of all students who are friends with someone named Gabriel. 
SELECT h.name
FROM Highschooler h
WHERE h.ID IN (SELECT ID2 FROM Friend JOIN Highschooler h2 ON h2.ID = Friend.ID1 
               WHERE h2.name = 'Gabriel');
               
-- Q2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, 
-- and the name and grade of the student they like. 

SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Highschooler h1
JOIN Likes l ON h1.ID = l.ID1
JOIN Highschooler h2 ON h2.ID = l.ID2
WHERE h1.grade - h2.grade >= 2;


-- Q3. For every pair of students who both like each other, return the name and grade of both students. 
-- Include each pair only once, with the two names in alphabetical order. 
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Likes l1 JOIN Likes l2 ON l1.ID1 = l2.ID2 AND l1.ID2 = l2.ID1
JOIN Highschooler h1 ON h1.ID = l1.ID1
JOIN Highschooler h2 ON h2.ID = l1.ID2
WHERE h1.name < h2.name;

-- Q4.Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. 
-- Sort by grade, then by name within each grade. 
SELECT t1.name, t1.grade
FROM 
(SELECT h1.ID, h1.name, h1.grade
FROM Highschooler h1
LEFT JOIN Likes l1 ON l1.ID1 = h1.ID
WHERE l1.ID1 IS NULL
AND l1.ID2 IS NULL) AS t1 -- select all students in highschooler do not appear in Likes' ID1
LEFT JOIN Likes l2 ON t1.ID = l2.ID2
WHERE l2.ID1 IS NULL
AND l2.ID2 IS NULL;

--Alternatively (simplify by LEFT JOIN using OR) --
SELECT hs.name, hs.grade FROM Highschooler hs
        LEFT JOIN Likes l1 ON l1.ID1=hs.ID OR l1.ID2=hs.ID
        WHERE l1.ID1 IS NULL AND l1.ID2 IS NULL

-- Q5. For every situation where student A likes student B, but we have no information about whom B likes 
-- (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Highschooler h1
JOIN Likes l ON h1.ID = l.ID1
JOIN Highschooler h2 ON h2.ID = l.ID2
WHERE h2.ID NOT IN (SELECT ID1 FROM Likes);

-- Q6. Find names and grades of students who only have friends in the same grade. 
-- Return the result sorted by grade, then by name within each grade. 
SELECT h.name, h.grade
FROM Highschooler h
WHERE h.ID NOT IN       -- remember to use NOT IN fliter our all IDs have friend with higher grade than them
    (SELECT h1.ID
    FROM Highschooler h1
    JOIN Friend f ON h1.ID = f.ID1
    JOIN Highschooler h2 ON h2.ID = f.ID2
    WHERE abs(h2.grade - h1.grade) > 0)
ORDER BY h.grade, h.name;

-- Q7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). 
-- For all such trios, return the name and grade of A, B, and C. 
SELECT DISTINCT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM Highschooler h1, Highschooler h2, Highschooler h3, Likes l, Friend f1, Friend f2
WHERE h1.ID = l.ID1 and h2.ID = l.ID2
AND h2.ID NOT IN (SELECT ID2 FROM Friend WHERE ID1 = h1.ID)
AND (h1.ID = f1.ID1 and f1.ID2 = h3.ID)
AND (h3.ID = f2.ID1 and f2.ID2 = h2.ID);

--Alternatively ---
SELECT hs1.name, hs1.grade, hs3.name, hs3.grade , hs2.name, hs2.grade
FROM Highschooler hs1
INNER JOIN Likes l1 ON l1.ID1=hs1.ID
LEFT JOIN Friend fl ON fl.ID1=l1.ID1 AND fl.ID2=l1.ID2
INNER JOIN Friend f1 ON f1.ID1=l1.ID1
INNER JOIN Friend f2 ON f2.ID1=l1.ID2 AND f2.ID2=f1.ID2
INNER JOIN Highschooler hs2 ON hs2.ID = f2.ID2
INNER JOIN Highschooler hs3 ON hs3.ID = f2.ID1
WHERE fl.ID2 IS NULL;
        
        
-- Q8. Find the difference between the number of students in the school and the number of different first names. 
SELECT count(*)
FROM Highschooler h1
JOIN Highschooler h2 ON (h1.name == h2.name AND h1.ID != h2.ID)
WHERE h1.grade < h2.grade;

--Alternatively---
SELECT COUNT(DISTINCT ID)-COUNT(DISTINCT name) FROM Highschooler;

-- Q9. Find the name and grade of all students who are liked by more than one other student. 
SELECT name, grade
FROM Highschooler
WHERE ID IN(
SELECT ID2
FROM Likes l
GROUP BY ID2
HAVING count(ID1) > 1);
