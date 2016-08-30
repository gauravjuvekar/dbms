SELECT stcode1, stcode2 FROM track WHERE distance < 20;
SELECT id
	FROM trainhalts
	WHERE stcode = (SELECT stcode FROM station WHERE name = 'Thane')
	      AND timein != timeout;
SELECT name
	FROM train
	WHERE id IN
		(SELECT id
			FROM trainhalts
			WHERE (stcode = (SELECT stcode FROM station WHERE name = 'MUMBAI'))
			       AND ISNULL(timein));
SELECT name
	FROM (trainhalts t JOIN station s ON t.stcode=s.stcode)
	WHERE id = (SELECT id FROM train WHERE name = 'CST-AMR_LOCAL')
	ORDER BY seqno ASC;
SELECT name
	FROM train
	WHERE id IN
		(SELECT id
			FROM trainhalts
			WHERE stcode = (SELECT stcode FROM station WHERE name = 'THANE')
			      AND seqno < 6);
