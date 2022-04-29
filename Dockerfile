FROM tomcat:8.0.20-jre8
COPY target/java-sonar*.war /usr/local/tomcat/webapps/java-sonar
