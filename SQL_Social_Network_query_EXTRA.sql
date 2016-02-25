-- Q1. For every situation where student A likes student B, 
-- but student B likes a different student C, return the names and grades of A, B, and C. 

SELECT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM Highschooler h1, Highschooler h2, Highschooler h3, Likes l1, Likes l2
WHERE h1.ID = l1.ID1
AND h2.ID = l1.ID2
AND h2.ID = l2.ID1
AND h3.ID = l2.ID2
AND l2.ID2 != l1.ID1; -- C (B likes C) != A

-- Alternatively--
SELECT hs1.name, hs1.grade, hs2.name, hs2.grade, hs3.name, hs3.grade
FROM Highschooler hs1
INNER JOIN Likes l1 ON l1. ID1 = hs1.ID
INNER JOIN Likes l2 ON l1.ID2=l2.ID1 AND l1.ID1 != l2.ID2  -- B AND C != A
INNER JOIN Highschooler hs2 ON hs2.ID=l2.ID1
INNER JOIN Highschooler hs3 ON hs3.ID=l2.ID2

-- Q2. Find those students for whom all of their friends are in different grades from themselves. 
-- Return the students' names and grades. 

SELECT DISTINCT h2.name, h2.grade 
FROM Highschooler h2 JOIN Friend f2
ON h2.ID = f2.ID1 OR h2.ID = f2.ID2
WHERE ID NOT IN
(SELECT h1.ID
FROM Highschooler h1
JOIN Friend f ON f.ID1 = h1.ID
JOIN Highschooler h2 ON f.ID2 = h2.ID
WHERE h1.grade = h2.grade);

--Another---
SELECT name, grade FROM Highschooler WHERE ID NOT IN
(SELECT hs1.ID FROM Highschooler hs1
INNER JOIN Friend f1 ON f1.ID1=hs1.ID
INNER JOIN Highschooler hs2 ON f1.ID2=hs2.ID
WHERE hs1.grade-hs2.grade = 0 )

-- Q3. What is the average number of friends per student? (Your result should be just one number.) 
SELECT AVG(cnt_by_frnd) FROM
(SELECT ID1, COUNT(ID2) cnt_by_frnd 
FROM Friend 
GROUP BY ID1);

-- Q4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. 
-- Do not count Cassandra, even though technically she is a friend of a friend. 

SELECT sum(c_frnd) FROM 
(
  SELECT count(*) c_frnd
  FROM Highschooler h1
  JOIN Friend f ON h1.ID = f.ID1
  JOIN Highschooler h2 ON h2.ID = f.ID2
  WHERE h1.name = 'Cassandra'
  UNION
  SELECT count(DISTINCT F.ID2) c_frnd
  FROM Highschooler H1
  JOIN Friend F ON H1.ID = F.ID1
  JOIN Highschooler H2 ON H2.ID = F.ID2
  WHERE H1.ID IN 
    (SELECT f.ID2
    FROM Highschooler h1
    JOIN Friend f ON h1.ID = f.ID1
    JOIN Highschooler h2 ON h2.ID = f.ID2
    WHERE h1.name = 'Cassandra')
  AND H2.name != 'Cassandra'
) 
AS num_c_frnd

-- Another --
SELECT COUNT(ID2) FROM Friend WHERE ID1 IN 
( SELECT ID2 FROM Friend 
  WHERE ID2 != ( SELECT ID FROM Highschooler 
  WHERE name = 'Cassandra' ) 
  AND (ID1 = ( SELECT ID FROM Highschooler 
  WHERE name = 'Cassandra' ) ) 
  OR ID1 =  ( SELECT ID FROM Highschooler 
  WHERE name = 'Cassandra' ) )

-- Q5. Find the name and grade of the student(s) with the greatest number of friends. 
SELECT h.name, h.grade
FROM 
(SELECT ID1, count(ID2) num 
FROM Friend f 
GROUP BY ID1) AS f
JOIN Highschooler h ON f.ID1 = h.ID
WHERE num = 
  (SELECT MAX(num_frnd) FROM 
    (SELECT ID1, count(ID2) num_frnd
    FROM Friend
    GROUP BY ID1)
  );
-- In the where clasue, we find the two clumns, ID1 and count(the number of ID2, the friends of ID1)
-- cannot just select ID1 with max(count(ID2))
-- NEED to form another table with the same two columns, and set where clause with count(..) = MAX(count(ID2)), which comes from the first two columns
