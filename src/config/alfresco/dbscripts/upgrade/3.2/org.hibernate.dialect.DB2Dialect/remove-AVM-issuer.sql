--
-- Title:      Upgrade to V3.2 - Remove AVM Issuer 
-- Database:   DB2
-- Since:      V3.2 schema 2008
-- Author:     
--
-- remove AVM node issuer - replace with identity id
--
-- Please contact support@alfresco.com if you need assistance with the upgrade.
--

-- -----------------------------
-- Enable identity --
-- -----------------------------

ALTER TABLE avm_nodes DROP FOREIGN KEY fk_avm_n_acl;
ALTER TABLE avm_nodes DROP FOREIGN KEY fk_avm_n_store;

--ASSIGN:avm_nodes_max_id=next_val
SELECT CASE WHEN MAX(id) IS NOT NULL THEN MAX(id)+1 ELSE 1 END AS next_val FROM avm_nodes;

CREATE TABLE t_avm_nodes (
   id BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH ${avm_nodes_max_id}),
   class_type VARCHAR(80) NOT NULL,
   vers BIGINT NOT NULL,
   version_id INTEGER NOT NULL,
   guid VARCHAR(144),
   creator VARCHAR(1020) NOT NULL,
   owner VARCHAR(1020) NOT NULL,
   lastModifier VARCHAR(1020) NOT NULL,
   createDate BIGINT NOT NULL,
   modDate BIGINT NOT NULL,
   accessDate BIGINT NOT NULL,
   is_root SMALLINT,
   store_new_id BIGINT,
   acl_id BIGINT,
   deletedType INTEGER,
   layer_id BIGINT,
   indirection VARCHAR(2044),
   indirection_version INTEGER,
   primary_indirection SMALLINT,
   opacity SMALLINT,
   content_url VARCHAR(512),
   mime_type VARCHAR(256),
   encoding VARCHAR(64),
   length BIGINT,
   PRIMARY KEY (id)
 );

CREATE INDEX fk_avm_n_acl ON t_avm_nodes (acl_id); -- (optional)
CREATE INDEX fk_avm_n_store ON t_avm_nodes (store_new_id); -- (optional)

-- migrate data 

INSERT INTO t_avm_nodes ( 
   id, class_type, vers, version_id, guid, creator, owner, lastModifier, createDate, modDate, accessDate,
   is_root, store_new_id, acl_id, deletedType, layer_id, indirection, indirection_version,
   primary_indirection, opacity, content_url, mime_type, encoding, length 
   )
SELECT
   id, class_type, vers, version_id, guid, creator, owner, lastModifier, createDate, modDate, accessDate,
   is_root, store_new_id, acl_id, deletedType, layer_id, indirection, indirection_version,
   primary_indirection, opacity, content_url, mime_type, encoding, length
FROM avm_nodes where id != 0;

INSERT INTO t_avm_nodes ( 
   class_type, vers, version_id, guid, creator, owner, lastModifier, createDate, modDate, accessDate,
   is_root, store_new_id, acl_id, deletedType, layer_id, indirection, indirection_version,
   primary_indirection, opacity, content_url, mime_type, encoding, length 
   )
SELECT
   class_type, vers, version_id, guid, creator, owner, lastModifier, createDate, modDate, accessDate,
   is_root, store_new_id, acl_id, deletedType, layer_id, indirection, indirection_version,
   primary_indirection, opacity, content_url, mime_type, encoding, length
FROM avm_nodes where id = 0;

-- drop existing foreign keys

ALTER TABLE avm_aspects DROP FOREIGN KEY fk_avm_nasp_n;
ALTER TABLE avm_child_entries DROP FOREIGN KEY fk_avm_ce_child;
ALTER TABLE avm_child_entries DROP FOREIGN KEY fk_avm_ce_parent;
ALTER TABLE avm_history_links DROP FOREIGN KEY fk_avm_hl_ancestor;
ALTER TABLE avm_history_links DROP FOREIGN KEY fk_avm_hl_desc;
ALTER TABLE avm_merge_links DROP FOREIGN KEY fk_avm_ml_from;
ALTER TABLE avm_merge_links DROP FOREIGN KEY fk_avm_ml_to;
ALTER TABLE avm_node_properties DROP FOREIGN KEY fk_avm_nprop_n;
ALTER TABLE avm_stores DROP FOREIGN KEY fk_avm_s_root;
ALTER TABLE avm_version_roots DROP FOREIGN KEY fk_avm_vr_root;

-- switch tables
DROP TABLE avm_nodes;
RENAME t_avm_nodes TO avm_nodes;

ALTER TABLE avm_nodes ADD CONSTRAINT fk_avm_n_acl FOREIGN KEY (acl_id) REFERENCES alf_access_control_list (id);
ALTER TABLE avm_nodes ADD CONSTRAINT fk_avm_n_store FOREIGN KEY (store_new_id) REFERENCES avm_stores (id);

update avm_aspects set node_id = (select max(id) from avm_nodes) where node_id = 0;
update avm_child_entries set parent_id = (select max(id) from avm_nodes) where parent_id = 0;
update avm_child_entries set child_id = (select max(id) from avm_nodes) where child_id = 0;
update avm_history_links set ancestor = (select max(id) from avm_nodes) where ancestor = 0;
update avm_history_links set descendent = (select max(id) from avm_nodes) where descendent = 0;
update avm_merge_links set mfrom = (select max(id) from avm_nodes) where mfrom = 0;
update avm_merge_links set mto = (select max(id) from avm_nodes) where mto = 0;
update avm_node_properties set node_id = (select max(id) from avm_nodes) where node_id = 0;
update avm_stores set current_root_id = (select max(id) from avm_nodes) where current_root_id = 0;
update avm_version_roots set root_id = (select max(id) from avm_nodes) where root_id = 0;

-- recreate foreign keys

ALTER TABLE avm_aspects ADD CONSTRAINT fk_avm_nasp_n FOREIGN KEY (node_id) REFERENCES avm_nodes (id);
ALTER TABLE avm_child_entries  ADD CONSTRAINT fk_avm_ce_child FOREIGN KEY (child_id) REFERENCES avm_nodes (id);
ALTER TABLE avm_child_entries  ADD CONSTRAINT fk_avm_ce_parent FOREIGN KEY (parent_id) REFERENCES avm_nodes (id);
ALTER TABLE avm_history_links ADD CONSTRAINT fk_avm_hl_ancestor FOREIGN KEY (ancestor) REFERENCES avm_nodes (id);
ALTER TABLE avm_history_links ADD CONSTRAINT fk_avm_hl_desc FOREIGN KEY (descendent) REFERENCES avm_nodes (id);
ALTER TABLE avm_merge_links ADD CONSTRAINT fk_avm_ml_from FOREIGN KEY (mfrom) REFERENCES avm_nodes (id);
ALTER TABLE avm_merge_links ADD CONSTRAINT fk_avm_ml_to FOREIGN KEY (mto) REFERENCES avm_nodes (id);
ALTER TABLE avm_node_properties ADD CONSTRAINT fk_avm_nprop_n FOREIGN KEY (node_id) REFERENCES avm_nodes (id);
ALTER TABLE avm_stores ADD CONSTRAINT fk_avm_s_root FOREIGN KEY (current_root_id) REFERENCES avm_nodes (id);
ALTER TABLE avm_version_roots ADD CONSTRAINT fk_avm_vr_root FOREIGN KEY (root_id) REFERENCES avm_nodes (id);

-- drop issuer table

DROP TABLE avm_issuer_ids;

--
-- Record script finish
--
DELETE FROM alf_applied_patch WHERE id = 'patch.db-V3.2-Remove-AVM-Issuer';
INSERT INTO alf_applied_patch
  (id, description, fixes_from_schema, fixes_to_schema, applied_to_schema, target_schema, applied_on_date, applied_to_server, was_executed, succeeded, report)
  VALUES
  (
    'patch.db-V3.2-Remove-AVM-Issuer', 'Manually executed script upgrade V3.2 to remove AVM Issuer',
     0, 2007, -1, 2008, null, 'UNKNOWN', ${TRUE}, ${TRUE}, 'Script completed'
   );
