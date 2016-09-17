--  Find pairs of stations (station codes) that have a track (direct connection)
--  with distance less than 20Kms between them.
SELECT
    stcode1, stcode2
FROM
    track
WHERE
    distance < 20;
--  Output
--  +---------+---------+
--  | stcode1 | stcode2 |
--  +---------+---------+
--  | BYC     | DR      |
--  | BYC     | KRL     |
--  | CST     | BYC     |
--  | CST     | DR      |
--  | CST     | KRL     |
--  | GRP     | TNA     |
--  +---------+---------+
-- -----------------------------------------------------------------------------
--  Find the IDs of all the trains which have a stop at THANE
SELECT
    id
FROM
    trainhalts
WHERE
    stcode = (SELECT
            stcode
        FROM
            station
        WHERE
            name = 'Thane')
        AND timein != timeout;
--  Output
--  +------+
--  | id   |
--  +------+
--  | A65  |
--  | KP11 |
--  +------+
-- -----------------------------------------------------------------------------
--  Find the names of all trains that start at MUMBAI.
SELECT
    name
FROM
    train
WHERE
    id IN (SELECT
            id
        FROM
            trainhalts
        WHERE
            (stcode = (SELECT
                    stcode
                FROM
                    station
                WHERE
                    name = 'MUMBAI'))
                AND ISNULL(timein));
--  Output
--  +---------------+
--  | name          |
--  +---------------+
--  | CST-AMR_LOCAL |
--  | CST-KYN       |
--  +---------------+
-- -----------------------------------------------------------------------------
--  List all the stations in order of visit by the train 'CST-AMR_LOCAL'.
SELECT
    name
FROM
    (trainhalts t
    JOIN station s ON t.stcode = s.stcode)
WHERE
    id = (SELECT
            id
        FROM
            train
        WHERE
            name = 'CST-AMR_LOCAL')
ORDER BY seqno ASC;
--  Output
--  +-----------+
--  | name      |
--  +-----------+
--  | MUMBAI    |
--  | BYCULLA   |
--  | DADAR     |
--  | KURLA     |
--  | GHATKOPAR |
--  | THANE     |
--  | DOMBIVALI |
--  | KALYAN    |
--  | AMBARNATH |
--  +-----------+
-- -----------------------------------------------------------------------------
--  Find the name of the trains which have stop at Thane, before the 6th station
--  in the route of the train.
SELECT
    name
FROM
    train
WHERE
    id IN (SELECT
            id
        FROM
            trainhalts
        WHERE
            stcode = (SELECT
                    stcode
                FROM
                    station
                WHERE
                    name = 'THANE')
                AND seqno < 6);
--  Output
--  +---------------+
--  | name          |
--  +---------------+
--  | CST-AMR_LOCAL |
--  +---------------+
