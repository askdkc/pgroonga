CREATE TABLE tags (
  id integer,
  user_name text,
  names text[]
);

CREATE USER alice NOLOGIN;
GRANT ALL ON TABLE tags TO alice;

INSERT INTO tags VALUES (1, 'nonexistent', ARRAY['PostgreSQL', 'PG']);
INSERT INTO tags VALUES (2, 'alice', ARRAY['Groonga', 'grn']);
INSERT INTO tags VALUES (3, 'alice', ARRAY['PGroonga', 'pgrn']);
INSERT INTO tags VALUES (4, 'alice', ARRAY[]::text[]);

ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
CREATE POLICY tags_myself ON tags USING (user_name = current_user);

SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

SET SESSION AUTHORIZATION alice;
EXPLAIN (COSTS OFF)
SELECT names
  FROM tags
 WHERE names &^| ARRAY['gro', 'pos']
 ORDER BY id;

SELECT names
  FROM tags
 WHERE names &^| ARRAY['gro', 'pos']
 ORDER BY id;
RESET SESSION AUTHORIZATION;

DROP TABLE tags;

DROP USER alice;
