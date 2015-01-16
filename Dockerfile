FROM fedora:21

RUN yum update -y -q; yum clean all
RUN yum install -y -q java-headless tar wget; yum clean all

# Set timezone to UTC until upstream fixes that
RUN ln -s -f /usr/share/zoneinfo/Etc/UTC /etc/localtime

ENV KAFKA_VERSION 2.10-0.8.1.1
RUN (cd /tmp; wget -q http://apache.mirror.anlx.net/kafka/0.8.1.1/kafka_${KAFKA_VERSION}.tgz -O - | tar -xzf -; mv kafka_${KAFKA_VERSION} /srv/kafka)

WORKDIR /srv/kafka
VOLUME /data

ADD run.sh /run.sh
ADD log4j.properties /srv/kafka/config/log4j.properties

CMD ["/run.sh"]
