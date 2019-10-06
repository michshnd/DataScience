/*******2a*******/
SELECT
  Department = ISNULL(Department, 'Total') ,
  Students = SUM(T1.[Student Number])


FROM
	(Select count (dbo.Classrooms.StudentID ) AS 'Student Number' ,dbo.Departments.DepartmentName AS Department
		From dbo.Classrooms

	INNER JOIN dbo.Courses ON dbo.Courses.CourseID = dbo.Classrooms.CourseID
	INNER JOIN dbo.Departments ON dbo.Courses.DepartmentID = Departments.departmentID
	GROUP BY  dbo.Departments.DepartmentName) AS T1

GROUP BY ROLLUP(T1.Department);

GO



/*******2b*******/
Select count (dbo.Classrooms.StudentID ) AS 'Student Number' , dbo.Courses.CourseName AS CourseName
	From dbo.Classrooms
	INNER JOIN dbo.Courses ON dbo.Courses.CourseID = dbo.Classrooms.CourseID 
WHERE dbo.Courses.DepartmentID = 1 
GROUP BY dbo.Courses.CourseName;

GO

/*******2c*******/
SELECT	count(CASE WHEN QuantityText = 'BIG class' THEN 1 ELSE NULL END) AS 'No. of Big Classes',
		count(CASE WHEN QuantityText = 'SMALL class' THEN 1 ELSE NULL END ) AS 'No. of Small Classes'
		FROM 
		(Select count (dbo.Classrooms.StudentID ) AS Quantity , dbo.Courses.CourseID AS CourseID,
			CASE
				WHEN  count (dbo.Classrooms.StudentID )> 22 THEN 'BIG class'
				ELSE 'SMALL class'
			END as QuantityText

			From dbo.Classrooms
			INNER JOIN dbo.Courses ON dbo.Courses.CourseID = dbo.Classrooms.CourseID 
		WHERE dbo.Courses.DepartmentID = 2 
		GROUP BY dbo.Courses.CourseID) AS small_big;
GO


/*******2d*******/
Select count (dbo.Students.StudentID ) AS Quantity , dbo.Students.Gender AS Gender

	From dbo.Students
GROUP BY dbo.Students.Gender

GO


/*******2e*******/
SELECT *, (Student_No*1.0/Total_in_course*100) AS percentage FROM 

	(Select count (dbo.Classrooms.StudentID) As Student_No, dbo.Students.Gender As Gender, dbo.Classrooms.CourseID,
		(SELECT COUNT(Classrooms_temp.StudentID) FROM dbo.Classrooms AS Classrooms_temp WHERE Classrooms_temp.CourseID = Classrooms.CourseID) As Total_in_course
		From dbo.Classrooms
		INNER JOIN dbo.Students ON dbo.Students.StudentID = dbo.Classrooms.StudentID

	GROUP BY dbo.Classrooms.CourseID,dbo.Students.Gender ) AS new_data

WHERE (Student_No*1.0/Total_in_course*100) >70

GO

/*******2f*******/
	
SELECT dbo.Departments.DepartmentName, t1.above80, t1.above80*1.0/t2.All_stud*1.0*100   FROM
/*abve80*/
(SELECT   count(dbo.Classrooms.StudentID) AS above80, dbo.Courses.DepartmentID
	From dbo.Classrooms
	INNER JOIN dbo.Courses ON dbo.courses.CourseID = dbo.Classrooms.CourseID

WHERE dbo.Classrooms.degree > 80 
GROUP BY dbo.Courses.DepartmentID) AS t1
INNER JOIN 
/*all*/
(SELECT   count(dbo.Classrooms.StudentID) AS All_stud, dbo.Courses.DepartmentID
	From dbo.Classrooms
	INNER JOIN dbo.Courses ON dbo.courses.CourseID = dbo.Classrooms.CourseID

GROUP BY dbo.Courses.DepartmentID) AS t2

ON t1.DepartmentID = t2.DepartmentID
INNER JOIN dbo.Departments on  dbo.Departments.departmentID = t1.DepartmentID


GO


/******2g*******/
	
SELECT dbo.Departments.DepartmentName, t1.below60, t1.below60*1.0/t2.All_stud*1.0*100   FROM
/*abve80*/
(SELECT   count(dbo.Classrooms.StudentID) AS below60, dbo.Courses.DepartmentID
	From dbo.Classrooms
	INNER JOIN dbo.Courses ON dbo.courses.CourseID = dbo.Classrooms.CourseID

WHERE dbo.Classrooms.degree < 60 
GROUP BY dbo.Courses.DepartmentID) AS t1
INNER JOIN 
/*all*/
(SELECT   count(dbo.Classrooms.StudentID) AS All_stud, dbo.Courses.DepartmentID
	From dbo.Classrooms
	INNER JOIN dbo.Courses ON dbo.courses.CourseID = dbo.Classrooms.CourseID

GROUP BY dbo.Courses.DepartmentID) AS t2

ON t1.DepartmentID = t2.DepartmentID
INNER JOIN dbo.Departments on  dbo.Departments.departmentID = t1.DepartmentID

GO


/*******2h*******/

SELECT avg ( dbo.Classrooms.degree ) AS AVG_Degree , dbo.Courses.TeacherID, dbo.Teachers.FirstName,dbo.Teachers.LastName

FROM dbo.Classrooms

INNER JOIN dbo.Courses ON dbo.Classrooms.CourseID = dbo.Courses.CourseID
INNER JOIN dbo.Teachers ON dbo.Courses.TeacherID = dbo.Teachers.TeachersID
GROUP BY dbo.Courses.TeacherID, dbo.Teachers.FirstName,dbo.Teachers.LastName

ORDER BY avg ( dbo.Classrooms.degree ) desc

GO


/*******3a*******/


IF object_id('dbo.info_3a','v') is not null
	drop view  dbo.info_3a;
GO
CREATE VIEW dbo.info_3a
AS 
(SELECT dbo.Departments.DepartmentName , dbo.Courses.CourseName ,dbo.Teachers.FirstName,count(dbo.Classrooms.StudentID) AS STUD_NO
FROM dbo.Courses
LEFT OUTER JOIN dbo.Classrooms ON dbo.Courses.CourseID = dbo.Classrooms.CourseID
LEFT OUTER JOIN dbo.Teachers ON dbo.Teachers.TeachersID = dbo.Courses.TeacherID
LEFT OUTER JOIN dbo.Departments ON dbo.Departments.departmentID = dbo.Courses.DepartmentID

GROUP BY  dbo.Departments.DepartmentName, dbo.Courses.CourseName, dbo.Teachers.FirstName)

GO

/*******3b*******/


IF object_id('dbo.info3b','v') is not null
	drop view  dbo.info3b;
GO


CREATE VIEW dbo.info3b
AS
(SELECT students_info.StudentId,number_of_courses,avg_grade,dep1_avg_grade, dep2_avg_grade, dep3_avg_grade, dep4_avg_grade FROM
	(SELECT students.StudentId, COUNT (classes.CourseId) AS number_of_courses, AVG(classes.degree) AS avg_grade 
	FROM dbo.Students AS students 
	LEFT OUTER JOIN dbo.Classrooms AS classes ON students.StudentId = classes.StudentId
	LEFT OUTER JOIN dbo.Courses AS courses ON courses.CourseId = classes.CourseId
	GROUP BY students.StudentId) AS students_info
LEFT OUTER JOIN
	(SELECT students.StudentId, AVG(classes.degree) AS dep1_avg_grade FROM
	dbo.Students AS students 
	LEFT OUTER JOIN dbo.Classrooms AS classes ON students.StudentId = classes.StudentId
	LEFT OUTER JOIN dbo.Courses AS courses ON courses.CourseId = classes.CourseId
	where courses.DepartmentID=1
	GROUP BY students.StudentId) AS depart1
	ON students_info.StudentId = depart1.StudentId
LEFT OUTER JOIN
	(SELECT students.StudentId, AVG(classes.degree) AS dep2_avg_grade FROM
	dbo.Students AS students 
	LEFT OUTER JOIN dbo.Classrooms AS classes ON students.StudentId = classes.StudentId
	LEFT OUTER JOIN dbo.Courses AS courses ON courses.CourseId = classes.CourseId
	where courses.DepartmentID=2
	GROUP BY students.StudentId) AS depart2
	ON students_info.StudentId = depart2.StudentId
LEFT OUTER JOIN
	(SELECT students.StudentId, AVG(classes.degree) AS dep3_avg_grade FROM
	dbo.Students AS students 
	LEFT OUTER JOIN dbo.Classrooms AS classes ON students.StudentId = classes.StudentId
	LEFT OUTER JOIN dbo.Courses AS courses ON courses.CourseId = classes.CourseId
	where courses.DepartmentID=3
	GROUP BY students.StudentId) AS depart3
	ON students_info.StudentId = depart3.StudentId
LEFT OUTER JOIN
	(SELECT students.StudentId, AVG(classes.degree) AS dep4_avg_grade FROM
	dbo.Students AS students 
	LEFT OUTER JOIN dbo.Classrooms AS classes ON students.StudentId = classes.StudentId
	LEFT OUTER JOIN dbo.Courses AS courses ON courses.CourseId = classes.CourseId
	where courses.DepartmentID=4
	GROUP BY students.StudentId) AS dep4
	ON students_info.StudentId = dep4.StudentId);

	GO