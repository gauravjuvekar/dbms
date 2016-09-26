--  Find the number of instructors who have never taught any course. If the
--  result of your query is empty, add appropriate data (and include
--  corresponding insert statements) to ensure the result is not empty.
SELECT
    COUNT(ID)
FROM
    instructor
WHERE
    ID NOT IN (SELECT
            ID
        FROM
            teaches);
--  Output
--  +-----------+
--  | COUNT(ID) |
--  +-----------+
--  |         3 |
--  +-----------+
--  ----------------------------------------------------------------------------
--  Find the total capacity of every building in the university.
SELECT
    building, SUM(capacity)
FROM
    classroom
GROUP BY building;
--  Output
--  +----------+---------------+
--  | building | SUM(capacity) |
--  +----------+---------------+
--  | Packard  |           500 |
--  | Painter  |            10 |
--  | Taylor   |            70 |
--  | Watson   |            80 |
--  +----------+---------------+
--  ----------------------------------------------------------------------------
--  Find the maximum number of teachers for any single course section.  Your
--  output should be a single number.  For example if CS-101 section 1 in Spring
--  2012 had 3 instructors teaching the course, and no other section had more
--  instructors teaching the section, your answer would be 3.
SELECT
    MAX(c)
FROM
    (SELECT
        sec_id, year, semester, COUNT(ID) c
    FROM
        teaches
    GROUP BY course_id , sec_id , year , semester) d;
--  Output
--  +--------+
--  | MAX(c) |
--  +--------+
--  |      1 |
--  +--------+
--  ----------------------------------------------------------------------------
--  Deleting so that output for the next commands has example results.
DELETE FROM instructor WHERE dept_name = 'Music';
--  ----------------------------------------------------------------------------
--  Find all departments that have at least one instructor, and list the names
--  of the departments along with the number of instructors;   order the result
--  in descending order of number of instructors. 
SELECT
    dept_name, COUNT(ID) c
FROM
    instructor
GROUP BY dept_name
ORDER BY c DESC;
--  Output
--  +------------+---+
--  | dept_name  | c |
--  +------------+---+
--  | Comp. Sci. | 3 |
--  | Finance    | 2 |
--  | History    | 2 |
--  | Physics    | 2 |
--  | Elec. Eng. | 1 |
--  | Biology    | 1 |
--  +------------+---+
--  ----------------------------------------------------------------------------
--  As in the previous question, but this time you should include departments
--  even if they do not have any instructor, with the count as 0.
SELECT
    department.dept_name, COUNT(ID) c
FROM
    department
        LEFT OUTER JOIN
    instructor ON department.dept_name = instructor.dept_name
GROUP BY department.dept_name
ORDER BY c DESC;
--  Output
--  +------------+---+
--  | dept_name  | c |
--  +------------+---+
--  | Comp. Sci. | 3 |
--  | Finance    | 2 |
--  | History    | 2 |
--  | Physics    | 2 |
--  | Elec. Eng. | 1 |
--  | Biology    | 1 |
--  | Music      | 0 |
--  +------------+---+
--  ----------------------------------------------------------------------------
--  For each student, compute the total credits they have successfully
--  completed, i.e. total credits of courses they have taken, for which they
--  have a non-null grade other than 'F'. Do NOT use the tot_creids attribute of
--  student.
SELECT
    ID, SUM(credits)
FROM
    (SELECT
        ID, course_id
    FROM
        takes
    WHERE
        grade != 'F') s
        JOIN
    course ON s.course_id = course.course_id
GROUP BY ID;
--  Output
--  +-------+--------------+
--  | ID    | SUM(credits) |
--  +-------+--------------+
--  | 00128 |            7 |
--  | 12345 |           14 |
--  | 19991 |            3 |
--  | 23121 |            3 |
--  | 44553 |            4 |
--  | 45678 |            7 |
--  | 54321 |            8 |
--  | 55739 |            3 |
--  | 76543 |            7 |
--  | 76653 |            3 |
--  | 98765 |            7 |
--  | 98988 |            4 |
--  +-------+--------------+
--  ----------------------------------------------------------------------------
--  Find the number of students who have been taught (at any time) by an
--  instructor named 'Srinivasan'. Make sure you count a student only once even
--  if the student has taken more than one course from Srinivasan.
SELECT
    COUNT(tmp_ids.ID)
FROM
    (SELECT
        takes.ID
    FROM
        takes
    JOIN (SELECT
        *
    FROM
        teaches
    WHERE
        ID = (SELECT
                ID
            FROM
                instructor
            WHERE
                name = 'Srinivasan')) tch ON takes.course_id = tch.course_id
        AND takes.sec_id = tch.sec_id
        AND takes.semester = tch.semester
        AND takes.year = tch.year) tmp_ids;
--  Output
--  +-------------------+
--  | COUNT(tmp_ids.ID) |
--  +-------------------+
--  |                10 |
--  +-------------------+
--  ----------------------------------------------------------------------------
--  Find the name of all instructors who get the highest salary in their
--  department.
SELECT
    name
FROM
    (SELECT
        department.dept_name, MAX(salary) salary
    FROM
        instructor
    JOIN department ON instructor.dept_name = department.dept_name
    GROUP BY department.dept_name) d
        JOIN
    instructor ON instructor.dept_name = d.dept_name
        AND instructor.salary = d.salary;
--  Output
--  +-----------+
--  | name      |
--  +-----------+
--  | Wu        |
--  | Einstein  |
--  | Califieri |
--  | Crick     |
--  | Brandt    |
--  | Kim       |
--  +-----------+
--  ----------------------------------------------------------------------------
--  Find all students who have taken all courses taken by instructor
--  'Srinivasan'. (This is the division operation of relational algebra.) You
--  can implement it by counting the number of courses taught by Srinivasan, and
--  for each student (i.e. group by student), find the number of courses taken
--  by that student, which were taught by Srinivasan. Make sure to count each
--  course ID only once.
--
--  Assumption: The course and exact section must be taught by Srinivasan in
--  the exact year, semester that the student takes it. i.e. the student must be
--  actually taught by Srinivasan.
SELECT
    ID
FROM
    (SELECT
        takes.ID, COUNT(takes.course_id) c
    FROM
        takes
    JOIN teaches ON takes.course_id = teaches.course_id
        AND takes.sec_id = teaches.sec_id
        AND takes.semester = teaches.semester
        AND takes.year = teaches.year
    WHERE
        teaches.ID = (SELECT
                ID
            FROM
                instructor
            WHERE
                name = 'Srinivasan')
    GROUP BY takes.ID) t
WHERE
    c = (SELECT
            COUNT(course_id)
        FROM
            teaches
        WHERE
            ID = (SELECT
                    ID
                FROM
                    instructor
                WHERE
                    name = 'Srinivasan'));
--  Output
--  +-------+
--  | ID    |
--  +-------+
--  | 12345 |
--  +-------+
--  ----------------------------------------------------------------------------
--  Find the total money spent by each department for salaries of instructors of
--  that department.
SELECT
    dept_name, SUM(salary)
FROM
    instructor
GROUP BY dept_name;
--  Output
--  +------------+-------------+
--  | dept_name  | SUM(salary) |
--  +------------+-------------+
--  | Biology    |    72000.00 |
--  | Comp. Sci. |   232000.00 |
--  | Elec. Eng. |    80000.00 |
--  | Finance    |   170000.00 |
--  | History    |   122000.00 |
--  | Physics    |   182000.00 |
--  +------------+-------------+
--  ----------------------------------------------------------------------------
--  Find the names of all students whose advisor has taught the maximum number
--  of courses (multiple offerings of a course count as only 1).
SELECT
    student.name
FROM
    advisor
        JOIN
    student ON advisor.s_ID = student.ID
WHERE
    advisor.i_ID IN (SELECT
            ID
        FROM
            (SELECT
                ID, COUNT(course_id) c
            FROM
                teaches
            GROUP BY ID
            HAVING c = (SELECT
                    MAX(c)
                FROM
                    (SELECT
                    ID, COUNT(course_id) c
                FROM
                    teaches
                GROUP BY ID) t)) i);
--  Output
--  +---------+
--  | name    |
--  +---------+
--  | Shankar |
--  +---------+
