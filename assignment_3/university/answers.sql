--  Find the names of all the students whose total credits are greater than 100.
SELECT
    name
FROM
    student
WHERE
    tot_cred > 100;
--  Output
--  +--------+
--  | name   |
--  +--------+
--  | Zhang  |
--  | Chavez |
--  | Tanaka |
--  +--------+
--  ----------------------------------------------------------------------------
--  Find the course id and grades of all courses taken by any student named
--  'Tanaka'.
SELECT
    course_id, grade
FROM
    takes
WHERE
    ID =
	(SELECT
            ID
        FROM
            student
		WHERE
            name = 'Tanaka');
--  Output
--  +-----------+-------+
--  | course_id | grade |
--  +-----------+-------+
--  | BIO-101   | A     |
--  | BIO-301   | NULL  |
--  +-----------+-------+
--  ----------------------------------------------------------------------------
--  Find the ID and name of instructors who have taught a course in the Comp.
--  Sci. department, even if they are themselves not from the Comp. Sci.
--  department. To test this query, make sure you add appropriate data, and
--  include the corresponding insert statements along with your query.
SELECT
    ID, name
FROM
    instructor
WHERE
    ID IN (SELECT
            ID
        FROM
            teaches
        WHERE
            course_id IN (SELECT
                    course_id
                FROM
                    course
                WHERE
                    dept_name = 'Comp. Sci.'));
--  Output
--  +-------+------------+
--  | ID    | name       |
--  +-------+------------+
--  | 10101 | Srinivasan |
--  | 45565 | Katz       |
--  | 83821 | Brandt     |
--  +-------+------------+
--  ----------------------------------------------------------------------------
--  Find the courses which are offered in both 'Fall' and 'Spring' semester (not
--  necessarily in the same year).
SELECT
    title
FROM
    course
WHERE
    course_id IN (SELECT
            course_id
        FROM
            section
        WHERE
            semester IN ('Fall' , 'Spring'));
--  Output
--  +----------------------------+
--  | title                      |
--  +----------------------------+
--  | Intro. to Computer Science |
--  | Game Design                |
--  | Robotics                   |
--  | Image Processing           |
--  | Database System Concepts   |
--  | Intro. to Digital Systems  |
--  | Investment Banking         |
--  | World History              |
--  | Music Video Production     |
--  | Physical Principles        |
--  +----------------------------+
--  ----------------------------------------------------------------------------
--  Find the names of all the instructors from Comp. Sci. department.
SELECT
    name
FROM
    instructor
WHERE
    dept_name = 'Comp. Sci.';
--  Output
--  +------------+
--  | name       |
--  +------------+
--  | Srinivasan |
--  | Katz       |
--  | Brandt     |
--  +------------+
--  ----------------------------------------------------------------------------
--  Find the course id and titles of all courses taught by an instructor named
--  'Srinivasan'
SELECT
    course_id, title
FROM
    course
WHERE
    course_id IN (SELECT
            course_id
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
--  +-----------+----------------------------+
--  | course_id | title                      |
--  +-----------+----------------------------+
--  | CS-101    | Intro. to Computer Science |
--  | CS-315    | Robotics                   |
--  | CS-347    | Database System Concepts   |
--  +-----------+----------------------------+
--  ----------------------------------------------------------------------------
--  Find names of instructors who have taught at least one course in Spring
--  2009.
SELECT
    name
FROM
    instructor
WHERE
    ID IN (SELECT
            ID
        FROM
            teaches
        WHERE
            semester = 'Spring' AND year = 2009);
--  Output
--  +--------+
--  | name   |
--  +--------+
--  | Brandt |
--  | Kim    |
--  +--------+
