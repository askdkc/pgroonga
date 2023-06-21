CREATE TABLE tags (
  names varchar[]
);

INSERT INTO tags VALUES (ARRAY['PostgreSQL', 'ポスグレ']);
INSERT INTO tags VALUES (ARRAY['Groonga', 'グルンガ']);
INSERT INTO tags VALUES (ARRAY['PGroonga', 'ピージールンガ']);

CREATE INDEX pgroonga_index ON tags
  USING pgroonga (names pgroonga_varchar_array_term_search_ops_v2)
  WITH (normalizer = 'NormalizerNFKC150("unify_kana", true)');

SET enable_seqscan = on;
SET enable_indexscan = off;
SET enable_bitmapscan = off;

EXPLAIN (COSTS OFF)
SELECT names
  FROM tags
 WHERE names &=~ ('ぽすぐれ OR ぐるんが', NULL, 'pgroonga_index')::pgroonga_full_text_search_condition;

SELECT names
  FROM tags
 WHERE names &=~ ('ぽすぐれ OR ぐるんが', NULL, 'pgroonga_index')::pgroonga_full_text_search_condition;

DROP TABLE tags;
