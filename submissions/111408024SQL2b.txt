--  Find the id and title of all courses which do not require any
--  prerequisites.
SELECT
    course_id, title
FROM
    course
WHERE
    course_id NOT IN (SELECT
            course_id
        FROM
            prereq);
--  Output
--  +-----------+----------------------------+
--  | course_id | title                      |
--  +-----------+----------------------------+
--  | BIO-101   | Intro. to Biology          |
--  | CS-101    | Intro. to Computer Science |
--  | FIN-201   | Investment Banking         |
--  | HIS-351   | World History              |
--  | MU-199    | Music Video Production     |
--  | PHY-101   | Physical Principles        |
--  +-----------+----------------------------+
--  ----------------------------------------------------------------------------
--  Find the names of students who have not taken any biology dept courses
SELECT
    name
FROM
    student
WHERE
    ID NOT IN (SELECT
            ID
        FROM
            takes
        WHERE
            course_id IN (SELECT
                    course_id
                FROM
                    course
                WHERE
                    dept_name = 'Biology'));
--  Output
--  +----------+
--  | name     |
--  +----------+
--  | Zhang    |
--  | Shankar  |
--  | Brandt   |
--  | Chavez   |
--  | Peltier  |
--  | Levy     |
--  | Williams |
--  | Sanchez  |
--  | Snow     |
--  | Brown    |
--  | Aoi      |
--  | Bourikas |
--  +----------+
--  ----------------------------------------------------------------------------
--  Give a 10% hike to all instructors.
SELECT name, salary FROM instructor;
--  Pre-exec
--  +------------+----------+
--  | name       | salary   |
--  +------------+----------+
--  | Srinivasan | 65000.00 |
--  | Wu         | 90000.00 |
--  | Einstein   | 95000.00 |
--  | El Said    | 60000.00 |
--  | Gold       | 87000.00 |
--  | Katz       | 75000.00 |
--  | Califieri  | 62000.00 |
--  | Singh      | 80000.00 |
--  | Crick      | 72000.00 |
--  | Brandt     | 92000.00 |
--  | Kim        | 80000.00 |
--  +------------+----------+
UPDATE instructor
SET
    salary = 1.1 * salary;
SELECT name, salary FROM instructor;
--  Post-exec
--  +------------+-----------+
--  | name       | salary    |
--  +------------+-----------+
--  | Srinivasan |  71500.00 |
--  | Wu         |  99000.00 |
--  | Einstein   | 104500.00 |
--  | El Said    |  66000.00 |
--  | Gold       |  95700.00 |
--  | Katz       |  82500.00 |
--  | Califieri  |  68200.00 |
--  | Singh      |  88000.00 |
--  | Crick      |  79200.00 |
--  | Brandt     | 101200.00 |
--  | Kim        |  88000.00 |
--  +------------+-----------+
--  ----------------------------------------------------------------------------
--  Increase the tot_creds of all students who have taken the course titled
--  "Genetics"  by the number of credits associated with that course.
SELECT name, tot_cred FROM student;
--  Pre-exec
--  +----------+----------+
--  | name     | tot_cred |
--  +----------+----------+
--  | Zhang    |      102 |
--  | Shankar  |       32 |
--  | Brandt   |       80 |
--  | Chavez   |      110 |
--  | Peltier  |       56 |
--  | Levy     |       46 |
--  | Williams |       54 |
--  | Sanchez  |       38 |
--  | Snow     |        0 |
--  | Brown    |       58 |
--  | Aoi      |       60 |
--  | Bourikas |       98 |
--  | Tanaka   |      120 |
--  +----------+----------+
UPDATE student
SET
    tot_cred = tot_cred + (SELECT
            credits
        FROM
            course
        WHERE
            title = 'Genetics')
WHERE
    student.ID IN (SELECT
            ID
        FROM
            takes
        WHERE
            takes.course_id = (SELECT
                    course_id
                FROM
                    course
                WHERE
                    course.title = 'Genetics'));
SELECT name, tot_cred FROM student;
--  Post-exec
--  +----------+----------+
--  | name     | tot_cred |
--  +----------+----------+
--  | Zhang    |      102 |
--  | Shankar  |       32 |
--  | Brandt   |       80 |
--  | Chavez   |      110 |
--  | Peltier  |       56 |
--  | Levy     |       46 |
--  | Williams |       54 |
--  | Sanchez  |       38 |
--  | Snow     |        0 |
--  | Brown    |       58 |
--  | Aoi      |       60 |
--  | Bourikas |       98 |
--  | Tanaka   |      124 |
--  +----------+----------+
--  ----------------------------------------------------------------------------
--  For all instructors who are advisors of atleast 2 students, increase their
--  salary by 50000.
SELECT name, salary FROM instructor;
--  Pre-exec
--  +------------+-----------+
--  | name       | salary    |
--  +------------+-----------+
--  | Srinivasan |  71500.00 |
--  | Wu         |  99000.00 |
--  | Einstein   | 104500.00 |
--  | El Said    |  66000.00 |
--  | Gold       |  95700.00 |
--  | Katz       |  82500.00 |
--  | Califieri  |  68200.00 |
--  | Singh      |  88000.00 |
--  | Crick      |  79200.00 |
--  | Brandt     | 101200.00 |
--  | Kim        |  88000.00 |
--  +------------+-----------+
UPDATE instructor
SET
    salary = salary + 50000
WHERE
    ID IN (SELECT
            i_ID
        FROM
            (SELECT
                i_ID, COUNT(s_ID) AS n_students
            FROM
                advisor
            GROUP BY i_ID) t
        WHERE
            t.n_students >= 2);
SELECT name, salary FROM instructor;
--  Post-exec
--  +------------+-----------+
--  | name       | salary    |
--  +------------+-----------+
--  | Srinivasan |  71500.00 |
--  | Wu         |  99000.00 |
--  | Einstein   | 154500.00 |
--  | El Said    |  66000.00 |
--  | Gold       |  95700.00 |
--  | Katz       | 132500.00 |
--  | Califieri  |  68200.00 |
--  | Singh      |  88000.00 |
--  | Crick      |  79200.00 |
--  | Brandt     | 101200.00 |
--  | Kim        | 138000.00 |
--  +------------+-----------+
--  ----------------------------------------------------------------------------
--  Set the  credits to 2 for all courses which have less than 5 students taking
--  them (across all sections for the course, across all years/semesters).
SELECT title, credits FROM course;
--  Pre-exec
--  +----------------------------+---------+
--  | title                      | credits |
--  +----------------------------+---------+
--  | Intro. to Biology          |       4 |
--  | Genetics                   |       4 |
--  | Computational Biology      |       3 |
--  | Intro. to Computer Science |       4 |
--  | Game Design                |       4 |
--  | Robotics                   |       3 |
--  | Image Processing           |       3 |
--  | Database System Concepts   |       3 |
--  | Intro. to Digital Systems  |       3 |
--  | Investment Banking         |       3 |
--  | World History              |       3 |
--  | Music Video Production     |       3 |
--  | Physical Principles        |       4 |
--  +----------------------------+---------+
UPDATE course
SET
    credits = 2
WHERE
    course_id IN (SELECT
            course_id
        FROM
            (SELECT
                course_id, COUNT(ID) c
            FROM
                takes
            GROUP BY course_id) q
        WHERE
            q.c < 5);
SELECT title, credits FROM course;
--  Post-exec
--  +----------------------------+---------+
--  | title                      | credits |
--  +----------------------------+---------+
--  | Intro. to Biology          |       2 |
--  | Genetics                   |       2 |
--  | Computational Biology      |       3 |
--  | Intro. to Computer Science |       4 |
--  | Game Design                |       2 |
--  | Robotics                   |       2 |
--  | Image Processing           |       2 |
--  | Database System Concepts   |       2 |
--  | Intro. to Digital Systems  |       2 |
--  | Investment Banking         |       2 |
--  | World History              |       2 |
--  | Music Video Production     |       2 |
--  | Physical Principles        |       2 |
--  +----------------------------+---------+
