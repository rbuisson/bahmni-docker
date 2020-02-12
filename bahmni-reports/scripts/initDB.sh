#!/bin/bash
set -e

run_migrations(){

echo "Running liquibase migrations"
CHANGE_LOG_TABLE="-Dliquibase.databaseChangeLogTableName=liquibasechangelog -Dliquibase.databaseChangeLogLockTableName=liquibasechangeloglock -DschemaName=$3"
LIQUIBASE_JAR="/opt/liquibase-core-2.0.5.jar"
DRIVER="com.mysql.jdbc.Driver"
CLASSPATH="/opt/mysql-connector-java-5.1.26.jar"
CHANGE_LOG_FILE="$1"

(cd /opt/conf && java $CHANGE_LOG_TABLE  -jar $LIQUIBASE_JAR --driver=$DRIVER --classpath=$CLASSPATH --changeLogFile=$CHANGE_LOG_FILE --url=jdbc:mysql://$2:3306/$3 --username=$4 --password=$5 update)
}


while ! mysqladmin ping -h"$REPORTS_DB_SERVER" --silent; do
    echo "Waiting for MySQL..."
    sleep 1
done



RESULT=`mysql -h $REPORTS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD --skip-column-names -e "SHOW DATABASES LIKE 'bahmni_reports'"`
if [ "$RESULT" != "bahmni_reports" ] ; then
echo "*********** MYSQL DB Creation Starts   ******************"

  mysql -h $REPORTS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE bahmni_reports;"
  mysql -h $REPORTS_DB_SERVER -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON bahmni_reports.* TO '$REPORTS_DB_USERNAME'@'%' identified by '$REPORTS_DB_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
  run_migrations liquibase.xml $OPENMRS_DB_SERVER openmrs $MYSQL_ROOT_USER $MYSQL_ROOT_PASSWORD
  run_migrations liquibase_bahmni_reports.xml $REPORTS_DB_SERVER bahmni_reports $REPORTS_DB_USERNAME $REPORTS_DB_PASSWORD
echo "*********** MYSQL DB Creation Ends   ******************"
fi