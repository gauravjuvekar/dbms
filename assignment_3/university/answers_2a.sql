SELECT
    COUNT(ID)
FROM
    instructor
WHERE
    ID NOT IN (SELECT
            ID
        FROM
            teaches);
SELECT
    building, SUM(capacity)
FROM
    classroom
GROUP BY building;
SELECT
    MAX(c)
FROM
    (SELECT
        sec_id, year, semester, COUNT(ID) c
    FROM
        teaches
    GROUP BY course_id , sec_id , year , semester) d;
SELECT
    dept_name, COUNT(ID) c
FROM
    instructor
GROUP BY dept_name
ORDER BY c DESC;
SELECT
    department.dept_name, COUNT(ID) c
FROM
    department
        LEFT OUTER JOIN
    instructor ON department.dept_name = instructor.dept_name
GROUP BY department.dept_name
ORDER BY c DESC;
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
SELECT
    dept_name, SUM(salary)
FROM
    instructor
GROUP BY dept_name;
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
