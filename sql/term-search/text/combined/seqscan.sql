CREATE TABLE tags (
  name text PRIMARY KEY
);

CREATE TABLE readings (
  katakana text PRIMARY KEY
);

CREATE TABLE tags_readings (
  tag_name text
    REFERENCES tags ON DELETE CASCADE ON UPDATE CASCADE,
  reading_katakana text
    REFERENCES readings ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (tag_name, reading_katakana)
);

INSERT INTO tags VALUES ('PostgreSQL');
INSERT INTO tags VALUES ('Groonga');
INSERT INTO tags VALUES ('PGroonga');
INSERT INTO tags VALUES ('pglogical');

INSERT INTO readings VALUES ('ポストグレスキューエル');
INSERT INTO readings VALUES ('ポスグレ');
INSERT INTO readings VALUES ('グルンガ');
INSERT INTO readings VALUES ('ピージールンガ');
INSERT INTO readings VALUES ('ピージーロジカル');

INSERT INTO tags_readings VALUES ('PostgreSQL', 'ポストグレスキューエル');
INSERT INTO tags_readings VALUES ('PostgreSQL', 'ポスグレ');
INSERT INTO tags_readings VALUES ('Groonga', 'グルンガ');
INSERT INTO tags_readings VALUES ('PGroonga', 'ピージールンガ');
INSERT INTO tags_readings VALUES ('pglogical', 'ピージーロジカル');

SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

SELECT name, pgroonga.score(tags)
  FROM tags
  WHERE name &^ 'Groon'
UNION
SELECT tag_name, pgroonga.score(readings)
  FROM readings INNER JOIN tags_readings
                  ON readings.katakana = tags_readings.reading_katakana
  WHERE katakana &^~ 'posu';

DROP TABLE tags_readings;
DROP TABLE readings;
DROP TABLE tags;
