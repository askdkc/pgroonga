CREATE TABLE memos (
  id integer,
  user_name text,
  content varchar(256)
);

CREATE USER alice NOLOGIN;
GRANT ALL ON TABLE memos TO alice;

INSERT INTO memos VALUES
  (1, 'nonexistent', 'PostgreSQL is a RDBMS.');
INSERT INTO memos VALUES
  (2, 'alice', 'Groonga is fast full text search engine.');
INSERT INTO memos VALUES
  (3, 'alice', 'PGroonga is a PostgreSQL extension that uses Groonga.');

ALTER TABLE memos ENABLE ROW LEVEL SECURITY;
CREATE POLICY memos_myself ON memos USING (user_name = current_user);

CREATE INDEX pgrn_index ON memos
 USING pgroonga (content pgroonga_varchar_regexp_ops_v2);

SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = off;

SET SESSION AUTHORIZATION alice;
EXPLAIN (COSTS OFF)
SELECT id, content
  FROM memos
 WHERE content &~ 'groonga';

SELECT id, content
  FROM memos
 WHERE content &~ 'groonga';
RESET SESSION AUTHORIZATION;

DROP TABLE memos;

DROP USER alice;
