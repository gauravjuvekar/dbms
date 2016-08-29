select name from student where tot_cred > 100;
select course_id, grade from takes
	where ID = (select ID from student where name = "Tanaka");
select ID, name from instructor
	where ID in
		(select ID from teaches
			where course_id in
				(select course_id from course where dept_name = 'Comp. Sci.'));
select title from course
	where course_id in
		(select course_id from section where semester in ('Fall', 'Spring'));
select name from instructor where dept_name = 'Comp. Sci.';

select course_id, title from course
	where course_id in
		(select course_id from teaches
			where ID = (select ID from instructor where name = 'Srinivasan'));
select name from instructor
	where ID in
		(select ID from teaches where semester = 'Spring' and year = 2009);
