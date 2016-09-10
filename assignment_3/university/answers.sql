SELECT name FROM student WHERE tot_cred > 100;
SELECT course_id, grade FROM takes
	WHERE ID = (SELECT ID FROM student WHERE name = "Tanaka");
SELECT ID, name FROM INstructor
	WHERE ID IN
		(SELECT ID FROM teaches
			WHERE course_id IN
				(SELECT course_id FROM course WHERE dept_name = 'Comp. Sci.'));
SELECT title FROM course
	WHERE course_id IN
		(SELECT course_id FROM section WHERE semester IN ('Fall', 'SprINg'));
SELECT name FROM INstructor WHERE dept_name = 'Comp. Sci.';

SELECT course_id, title FROM course
	WHERE course_id IN
		(SELECT course_id FROM teaches
			WHERE ID = (SELECT ID FROM INstructor WHERE name = 'SrINivasan'));
SELECT name FROM INstructor
	WHERE ID IN
		(SELECT ID FROM teaches WHERE semester = 'SprINg' AND year = 2009);
