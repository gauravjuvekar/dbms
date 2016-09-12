SELECT
    course_id, title
FROM
    course
WHERE
    course_id NOT IN (SELECT
            course_id
        FROM
            prereq);
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

UPDATE instructor
SET
    salary = 1.1 * salary;
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
UPDATE instructor
SET
    salary = salary + 50000
WHERE
    ID IN (SELECT


            (SELECT
            ID
        FROM
            (SELECT
                ID, COUNT(s_ID) AS n_students
            FROM
                instructor
            t.n_students >= 2);
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
