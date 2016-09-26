--  Each offering of a course (i.e. a section) can have many Teaching
--  assistants; each teaching assistant is a student. Extend the existing
--  schema(Add/Alter tables) to accommodate this requirement.
CREATE TABLE IF NOT EXISTS teaching_assistant(
	course_id VARCHAR(8),
	sec_id    VARCHAR(8),
	semester  VARCHAR(6),
	year      NUMERIC(4, 0),
	s_id      VARCHAR(5),

	PRIMARY KEY (course_id, sec_id, semester, year, s_id),
	FOREIGN KEY (course_id, sec_id, semester, year)
	    REFERENCES section(course_id, sec_id, semester, year),
	FOREIGN KEY (s_id) REFERENCES student(ID)
);
--  ----------------------------------------------------------------------------
--  Alter the schema to allow a student to have multiple advisors and make sure
--  that you are able to insert multiple advisors for a student.
BEGIN TRANSACTION;
ALTER TABLE advisor DROP CONSTRAINT advisor_pkey;
ALTER TABLE advisor ADD PRIMARY KEY (s_id, i_id);
COMMIT;
BEGIN TRANSACTION;
INSERT INTO advisor VALUES('00128', '10101');
INSERT INTO advisor VALUES('00128', '98345');
INSERT INTO advisor VALUES('00128', '76766');
COMMIT;

SELECT * FROM advisor WHERE s_id = '00128';

--  Output
--   s_id  | i_id
--  -------+-------
--   00128 | 45565
--   00128 | 10101
--   00128 | 98345
--   00128 | 76766
--  ----------------------------------------------------------------------------
--  Find all students who have more than 3 advisors
SELECT s_id
FROM (
	SELECT s_id, COUNT(i_id) AS c
	FROM advisor
	GROUP BY s_id) t
WHERE
    c > 3;
--  Output
--   s_id
--  -------
--   00128
--  ----------------------------------------------------------------------------
--  Find all students who are co-advised by Prof. Srinivas and Prof. Ashok.
--  NOTE: changing Ashok to Kim since Ashok is not in advisor
SELECT s_id
FROM (
	SELECT s_id, COUNT(i_id) c
	FROM advisor a JOIN instructor i ON a.i_id = i.ID
	WHERE i.name = 'Srinivasan' OR i.name = 'Kim'
	GROUP BY s_id) t
WHERE c = 2;
--  Output
--   s_id
--  -------
--   00128
--  ----------------------------------------------------------------------------
--  Find students advised by instructors from different departments. etc.
SELECT s_id
FROM (
	SELECT s_id, COUNT(i.dept_name) c
	FROM advisor a JOIN instructor i ON a.i_id = i.ID
	GROUP BY s_id) t
WHERE c > 1;
--  Output
--   s_id
--  -------
--   00128
--  ----------------------------------------------------------------------------
--  Delete all information in the database which is more than 10 years old. Add
--  data as necessary to verify your query.
--  NOTE: Deleting information which is more than than 6 years old instead of 10
--  years as this information already exists.

--  Pre-exec
SELECT * FROM section;
--   course_id | sec_id | semester | year | building | room_number | time_slot_id
--  -----------+--------+----------+------+----------+-------------+--------------
--   BIO-101   | 1      | Summer   | 2009 | Painter  | 514         | B
--   BIO-301   | 1      | Summer   | 2010 | Painter  | 514         | A
--   CS-101    | 1      | Fall     | 2009 | Packard  | 101         | H
--   CS-101    | 1      | Spring   | 2010 | Packard  | 101         | F
--   CS-190    | 1      | Spring   | 2009 | Taylor   | 3128        | E
--   CS-190    | 2      | Spring   | 2009 | Taylor   | 3128        | A
--   CS-315    | 1      | Spring   | 2010 | Watson   | 120         | D
--   CS-319    | 1      | Spring   | 2010 | Watson   | 100         | B
--   CS-319    | 2      | Spring   | 2010 | Taylor   | 3128        | C
--   CS-347    | 1      | Fall     | 2009 | Taylor   | 3128        | A
--   EE-181    | 1      | Spring   | 2009 | Taylor   | 3128        | C
--   FIN-201   | 1      | Spring   | 2010 | Packard  | 101         | B
--   HIS-351   | 1      | Spring   | 2010 | Painter  | 514         | C
--   MU-199    | 1      | Spring   | 2010 | Packard  | 101         | D
--   PHY-101   | 1      | Fall     | 2009 | Watson   | 100         | A
SELECT * FROM teaches;
--    id   | course_id | sec_id | semester | year
--  -------+-----------+--------+----------+------
--   10101 | CS-101    | 1      | Fall     | 2009
--   10101 | CS-315    | 1      | Spring   | 2010
--   10101 | CS-347    | 1      | Fall     | 2009
--   12121 | FIN-201   | 1      | Spring   | 2010
--   15151 | MU-199    | 1      | Spring   | 2010
--   22222 | PHY-101   | 1      | Fall     | 2009
--   32343 | HIS-351   | 1      | Spring   | 2010
--   45565 | CS-101    | 1      | Spring   | 2010
--   45565 | CS-319    | 1      | Spring   | 2010
--   76766 | BIO-101   | 1      | Summer   | 2009
--   76766 | BIO-301   | 1      | Summer   | 2010
--   83821 | CS-190    | 1      | Spring   | 2009
--   83821 | CS-190    | 2      | Spring   | 2009
--   83821 | CS-319    | 2      | Spring   | 2010
--   98345 | EE-181    | 1      | Spring   | 2009
SELECT * FROM takes;
--    id   | course_id | sec_id | semester | year | grade
--  -------+-----------+--------+----------+------+-------
--   00128 | CS-101    | 1      | Fall     | 2009 | A
--   00128 | CS-347    | 1      | Fall     | 2009 | A-
--   12345 | CS-101    | 1      | Fall     | 2009 | C
--   12345 | CS-190    | 2      | Spring   | 2009 | A
--   12345 | CS-315    | 1      | Spring   | 2010 | A
--   12345 | CS-347    | 1      | Fall     | 2009 | A
--   19991 | HIS-351   | 1      | Spring   | 2010 | B
--   23121 | FIN-201   | 1      | Spring   | 2010 | C+
--   44553 | PHY-101   | 1      | Fall     | 2009 | B-
--   45678 | CS-101    | 1      | Fall     | 2009 | F
--   45678 | CS-101    | 1      | Spring   | 2010 | B+
--   45678 | CS-319    | 1      | Spring   | 2010 | B
--   54321 | CS-101    | 1      | Fall     | 2009 | A-
--   54321 | CS-190    | 2      | Spring   | 2009 | B+
--   55739 | MU-199    | 1      | Spring   | 2010 | A-
--   76543 | CS-101    | 1      | Fall     | 2009 | A
--   76543 | CS-319    | 2      | Spring   | 2010 | A
--   76653 | EE-181    | 1      | Spring   | 2009 | C
--   98765 | CS-101    | 1      | Fall     | 2009 | C-
--   98765 | CS-315    | 1      | Spring   | 2010 | B
--   98988 | BIO-101   | 1      | Summer   | 2009 | A
--   98988 | BIO-301   | 1      | Summer   | 2010 |
BEGIN TRANSACTION;
DELETE FROM section
WHERE year < (date_part('year', NOW()) - 6);
--  Post-exec
SELECT * FROM section;
--   course_id | sec_id | semester | year | building | room_number | time_slot_id
--  -----------+--------+----------+------+----------+-------------+--------------
--   BIO-301   | 1      | Summer   | 2010 | Painter  | 514         | A
--   CS-101    | 1      | Spring   | 2010 | Packard  | 101         | F
--   CS-315    | 1      | Spring   | 2010 | Watson   | 120         | D
--   CS-319    | 1      | Spring   | 2010 | Watson   | 100         | B
--   CS-319    | 2      | Spring   | 2010 | Taylor   | 3128        | C
--   FIN-201   | 1      | Spring   | 2010 | Packard  | 101         | B
--   HIS-351   | 1      | Spring   | 2010 | Painter  | 514         | C
--   MU-199    | 1      | Spring   | 2010 | Packard  | 101         | D
SELECT * FROM teaches;
--    id   | course_id | sec_id | semester | year
--  -------+-----------+--------+----------+------
--   10101 | CS-315    | 1      | Spring   | 2010
--   12121 | FIN-201   | 1      | Spring   | 2010
--   15151 | MU-199    | 1      | Spring   | 2010
--   32343 | HIS-351   | 1      | Spring   | 2010
--   45565 | CS-101    | 1      | Spring   | 2010
--   45565 | CS-319    | 1      | Spring   | 2010
--   76766 | BIO-301   | 1      | Summer   | 2010
--   83821 | CS-319    | 2      | Spring   | 2010
SELECT * FROM takes;
--    id   | course_id | sec_id | semester | year | grade
--  -------+-----------+--------+----------+------+-------
--   12345 | CS-315    | 1      | Spring   | 2010 | A
--   19991 | HIS-351   | 1      | Spring   | 2010 | B
--   23121 | FIN-201   | 1      | Spring   | 2010 | C+
--   45678 | CS-101    | 1      | Spring   | 2010 | B+
--   45678 | CS-319    | 1      | Spring   | 2010 | B
--   55739 | MU-199    | 1      | Spring   | 2010 | A-
--   76543 | CS-319    | 2      | Spring   | 2010 | A
--   98765 | CS-315    | 1      | Spring   | 2010 | B
--   98988 | BIO-301   | 1      | Summer   | 2010 |

-- Because we will be needing the data later.
ROLLBACK TRANSACTION;
--  ----------------------------------------------------------------------------
--  Delete the course CS 101.  Any course which has CS 101 as a prereq should
--  remove CS 101 from its prereq set.  Create a cascade constraint to enforce
--  the above rule, and verify that it is working.
BEGIN TRANSACTION;
ALTER TABLE prereq DROP CONSTRAINT prereq_prereq_id_fkey;
ALTER TABLE prereq
	ADD CONSTRAINT prereq_prereq_id_fkey
		FOREIGN KEY (prereq_id)
		REFERENCES course(course_id)
		ON DELETE CASCADE;
COMMIT TRANSACTION;

BEGIN TRANSACTION;
-- Pre-exec
SELECT * FROM course;
--   course_id |           title            | dept_name  | credits
--  -----------+----------------------------+------------+---------
--   BIO-101   | Intro. to Biology          | Biology    |       4
--   BIO-301   | Genetics                   | Biology    |       4
--   BIO-399   | Computational Biology      | Biology    |       3
--   CS-101    | Intro. to Computer Science | Comp. Sci. |       4
--   CS-190    | Game Design                | Comp. Sci. |       4
--   CS-315    | Robotics                   | Comp. Sci. |       3
--   CS-319    | Image Processing           | Comp. Sci. |       3
--   CS-347    | Database System Concepts   | Comp. Sci. |       3
--   EE-181    | Intro. to Digital Systems  | Elec. Eng. |       3
--   FIN-201   | Investment Banking         | Finance    |       3
--   HIS-351   | World History              | History    |       3
--   MU-199    | Music Video Production     | Music      |       3
--   PHY-101   | Physical Principles        | Physics    |       4
SELECT * FROM prereq;
--   course_id | prereq_id
--  -----------+-----------
--   BIO-301   | BIO-101
--   BIO-399   | BIO-101
--   CS-190    | CS-101
--   CS-315    | CS-101
--   CS-319    | CS-101
--   CS-347    | CS-101
--   EE-181    | PHY-101
DELETE FROM course WHERE course_id = 'CS-101';
--  Post-exec
SELECT * FROM course;
--   course_id |           title            | dept_name  | credits
--  -----------+----------------------------+------------+---------
--   BIO-101   | Intro. to Biology          | Biology    |       4
--   BIO-301   | Genetics                   | Biology    |       4
--   BIO-399   | Computational Biology      | Biology    |       3
--   CS-190    | Game Design                | Comp. Sci. |       4
--   CS-315    | Robotics                   | Comp. Sci. |       3
--   CS-319    | Image Processing           | Comp. Sci. |       3
--   CS-347    | Database System Concepts   | Comp. Sci. |       3
--   EE-181    | Intro. to Digital Systems  | Elec. Eng. |       3
--   FIN-201   | Investment Banking         | Finance    |       3
--   HIS-351   | World History              | History    |       3
--   MU-199    | Music Video Production     | Music      |       3
--   PHY-101   | Physical Principles        | Physics    |       4
SELECT * FROM prereq;
--   course_id | prereq_id
--  -----------+-----------
--   BIO-301   | BIO-101
--   BIO-399   | BIO-101
--   EE-181    | PHY-101

-- Because we need the data later
ROLLBACK TRANSACTION;
