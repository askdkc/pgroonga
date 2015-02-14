CREATE TABLE memos (
  title text,
  tags text[]
);

INSERT INTO memos VALUES ('PostgreSQL', ARRAY['PostgreSQL']);
INSERT INTO memos VALUES ('Groonga', ARRAY['Groonga']);
INSERT INTO memos VALUES ('PGroonga', ARRAY['PostgreSQL', 'Groonga']);

CREATE INDEX pgroonga_memos_index ON memos USING pgroonga (tags);

SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = off;

SELECT title, tags
  FROM memos
 WHERE tags %% 'Groonga';

DROP TABLE memos;
