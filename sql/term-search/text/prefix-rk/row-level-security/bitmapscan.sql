CREATE TABLE readings (
  id integer,
  user_name text,
  katakana text
);

CREATE USER alice NOLOGIN;
GRANT ALL ON TABLE readings TO alice;

INSERT INTO readings VALUES (1, 'nonexistent', 'ポストグレスキューエル');
INSERT INTO readings VALUES (2, 'alice', 'グルンガ');
INSERT INTO readings VALUES (3, 'alice', 'ピージールンガ');
INSERT INTO readings VALUES (4, 'alice', 'ピージーロジカル');

ALTER TABLE readings ENABLE ROW LEVEL SECURITY;
CREATE POLICY readings_myself ON readings USING (user_name = current_user);

CREATE INDEX pgrn_index ON readings
 USING pgroonga (katakana pgroonga_text_term_search_ops_v2);

SET enable_seqscan = off;
SET enable_indexscan = off;
SET enable_bitmapscan = on;

SET SESSION AUTHORIZATION alice;
EXPLAIN (COSTS OFF)
SELECT katakana
  FROM readings
 WHERE katakana &^~ 'p'
 ORDER BY id;

SELECT katakana
  FROM readings
 WHERE katakana &^~ 'p'
 ORDER BY id;
RESET SESSION AUTHORIZATION;

DROP TABLE readings;

DROP USER alice;
