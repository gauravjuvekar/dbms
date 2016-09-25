CREATE TABLE IF NOT EXISTS person(
	ID    INTEGER PRIMARY KEY,
	name  TEXT,
	email TEXT
);
CREATE TABLE IF NOT EXISTS remotecentre(
	centreId INTEGER PRIMARY KEY,
	college  TEXT,
	town     TEXT,
    state    TEXT
);
CREATE TABLE IF NOT EXISTS programme(
	progId INTEGER PRIMARY KEY,
	title  TEXT,
	fromdate DATE,
	todate   DATE
);
CREATE TABLE IF NOT EXISTS coordinator(
	ID       INTEGER REFERENCES person(ID),
	progId   INTEGER REFERENCES programme(progId),
	centreId INTEGER REFERENCES remotecentre(centreId),
	PRIMARY KEY (ID, progId, centreId)
);
CREATE TABLE IF NOT EXISTS participant(
	ID       INTEGER REFERENCES person(ID),
	progId   INTEGER REFERENCES programme(progId),
	centreId INTEGER REFERENCES remotecentre(centreId),
	PRIMARY KEY (ID, progId, centreId)
);

