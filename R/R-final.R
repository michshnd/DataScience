
#### On Windows:
library(DBI)
con <- dbConnect(odbc::odbc(), .connection_string = "DSN=COLLEGE;Trusted_Connection=yes;", timeout = 10)

## Get the whole table:
classroom <- dbReadTable(con, "Classrooms")
teachers <- dbReadTable(con, "Teachers")
students <- dbReadTable(con, "Students")
departments <- dbReadTable(con, "Departments")
courses <- dbReadTable(con, "Courses")

## Joins
classroom_courses <- inner_join(classroom, courses, by="CourseID")
class_courses_dep <- inner_join(departments ,classroom_courses, by="DepartmentID")
class_courses_dep_stud <- inner_join(class_courses_dep, students, by="StudentID")
class_courses_dep_stud_teach <- inner_join(class_courses_dep_stud, teachers, by="TeacherID")
class_courses_dep_teach <- left_join(class_courses_dep, teachers, by="TeacherID")

library(dplyr)

## Questions

##############
## Q1. Count the number of students on each department¶
##############
students_dep <-class_courses_dep %>% group_by(DepartmentName) %>% 
                  summarise(No_of_students = n_distinct(StudentID))
students_dep

##############
## Q2. How many students have each course of the English department and the 
##     total number of students in the department?
##############
students_eng_dep <- class_courses_dep %>% filter(DepartmentID==1) %>% 
                      group_by(CourseName) %>% 
                        summarise(No_of_students = n_distinct(StudentID))
students_eng_dep
Total_stud <-class_courses_dep %>% filter(DepartmentID==1)%>%
                  summarise(Total = n_distinct(StudentID))

sprintf("Total number of students in English department is %s", Total_stud)


##############
## Q3. How many small (<22 students) and large (22+ students) classrooms are 
##     needed for the Science department?
##############

students_sci_dep <- class_courses_dep %>% filter(DepartmentID==2) %>% 
  group_by(CourseName) %>% 
  summarise(No_of_students = n_distinct(StudentID)) %>% 
  mutate(Big_Class = ifelse(No_of_students > 21,1,0),
       Small_Class = ifelse(No_of_students < 23, 1,0)) %>% 
  summarise(Big_Class = sum(Big_Class),
            Small_Class = sum(Small_Class))

students_sci_dep
##############
## Q4. A feminist student claims that there are more male than female in the 
##     College. Justify if the argument is correct
##############
genders <- students  %>% group_by(Gender) %>% 
  summarise(No_of_students = n_distinct(StudentID))
genders
print("The feminist are WRONG, There are more women than man in the college")

##############
## Q5. For which courses the percentage of male/female students is over 70%?
##############

Male_Female <-  class_courses_dep_stud %>% mutate(Male = ifelse(Gender=="M",1,0),
                  Female = ifelse(Gender=="F",1,0)) %>%group_by(CourseID,CourseName) %>% 
                  summarise(Male = sum(Male),Female = sum(Female),Total = n()) %>%
                   filter((Male/Total>0.7) | (Female/Total>0.7))
                  
Male_Female                 



##############
## Q6. For each department, how many students passed with a grades over 80?
##############

depart_stud_80 <-  class_courses_dep_stud %>% filter(degree >=80) %>% 
                    group_by(DepartmentID,DepartmentName) %>% summarise(Over_80 = n_distinct(StudentID))
               
depart_stud_80
  

##############
## Q7. For each department, how many students passed with a grades under 60?
##############

depart_stud_60 <-  class_courses_dep_stud %>% filter(degree <=60) %>% 
  group_by(DepartmentID,DepartmentName) %>% summarise(under_60 = n_distinct(StudentID))

depart_stud_60

##############
## Q8. Rate the teachers by their average student's grades (in descending order).
##############
Teachers_greades <- class_courses_dep_stud %>% group_by(TeacherID) %>% 
        summarise(degree_mean = mean(degree)) %>% arrange(-degree_mean) 
Teachers_greades <- inner_join(Teachers_greades, teachers, by="TeacherID")
        
Teachers_greades
##############
## Q9. Create a dataframe showing the courses, departments they are associated with, 
##     the teacher in each course, and the number of students enrolled in the course 
##     (for each course, department and teacher show the names).
##############
classroom_coursesOUT <- full_join(classroom, courses, by="CourseID")
class_coursesOUT_dep <- inner_join(classroom_coursesOUT, departments, by="DepartmentID")
class_coursesOUT_dep_teach <- left_join(class_coursesOUT_dep, teachers, by="TeacherID")

students_in_courses <- class_coursesOUT_dep_teach %>% select(FirstName,LastName,DepartmentName,CourseName,StudentID) %>%
group_by(CourseName,DepartmentName,FirstName,LastName) %>% summarise(Total_Students = sum(!is.na(StudentID)))

students_in_courses
##############
## Q10. Create a dataframe showing the students, the number of courses they take, 
##      the average of the grades per class, and their overall average (for each student 
##      show the student name).
##############

class_courses_dep_L <- left_join(students ,class_courses_dep, by="StudentID") %>% 
  mutate (Eng = ifelse(DepartmentID==1,1,0),
          Sci = ifelse(DepartmentID==2,1,0),
          Arts = ifelse(DepartmentID==3,1,0),
          sports = ifelse(DepartmentID==4,1,0))%>%
  group_by(StudentID,FirstName,LastName) %>% 
  summarise(EngAvg = sum(degree*Eng)/sum(Eng),
            SciAvg = sum(degree*Sci)/sum(Sci),
            ArtsAvg = sum(degree*Arts)/sum(Arts),
            SportsAvg = sum(degree*sports)/sum(sports),
            Course_No = sum(!is.na(degree)),
            stud_avg = mean(degree))
            
  class_courses_dep_L

