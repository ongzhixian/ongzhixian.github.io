# SQLite3 notes

Each value stored in an SQLite database (or manipulated by the database engine) has one of the following storage classes:

NULL    . The value is a NULL value.
INTEGER . The value is a signed integer, stored in 1, 2, 3, 4, 6, or 8 bytes depending on the magnitude of the value.
REAL    . The value is a floating point value, stored as an 8-byte IEEE floating point number.
TEXT    . The value is a text string, stored using the database encoding (UTF-8, UTF-16BE or UTF-16LE).
BLOB    . The value is a blob of data, stored exactly as it was input.

Boolean values are stored as integers 0 (false) and 1 (true).
Date values are stored as one of the following:
    TEXT as ISO8601 strings ("YYYY-MM-DD HH:MM:SS.SSS").
    REAL as Julian day numbers, the number of days since noon in Greenwich on November 24, 4714 B.C. according to the proleptic Gregorian calendar.
    INTEGER as Unix Time, the number of seconds since 1970-01-01 00:00:00 UTC.


-- Pending creation




-- CREATED


CREATE TABLE raw_url (
            id          integer,
            timestamp   text,
            url         text,
            status      integer,
            PRIMARY KEY (id)
            )


CREATE TABLE "todo" (
    "id"	        INTEGER,
    "title"	        TEXT NOT NULL,
    "description"   TEXT,
    "start_date"	TEXT NULL,
    "end_date"	    TEXT NULL,
    "parent_id"     INTEGER NULL,
    PRIMARY KEY("id")
);



CREATE TABLE "tag" (
	"id"	INTEGER,
	"text"	TEXT NOT NULL,
	"norm"	TEXT NOT NULL UNIQUE,
	"assoc_id"	INTEGER,
	PRIMARY KEY("id")
);


CREATE TABLE "domain" (
    "id"	INTEGER,
    "name"	TEXT NOT NULL,
    PRIMARY KEY("id")
);

CREATE TABLE "topic" (
	"id"	INTEGER,
	"title"	TEXT,
	"url"	TEXT,
	"host"  TEXT,
    "hash"	TEXT,
	"count"	INTEGER NOT NULL DEFAULT 0,
	"status"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id")
)

CREATE TABLE "topic_tag" (
	"topic_id"	INTEGER,
    "tag_id"	INTEGER,
	PRIMARY KEY("topic_id", "tag_id")
)

CREATE TABLE "tag_assoc" (
	"tag_id"	INTEGER,
    "assoc_tag_id"	INTEGER,
	PRIMARY KEY("tag_id", "assoc_tag_id")
)

-- Data proc queries

INSERT INTO "topic" (url, count)
SELECT 	url
		, COUNT(id) AS "cnt"
FROM 	raw_url
WHERE   status = 0
GROUP BY 
		url
ORDER BY url;

UPDATE  raw_url
SET     status = 1
WHERE   status = 0;


0000 0000   000 - Unprocessed
0000 0001   001 - Host retrieved
0000 0010   002 
0000 0100   004
0000 1000   008
0001 0000   016
0010 0000   032
0100 0000   064
1000 0000   128
1111 1111   255 - Error