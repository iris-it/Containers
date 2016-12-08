FROM jboss/base-jdk:8

# Enables signals getting passed from startup script to JVM
# ensuring clean shutdown when container is stopped.
ENV LAUNCH_JBOSS_IN_BACKGROUND 1

USER root

RUN yum install -y epel-release && yum install -y jq && yum install -y dos2unix && yum clean all

USER jboss

RUN cd /opt/jboss/ && curl -L https://downloads.jboss.org/keycloak/2.4.0.Final/keycloak-2.4.0.Final.tar.gz | tar zx && mv /opt/jboss/keycloak-2.4.0.Final /opt/jboss/keycloak

ADD setLogLevel.xsl /opt/jboss/keycloak/

RUN java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml -xsl:/opt/jboss/keycloak/setLogLevel.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml

ADD changeDatabase.xsl /opt/jboss/keycloak/

RUN java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml -xsl:/opt/jboss/keycloak/changeDatabase.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml; java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml -xsl:/opt/jboss/keycloak/changeDatabase.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml; rm /opt/jboss/keycloak/changeDatabase.xsl

RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main; cd /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main && curl -O http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.18/mysql-connector-java-5.1.18.jar

ADD module.xml /opt/jboss/keycloak/modules/system/layers/base/com/mysql/jdbc/main/

ENV JBOSS_HOME /opt/jboss/keycloak

COPY docker-entrypoint.sh /entrypoint.sh

USER root

RUN dos2unix /entrypoint.sh

RUN chmod a+x /entrypoint.sh

RUN yum erase -y dos2unix && yum clean all

USER jboss

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-b", "0.0.0.0"]
