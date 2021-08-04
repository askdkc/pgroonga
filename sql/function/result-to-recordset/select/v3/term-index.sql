CREATE TABLE memos (
  content varchar(256)
);

CREATE INDEX pgrn_index ON memos USING pgroonga (content);

INSERT INTO memos VALUES ('hello');

SELECT pgroonga_result_to_recordset(
    pgroonga_command(
      'select',
      ARRAY[
	'table', pgroonga_table_name('pgrn_index'),
	'output_columns', 'content',
	'command_version', '3'
      ]
    )::jsonb
  );

DROP TABLE memos;
