CREATE TABLE tags (
  id integer,
  user_name text,
  names text[]
);

CREATE USER alice NOLOGIN;
GRANT ALL ON TABLE tags TO alice;

INSERT INTO tags VALUES (1, 'alice', ARRAY['PostgreSQL', 'PG']);
INSERT INTO tags VALUES (2, 'alice', ARRAY['Groonga', 'grn', 'groonga']);
INSERT INTO tags VALUES (3, 'alice', ARRAY['PGroonga', 'pgrn', 'SQL']);
INSERT INTO tags VALUES (4, 'nonexistent', ARRAY['Mroonga', 'mrn', 'SQL']);

ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
CREATE POLICY tags_myself ON tags USING (user_name = current_user);

SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

SET SESSION AUTHORIZATION alice;
\pset format unaligned
EXPLAIN (COSTS OFF)
SELECT names
  FROM tags
 WHERE names &=~ 'grn OR sql'
 ORDER BY id
\g |sed -r -e "s/\(CURRENT_USER\)::text/CURRENT_USER/g"
\pset format aligned

SELECT names
  FROM tags
 WHERE names &=~ 'grn OR sql'
 ORDER BY id;
RESET SESSION AUTHORIZATION;

DROP TABLE tags;

DROP USER alice;
