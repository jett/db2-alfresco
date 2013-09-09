DB2 Server support for Alfresco Community
=========================================

This project is based on the "Oracle Server support for Alfresco Community" by krumboeck (http://github.com/krumboeck/oracle-alfresco) . I needed to get Alfresco Community running on a DB2 backend so here goes.

Initially tested to work with 4.2.c 

Building the AMP file
---------------------
	cd src
    zip -r ../db2-alfresco.amp *

	
Applying the AMP file
---------------------

Use the Alfresco Module Management Tool to apply the AMP to the alfresco.war package:

	java -jar alfresco-mmt.jar install <path to db2-alfresco.amp> <path to alfresco.war>
	
	
Setup Instructions
------------------
1. Create a DB2 database with a page size of 32K and using UTF8 (http://wiki.alfresco.com/wiki/Database_Configuration#DB2_example)

2. Override the database related properties in alfresco-global.properties

	db.name=alfresco
	db.username=alfresco
	db.password=alfresco
	db.host=localhost
	db.port=50000
	db.driver=com.ibm.db2.jcc.DB2Driver
	db.url=jdbc:db2://${db.host}:${db.port}/${db.name}

3. Copy the DB2 JDBC drivers (db2jcc.jar and db2jcc_license_cu.jar) to the Tomcat lib folder.

4. Start Tomcat

