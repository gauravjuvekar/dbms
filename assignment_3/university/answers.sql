SELECT
    name
FROM
    student
WHERE
    tot_cred > 100;
SELECT
    course_id, grade
FROM
    takes
WHERE
    ID = (SELECT
            ID
        FROM
            student
        WHERE
            name = 'Tanaka');
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
SELECT
    name
FROM
    instructor
WHERE
    dept_name = 'Comp. Sci.';

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
