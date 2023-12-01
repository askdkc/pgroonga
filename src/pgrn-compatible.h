#pragma once

#include <postgres.h>

#ifdef WIN32
#	define PRId64 "I64d"
#	define PRIu64 "I64u"
#	define PGRN_PRIdSIZE "Id"
#	define PGRN_PRIuSIZE "Iu"
#else
#	include <inttypes.h>
#	define PGRN_PRIdSIZE "zd"
#	define PGRN_PRIuSIZE "zu"
#endif

#ifdef PGRN_HAVE_MSGPACK
#	define PGRN_SUPPORT_WAL
#endif

#if PG_VERSION_NUM >= 120000
#	define PGRN_SUPPORT_INDEX_CLAUSE
#	define PGRN_SUPPORT_TABLEAM
#	define PGRN_HAVE_OPTIMIZER_H
#endif

#if PG_VERSION_NUM >= 130000
#	define PGRN_SUPPORT_OPTION_LOCK_MODE
#	define PGRN_HAVE_BUILD_RELOPTIONS
#	define PGRN_HAVE_JSONB_DATETIME
#	define PGRN_INDEX_BUILD_CALLBACK_USE_ITEM_POINTER
#endif

#if PG_VERSION_NUM >= 160000
#	define PGRN_HAVE_VARATT_H
#endif

#ifndef ERRCODE_SYSTEM_ERROR
#	define ERRCODE_SYSTEM_ERROR ERRCODE_IO_ERROR
#endif

#ifndef ALLOCSET_DEFAULT_SIZES
#	define ALLOCSET_DEFAULT_SIZES				\
	ALLOCSET_DEFAULT_MINSIZE,					\
	ALLOCSET_DEFAULT_INITSIZE,					\
	ALLOCSET_DEFAULT_MAXSIZE
#endif

#if PG_VERSION_NUM >= 140000
#	define PGRN_AM_INSERT_HAVE_INDEX_UNCHANGED
#endif

#define pgrn_array_create_iterator(array, slide_ndim)	\
	array_create_iterator(array, slide_ndim, NULL)

#if PG_VERSION_NUM >= 120000
#	define PGrnIndexBuildHeapScan(heap,				\
								  index,			\
								  indexInfo,		\
								  allowSync,		\
								  callback,			\
								  callbackState)	\
	table_index_build_scan((heap),					\
						   (index),					\
						   (indexInfo),				\
						   (allowSync),				\
						   true,					\
						   (callback),				\
						   (callbackState),			\
						   NULL)
#else
#	define PGrnIndexBuildHeapScan(heap,				\
								  index,			\
								  indexInfo,		\
								  allowSync,		\
								  callback,			\
								  callbackState)	\
	IndexBuildHeapScan((heap),						\
					   (index),						\
					   (indexInfo),					\
					   (allowSync),					\
					   (callback),					\
					   (callbackState),				\
					   NULL)
#endif

#if PG_VERSION_NUM >= 120000
#	define PGRN_INDEX_SCAN_DESC_SET_FOUND_CTID(scan, ctid) \
	((scan)->xs_heaptid = (ctid))
#else
#	define PGRN_INDEX_SCAN_DESC_SET_FOUND_CTID(scan, ctid) \
	((scan)->xs_ctup.t_self = (ctid))
#endif

#if PG_VERSION_NUM >= 120000
#	define PGRN_RELATION_GET_RD_INDAM(relation) (relation)->rd_indam
#else
#	define PGRN_RELATION_GET_RD_INDAM(relation) (relation)->rd_amroutine
#endif

#ifdef PGRN_SUPPORT_TABLEAM
#	define PGrnTableScanDesc TableScanDesc
#	define pgrn_table_beginscan table_beginscan
#	define pgrn_table_beginscan_catalog table_beginscan_catalog
#	define pgrn_table_endscan table_endscan
#	define pgrn_table_open table_open
#	define pgrn_table_close table_close
#else
#	define PGrnTableScanDesc HeapScanDesc
#	define pgrn_table_beginscan heap_beginscan
#	define pgrn_table_beginscan_catalog heap_beginscan_catalog
#	define pgrn_table_endscan heap_endscan
#	define pgrn_table_open heap_open
#	define pgrn_table_close heap_close
#endif

#ifdef PGRN_SUPPORT_OPTION_LOCK_MODE
#	define pgrn_add_string_reloption(kinds,			\
									 name,			\
									 desc,			\
									 default_value,	\
									 validator,		\
									 lock_mode)		\
	add_string_reloption((kinds),					\
						 (name),					\
						 (desc),					\
						 (default_value),			\
						 (validator),				\
						 (lock_mode))
#	define pgrn_add_bool_reloption(kinds,			\
								   name,			\
								   desc,			\
								   default_value,	\
								   lock_mode)		\
	add_bool_reloption((kinds),						\
					   (name),						\
					   (desc),						\
					   (default_value),				\
					   (lock_mode))
#else
#	define pgrn_add_string_reloption(kinds,			\
									 name,			\
									 desc,			\
									 default_value,	\
									 validator,		\
									 lock_mode)		\
	add_string_reloption((kinds),					\
						 (name),					\
						 (desc),					\
						 (default_value),			\
						 (validator))
#	define pgrn_add_bool_reloption(kinds,			\
								   name,			\
								   desc,			\
								   default_value,	\
								   lock_mode)		\
	add_bool_reloption((kinds),						\
					   (name),						\
					   (desc),						\
					   (default_value))
#endif

#if PG_VERSION_NUM >= 120000
#	define PGrnCreateTemplateTupleDesc(natts)	\
	CreateTemplateTupleDesc((natts))
#else
#	define PGrnCreateTemplateTupleDesc(natts)	\
	CreateTemplateTupleDesc((natts), false)
#endif

#if PG_VERSION_NUM >= 120000
#	define PGRN_HAVE_TUPLE_TABLE_SLOT_TABLE_OID
#endif

#if PG_VERSION_NUM >= 120000
#	define PGRN_FORM_PG_DATABASE_HAVE_OID
#endif

#if PG_VERSION_NUM >= 120000
#	define PGRN_SUPPORT_PROGRESS
#endif

#if PG_VERSION_NUM >= 130000
#	define PGRN_WL_EXIT_ON_PM_DEATH WL_EXIT_ON_PM_DEATH
#else
#	define PGRN_WL_EXIT_ON_PM_DEATH WL_POSTMASTER_DEATH
#endif

#if PG_VERSION_NUM >= 130000
#	define PGRN_HAVE_COMMON_HASHFN_H
#	define PGRN_INDEX_AM_ROUTINE_HAVE_AM_USE_MAINTENANCE_WORK_MEM
#	define PGRN_INDEX_AM_ROUTINE_HAVE_AM_PARALLEL_VACUUM_OPTIONS
#endif

#if PG_VERSION_NUM >= 160000
#	define PGRN_RELATION_GET_LOCATOR(relation) ((relation)->rd_locator)
#	define PGRN_RELATION_GET_LOCATOR_NUMBER(relation)	\
	((relation)->rd_locator.relNumber)
#	define PGRN_RELATION_GET_LOCATOR_SPACE(relation)	\
	((relation)->rd_locator.spcOid)
#	include <common/relpath.h>
typedef RelFileNumber PGrnRelFileNumber;
#	define PGrnRelidByRelfilenumber(tablespaceOid, fileNumber)	\
	RelidByRelfilenumber((tablespaceOid), (fileNumber))
#	define pgrn_pg_tablespace_ownercheck(tablespaceOid, userOid)	\
	object_ownercheck(TableSpaceRelationId, (tablespaceOid), (userOid))
#	define pgrn_pg_class_ownercheck(relationOid, userOid)	\
	object_ownercheck(RelationRelationId, (relationOid), (userOid))
#else
#	define PGRN_RELATION_GET_LOCATOR(relation) ((relation)->rd_node)
#	define PGRN_RELATION_GET_LOCATOR_NUMBER(relation)	\
	((relation)->rd_node.relNode)
#	define PGRN_RELATION_GET_LOCATOR_SPACE(relation)	\
	((relation)->rd_node.spcNode)
typedef Oid PGrnRelFileNumber;
#	define PGrnRelidByRelfilenumber(tablespaceOid, fileNumber)	\
	RelidByRelfilenode((tablespaceOid), (fileNumber))
#	define pgrn_pg_tablespace_ownercheck(tablespaceOid, userOid)	\
	pg_tablespace_ownercheck((tablespaceOid), (userOid))
#	define pgrn_pg_class_ownercheck(relationOid, userOid)	\
	pg_class_ownercheck((relationOid), (userOid))
#endif

#if PG_VERSION_NUM >= 150000
#	define PGRN_RELKIND_HAS_PARTITIONS(relkind)	\
	RELKIND_HAS_PARTITIONS(relkind)
#	define PGRN_RELKIND_HAS_TABLE_AM(relkind)	\
	RELKIND_HAS_TABLE_AM(relkind)
#else
#	define PGRN_RELKIND_HAS_PARTITIONS(relkind)	\
	((relkind) == RELKIND_PARTITIONED_TABLE ||	\
	 (relkind) == RELKIND_PARTITIONED_INDEX)
#	define PGRN_RELKIND_HAS_TABLE_AM(relkind)	\
	((relkind) == RELKIND_RELATION ||		\
	 (relkind) == RELKIND_TOASTVALUE ||		\
	 (relkind) == RELKIND_MATVIEW)
#endif
