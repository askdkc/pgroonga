CREATE TABLE memos (
  id integer,
  content varchar(4097)
);

INSERT INTO memos VALUES (1, 'PostgreSQL is a RDBMS.');

CREATE INDEX pgrn_index ON memos
 USING pgroonga (content pgroonga_varchar_full_text_search_ops_v2);

INSERT INTO memos VALUES (2, 'Groonga is fast full text search engine.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga.');

SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = off;

EXPLAIN (COSTS OFF)
SELECT id, content
  FROM memos
 WHERE content &@~ 'rdbms OR engine';

SELECT id, content
  FROM memos
 WHERE content &@~ 'rdbms OR engine';

DROP TABLE memos;
