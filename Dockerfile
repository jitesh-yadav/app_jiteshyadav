# Using Tomcat 9 to run sample application built in Java 11.
# Copying war is enough since exposing the port, running the applicaiton etc. are encapsulated in the base image itself.
FROM tomcat:9.0-jdk11
COPY target/app-jiteshyadav.war /usr/local/tomcat/webapps/