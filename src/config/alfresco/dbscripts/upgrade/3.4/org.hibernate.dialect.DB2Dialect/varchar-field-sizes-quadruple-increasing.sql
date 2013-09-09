--
-- Title:      Increasing 'VARCHAR' field sizes quadruply for DB2 dialect
-- Database:   Generic
-- Since:      V3.4
-- Author:     Dmitry Velichkevich
--
-- Please contact support@alfresco.com if you need assistance with the upgrade.
--
-- ALF-4300: DB2: Review schema (eg. VARCHAR columns) with respect to multi-byte support (when using DB2 / UTF-8)

-- 
-- Activity Tables
-- 
ALTER TABLE alf_activity_feed ALTER COLUMN activity_summary SET DATA TYPE VARCHAR(4096);
ALTER TABLE alf_activity_feed ALTER COLUMN feed_user_id SET DATA TYPE VARCHAR(1020);
ALTER TABLE alf_activity_feed ALTER COLUMN activity_type SET DATA TYPE VARCHAR(1020);
ALTER TABLE alf_activity_feed ALTER COLUMN activity_format SET DATA TYPE VARCHAR(40);
ALTER TABLE alf_activity_feed ALTER COLUMN site_network SET DATA TYPE VARCHAR(1020);
ALTER TABLE alf_activity_feed ALTER COLUMN app_tool SET DATA TYPE VARCHAR(144);
ALTER TABLE alf_activity_feed ALTER COLUMN post_user_id SET DATA TYPE VARCHAR(1020);

ALTER TABLE alf_activity_feed_control ALTER COLUMN feed_user_id SET DATA TYPE VARCHAR(1020);
ALTER TABLE alf_activity_feed_control ALTER COLUMN site_network SET DATA TYPE VARCHAR(1020);
ALTER TABLE alf_activity_feed_control ALTER COLUMN app_tool SET DATA TYPE VARCHAR(144);

ALTER TABLE alf_activity_post ALTER COLUMN status SET DATA TYPE VARCHAR(40);
ALTER TABLE alf_activity_post ALTER COLUMN activity_data SET DATA TYPE VARCHAR(4096);
ALTER TABLE alf_activity_post ALTER COLUMN post_user_id SET DATA TYPE VARCHAR(1020);
ALTER TABLE alf_activity_post ALTER COLUMN site_network SET DATA TYPE VARCHAR(1020);
ALTER TABLE alf_activity_post ALTER COLUMN app_tool SET DATA TYPE VARCHAR(144);
ALTER TABLE alf_activity_post ALTER COLUMN activity_type SET DATA TYPE VARCHAR(1020);

-- 
-- AVM Tables
-- 
ALTER TABLE avm_child_entries ALTER COLUMN name SET DATA TYPE VARCHAR(640);

ALTER TABLE avm_node_properties ALTER COLUMN string_value SET DATA TYPE VARCHAR(4096);

ALTER TABLE avm_nodes ALTER COLUMN class_type SET DATA TYPE VARCHAR(80);
ALTER TABLE avm_nodes ALTER COLUMN guid SET DATA TYPE VARCHAR(144);
ALTER TABLE avm_nodes ALTER COLUMN creator SET DATA TYPE VARCHAR(1020);
ALTER TABLE avm_nodes ALTER COLUMN owner SET DATA TYPE VARCHAR(1020);
ALTER TABLE avm_nodes ALTER COLUMN lastModifier SET DATA TYPE VARCHAR(1020);
ALTER TABLE avm_nodes ALTER COLUMN indirection SET DATA TYPE VARCHAR(4096);
ALTER TABLE avm_nodes ALTER COLUMN content_url SET DATA TYPE VARCHAR(512);
ALTER TABLE avm_nodes ALTER COLUMN mime_type SET DATA TYPE VARCHAR(400);
ALTER TABLE avm_nodes ALTER COLUMN encoding SET DATA TYPE VARCHAR(64);

ALTER TABLE avm_store_properties ALTER COLUMN string_value SET DATA TYPE VARCHAR(4096);

ALTER TABLE avm_stores ALTER COLUMN name SET DATA TYPE VARCHAR(1020);

ALTER TABLE avm_version_layered_node_entry ALTER COLUMN md5sum SET DATA TYPE VARCHAR(128);
ALTER TABLE avm_version_layered_node_entry ALTER COLUMN path SET DATA TYPE VARCHAR(4096);

ALTER TABLE avm_version_roots ALTER COLUMN creator SET DATA TYPE VARCHAR(1020);
ALTER TABLE avm_version_roots ALTER COLUMN tag SET DATA TYPE VARCHAR(1020);
ALTER TABLE avm_version_roots ALTER COLUMN description SET DATA TYPE VARCHAR(4096);

-- 
-- Content Tables
-- 
ALTER TABLE alf_mimetype ALTER COLUMN mimetype_str SET DATA TYPE VARCHAR(400);

ALTER TABLE alf_encoding ALTER COLUMN encoding_str SET DATA TYPE VARCHAR(400);

ALTER TABLE alf_content_url ALTER COLUMN content_url SET DATA TYPE VARCHAR(1020);
ALTER TABLE alf_content_url ALTER COLUMN content_url_short SET DATA TYPE VARCHAR(48);

-- 
-- Lock Tables
-- 
ALTER TABLE alf_lock_resource ALTER COLUMN qname_localname SET DATA TYPE VARCHAR(1020);

ALTER TABLE alf_lock ALTER COLUMN lock_token SET DATA TYPE VARCHAR(144);

-- 
-- Property Value Tables
-- 
ALTER TABLE alf_prop_class ALTER COLUMN java_class_name SET DATA TYPE VARCHAR(1020);
ALTER TABLE alf_prop_class ALTER COLUMN java_class_name_short SET DATA TYPE VARCHAR(128);

ALTER TABLE alf_prop_string_value ALTER COLUMN string_value SET DATA TYPE VARCHAR(4096);
ALTER TABLE alf_prop_string_value ALTER COLUMN string_end_lower SET DATA TYPE VARCHAR(128);

-- 
-- Repo Tables
-- 
ALTER TABLE alf_applied_patch ALTER COLUMN id SET DATA TYPE VARCHAR(256);
ALTER TABLE alf_applied_patch ALTER COLUMN description SET DATA TYPE VARCHAR(4096);
ALTER TABLE alf_applied_patch ALTER COLUMN applied_to_server SET DATA TYPE VARCHAR(256);
ALTER TABLE alf_applied_patch ALTER COLUMN report SET DATA TYPE VARCHAR(4096);

ALTER TABLE alf_namespace ALTER COLUMN uri SET DATA TYPE VARCHAR(400);

ALTER TABLE alf_qname ALTER COLUMN local_name SET DATA TYPE VARCHAR(800);

ALTER TABLE alf_permission ALTER COLUMN name SET DATA TYPE VARCHAR(400);

ALTER TABLE alf_ace_context ALTER COLUMN class_context SET DATA TYPE VARCHAR(4096);
ALTER TABLE alf_ace_context ALTER COLUMN property_context SET DATA TYPE VARCHAR(4096);
ALTER TABLE alf_ace_context ALTER COLUMN kvp_context SET DATA TYPE VARCHAR(4096);

ALTER TABLE alf_authority ALTER COLUMN authority SET DATA TYPE VARCHAR(400);

ALTER TABLE alf_access_control_list ALTER COLUMN acl_id SET DATA TYPE VARCHAR(144);

ALTER TABLE alf_server ALTER COLUMN ip_address SET DATA TYPE VARCHAR(156);

ALTER TABLE alf_transaction ALTER COLUMN change_txn_id SET DATA TYPE VARCHAR(224);

ALTER TABLE alf_store ALTER COLUMN protocol SET DATA TYPE VARCHAR(200);
ALTER TABLE alf_store ALTER COLUMN identifier SET DATA TYPE VARCHAR(400);

ALTER TABLE alf_node ALTER COLUMN uuid SET DATA TYPE VARCHAR(144);
ALTER TABLE alf_node ALTER COLUMN audit_creator SET DATA TYPE VARCHAR(1020);
ALTER TABLE alf_node ALTER COLUMN audit_created SET DATA TYPE VARCHAR(120);
ALTER TABLE alf_node ALTER COLUMN audit_modifier SET DATA TYPE VARCHAR(1020);
ALTER TABLE alf_node ALTER COLUMN audit_modified SET DATA TYPE VARCHAR(120);
ALTER TABLE alf_node ALTER COLUMN audit_accessed SET DATA TYPE VARCHAR(120);

ALTER TABLE alf_child_assoc ALTER COLUMN child_node_name SET DATA TYPE VARCHAR(200);
ALTER TABLE alf_child_assoc ALTER COLUMN qname_localname SET DATA TYPE VARCHAR(1020);

ALTER TABLE alf_locale ALTER COLUMN locale_str SET DATA TYPE VARCHAR(80);

ALTER TABLE alf_node_properties ALTER COLUMN string_value SET DATA TYPE VARCHAR(4096);

--
-- Record script finish
--
DELETE FROM alf_applied_patch WHERE id = 'patch.db-V3.4-VarcharFieldSizesQuadrupleIncreasing';
INSERT INTO
    alf_applied_patch
    (id, description, fixes_from_schema, fixes_to_schema, applied_to_schema, target_schema, applied_on_date, applied_to_server, was_executed, succeeded, report)
VALUES (
    'patch.db-V3.4-VarcharFieldSizesQuadrupleIncreasing', 'Increasing VARCHAR field sizes quadruply for DB2 dialect V3.4',
    0, 4303, -1, 4304, null, 'UNKOWN', ${TRUE}, ${TRUE}, 'Script completed'
);
