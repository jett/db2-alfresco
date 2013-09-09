--
-- Title:      Update ACL Change Set for Change Tracking
-- Database:   DB2
-- Since:      V4.0 Schema 5008
-- Author:     Derek Hulley
--
-- Please contact support@alfresco.com if you need assistance with the upgrade.
--

-- Create table in temp form
CREATE TABLE t_alf_acl_change_set
(
    id BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    commit_time_ms BIGINT,
    PRIMARY KEY (id)
);
CREATE INDEX idx_alf_acs_ctms ON t_alf_acl_change_set (commit_time_ms);

-- Fill with data
--FOREACH alf_acl_change_set.id system.upgrade.alf_acl_change_set.batchsize
INSERT INTO t_alf_acl_change_set
   (
      id, commit_time_ms
   )
   SELECT
      acs.id AS id,
      acs.id AS id2
   FROM
      alf_acl_change_set acs
   WHERE
      id >= ${LOWERBOUND} AND id <= ${UPPERBOUND}
;

-- Drop and rename
ALTER TABLE alf_access_control_list
   DROP CONSTRAINT fk_alf_acl_acs;
DROP TABLE alf_acl_change_set;
RENAME t_alf_acl_change_set TO alf_acl_change_set;
ALTER TABLE alf_access_control_list
   ADD CONSTRAINT fk_alf_acl_acs FOREIGN KEY (acl_change_set) REFERENCES alf_acl_change_set (id);

--
-- Record script finish
--
DELETE FROM alf_applied_patch WHERE id = 'patch.db-V4.0-AclChangeSet';
INSERT INTO alf_applied_patch
  (id, description, fixes_from_schema, fixes_to_schema, applied_to_schema, target_schema, applied_on_date, applied_to_server, was_executed, succeeded, report)
  VALUES
  (
    'patch.db-V4.0-AclChangeSet', 'Manually executed script upgrade V4.0: Update ACL Change Set for Change Tracking',
    0, 5007, -1, 5008, null, 'UNKNOWN', ${TRUE}, ${TRUE}, 'Script completed'
  );