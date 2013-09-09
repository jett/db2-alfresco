--
-- Title:      Fix jbpm tables
-- Database:   DB2
-- Since:      V3.3 schema 4013
-- Author:     janv
--
-- Please contact support@alfresco.com if you need assistance with the upgrade.
--
-- Increase JBPM 3.3.1 default clob(255) (see jbpm.jpdl.db2.sql) to clob(4000)

ALTER TABLE jbpm_action            ALTER COLUMN expression_         SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_comment           ALTER COLUMN message_            SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_delegation        ALTER COLUMN classname_          SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_delegation        ALTER COLUMN configuration_      SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_exceptionhandler  ALTER COLUMN exceptionclassname_ SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_job               ALTER COLUMN exception_          SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_log               ALTER COLUMN exception_          SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_log               ALTER COLUMN message_            SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_log               ALTER COLUMN oldstringvalue_     SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_log               ALTER COLUMN newstringvalue_     SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_node              ALTER COLUMN description_        SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_processdefinition ALTER COLUMN description_        SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_task              ALTER COLUMN description_        SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_taskinstance      ALTER COLUMN description_        SET DATA TYPE CLOB(4000);
ALTER TABLE jbpm_transition        ALTER COLUMN description_        SET DATA TYPE CLOB(4000);
--
-- Record script finish
--
DELETE FROM alf_applied_patch WHERE id = 'patch.db-V3.3-JBPM-Extra';
INSERT INTO alf_applied_patch
  (id, description, fixes_from_schema, fixes_to_schema, applied_to_schema, target_schema, applied_on_date, applied_to_server, was_executed, succeeded, report)
  VALUES
  (
    'patch.db-V3.3-JBPM-Extra', 'Manually executed script upgrade V3.3 to fix problems in JBPM tables (for DB2)',
     0, 4105, -1, 4106, null, 'UNKOWN', ${TRUE}, ${TRUE}, 'Script completed'
   );