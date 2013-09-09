--
-- Title:      Activity tables
-- Database:   DB2
-- Since:      V3.0 Schema 126
-- Author:     janv
--
-- Please contact support@alfresco.com if you need assistance with the upgrade.
--

CREATE TABLE alf_activity_feed
(
    id BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    post_id BIGINT,
    post_date TIMESTAMP NOT NULL,
    activity_summary VARCHAR(4096),
    feed_user_id VARCHAR(1020),
    activity_type VARCHAR(1020) NOT NULL,
    activity_format VARCHAR(40),
    site_network VARCHAR(1020),
    app_tool VARCHAR(144),
    post_user_id VARCHAR(1020) NOT NULL,
    feed_date TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
);
CREATE INDEX feed_postdate_idx ON alf_activity_feed (post_date);
CREATE INDEX feed_postuserid_idx ON alf_activity_feed (post_user_id);
CREATE INDEX feed_feeduserid_idx ON alf_activity_feed (feed_user_id);
CREATE INDEX feed_sitenetwork_idx ON alf_activity_feed (site_network);
CREATE INDEX feed_activityformat_idx ON alf_activity_feed (activity_format);

CREATE TABLE alf_activity_feed_control
(
    id BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    feed_user_id VARCHAR(1020) NOT NULL,
    site_network VARCHAR(1020),
    app_tool VARCHAR(144),
    last_modified TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
);
CREATE INDEX feedctrl_feeduserid_idx ON alf_activity_feed_control (feed_user_id);

CREATE TABLE alf_activity_post
(
    sequence_id BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    post_date TIMESTAMP NOT NULL,
    status VARCHAR(40) NOT NULL,
    activity_data VARCHAR(4096) NOT NULL,
    post_user_id VARCHAR(1020) NOT NULL,
    job_task_node INTEGER NOT NULL,
    site_network VARCHAR(1020),
    app_tool VARCHAR(144),
    activity_type VARCHAR(1020) NOT NULL,
    last_modified TIMESTAMP NOT NULL,
    PRIMARY KEY (sequence_id)
);
CREATE INDEX post_jobtasknode_idx ON alf_activity_post (job_task_node);
CREATE INDEX post_status_idx ON alf_activity_post (status);


--
-- Record script finish
--
DELETE FROM alf_applied_patch WHERE id = 'patch.db-V3.0-ActivityTables';
INSERT INTO alf_applied_patch
  (id, description, fixes_from_schema, fixes_to_schema, applied_to_schema, target_schema, applied_on_date, applied_to_server, was_executed, succeeded, report)
  VALUES
  (
    'patch.db-V3.0-ActivityTables', 'Manually executed script upgrade V3.0: Activity Tables',
    0, 125, -1, 126, null, 'UNKNOWN', ${TRUE}, ${TRUE}, 'Script completed'
  );