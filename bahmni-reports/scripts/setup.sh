sh /etc/scripts/initDB.sh
envsubst < /opt/conf/bahmni-reports.properties > /root/.bahmni-reports/bahmni-reports.properties
sh /usr/local/tomcat/bin/catalina.sh run