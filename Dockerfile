FROM fedora:21

RUN yum update -y -q; yum clean all
RUN yum install -y -q java-headless tar wget; yum clean all

# Set timezone to UTC until upstream fixes that
RUN ln -s -f /usr/share/zoneinfo/Etc/UTC /etc/localtime

ENV SCALA_VERSION 2.10
ENV KAFKA_VERSION 0.8.2.0
ENV RELEASE_NAME kafka_${SCALA_VERSION}-${KAFKA_VERSION}
RUN (cd /tmp; wget -q http://apache.mirror.anlx.net/kafka/${KAFKA_VERSION}/${RELEASE_NAME}.tgz -O - | tar -xzf -; mv ${RELEASE_NAME} /srv/kafka)

WORKDIR /srv/kafka
VOLUME /data

ADD run.sh /run.sh
ADD log4j.properties /srv/kafka/config/log4j.properties

CMD ["/run.sh"]
