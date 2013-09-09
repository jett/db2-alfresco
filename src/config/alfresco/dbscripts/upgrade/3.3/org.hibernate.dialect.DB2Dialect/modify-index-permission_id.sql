--
-- Title:      Upgrade to V3.3 - Remove context_id from the permission_id index on alf_access_control_list_entry 
-- Database:   DB2
-- Since:      V3.3 schema 4011
-- Author:     
--
-- Remove context_id from the permission_id unique index (as it alwaays contains null and therefore has no effect)
--
-- Please contact support@alfresco.com if you need assistance with the upgrade.
--



-- The remainder of this script is adapted from 
-- Repository/config/alfresco/dbscripts/upgrade/2.2/org.hibernate.dialect.DB2Dialect/AlfrescoSchemaUpdate-2.2-ACL.sql
-- Ports should do the same and reflect the DB specific improvements

CREATE TABLE alf_tmp_min_ace (
    min_id BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,
    authority_id BIGINT NOT NULL,
    allowed INTEGER NOT NULL,
    applies INTEGER NOT NULL,
    UNIQUE (permission_id, authority_id, allowed, applies)
);


INSERT INTO
    alf_tmp_min_ace
    (SELECT
        min(ace1.id),
        ace1.permission_id,
        ace1.authority_id,
        ace1.allowed,
        ace1.applies
    FROM
        alf_access_control_entry ace1
    GROUP BY
        ace1.permission_id, ace1.authority_id, ace1.allowed, ace1.applies);


CREATE TABLE alf_tmp_acl_members (
    id BIGINT NOT NULL,
    min_id BIGINT NOT NULL,
    acl_id BIGINT NOT NULL,
    pos BIGINT NOT NULL,
    ace_id BIGINT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (min_id, acl_id, pos, ace_id)
);


INSERT INTO
    alf_tmp_acl_members
    (SELECT
        mem.id, help.min_id, mem.acl_id, mem.pos, mem.ace_id
    FROM
        alf_acl_member mem
        JOIN
            alf_access_control_entry ace
        ON
            mem.ace_id = ace.id
        JOIN
            alf_tmp_min_ace help
        ON
            help.permission_id = ace.permission_id AND
            help.authority_id = ace.authority_id AND
            help.allowed = ace.allowed AND
            help.applies = ace.applies);


CREATE TABLE alf_tmp_acl_groups (
    min_id BIGINT NOT NULL,
    acl_id BIGINT NOT NULL,
    pos BIGINT NOT NULL,
    group_min BIGINT NOT NULL,
    UNIQUE (min_id, acl_id, pos)
);


INSERT INTO
    alf_tmp_acl_groups
    (SELECT
        mems.min_id, mems.acl_id, mems.pos, min(mems.ace_id) AS group_min
    FROM
        alf_tmp_acl_members mems
    GROUP BY
        mems.min_id, mems.acl_id, mems.pos
    HAVING
        count(*) > 1);


DELETE FROM
    alf_acl_member
WHERE
    id IN (
        SELECT
            mems.id
        FROM
            alf_tmp_acl_members mems
            JOIN
                alf_tmp_acl_groups groups
            ON
                mems.min_id = groups.min_id AND
                mems.acl_id = groups.acl_id AND
                mems.pos = groups.pos
        WHERE
            mems.ace_id <> groups.group_min
    );


DROP TABLE
    alf_tmp_min_ace;

DROP TABLE
    alf_tmp_acl_members;

DROP TABLE
    alf_tmp_acl_groups;


UPDATE ALF_ACL_MEMBER MEM SET ACE_ID = (SELECT MIN(ACE2.ID) FROM ALF_ACCESS_CONTROL_ENTRY ACE1 JOIN ALF_ACCESS_CONTROL_ENTRY ACE2 ON ACE1.PERMISSION_ID = ACE2.PERMISSION_ID AND ACE1.AUTHORITY_ID = ACE2.AUTHORITY_ID AND ACE1.ALLOWED = ACE2.ALLOWED AND ACE1.APPLIES = ACE2.APPLIES WHERE ACE1.ID = MEM.ACE_ID  );

CREATE TABLE TMP_TO_DELETE ( 
	ID BIGINT NOT NULL, 
	PRIMARY KEY (ID)
);

INSERT INTO TMP_TO_DELETE ( SELECT ACE.ID FROM ALF_ACL_MEMBER MEM RIGHT OUTER JOIN ALF_ACCESS_CONTROL_ENTRY ACE ON MEM.ACE_ID = ACE.ID WHERE MEM.ACE_ID IS NULL);
DELETE FROM ALF_ACCESS_CONTROL_ENTRY ACE WHERE ACE.ID IN (SELECT ID FROM TMP_TO_DELETE);
DROP TABLE TMP_TO_DELETE;

-- Add constraint for duplicate acls (this no longer includes the context)
ALTER TABLE alf_access_control_entry ADD UNIQUE (permission_id, authority_id, allowed, applies);
--
-- Record script finish
--
DELETE FROM alf_applied_patch WHERE id = 'patch.db-V3.3-modify-index-permission_id';
INSERT INTO alf_applied_patch
  (id, description, fixes_from_schema, fixes_to_schema, applied_to_schema, target_schema, applied_on_date, applied_to_server, was_executed, succeeded, report)
  VALUES
  (
    'patch.db-V3.3-modify-index-permission_id', 'Remove context_id from the permission_id unique index (as it always contains null and therefore has no effect)',
     0, 4011, -1, 4012, null, 'UNKNOWN', ${TRUE}, ${TRUE}, 'Script completed'
   );
