-- Q1. For every situation where student A likes student B, 
-- but student B likes a different student C, return the names and grades of A, B, and C. 

SELECT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM Highschooler h1, Highschooler h2, Highschooler h3, Likes l1, Likes l2
WHERE h1.ID = l1.ID1
AND h2.ID = l1.ID2
AND h2.ID = l2.ID1
AND h3.ID = l2.ID2
AND l2.ID2 != l1.ID1;


-- Q2. Find those students for whom all of their friends are in different grades from themselves. 
-- Return the students' names and grades. 

-- Q3. 
