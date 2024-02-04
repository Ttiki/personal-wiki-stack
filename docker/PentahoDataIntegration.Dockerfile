FROM openjdk:8

ENV PDI_VERSION=9.3 PDI_TAG=9.3.0.0-428 \
	KETTLE_HOME=/pdi

RUN apt-get update; apt-get install zip -y; \
apt-get install openjdk-8-jdk wget unzip git vim xauth -y; \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

ENV PENTAHO_JAVA_HOME $JAVA_HOME

COPY data-integration.zip /tmp/pdi-ce-${PDI_TAG}.zip

RUN /usr/bin/unzip -q /tmp/pdi-ce-${PDI_TAG}.zip -d $KETTLE_HOME


WORKDIR $KETTLE_HOME