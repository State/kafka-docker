FROM state/oraclejre:1.8.0_40

ADD ./confluent.repo /etc/yum.repos.d/

RUN yum update -y -q; yum clean all

# Set timezone to UTC until upstream fixes that
RUN ln -s -f /usr/share/zoneinfo/Etc/UTC /etc/localtime

ENV SCALA_VERSION 2.10.4
ENV KAFKA_VERSION 0.8.2.0-1

RUN rpm --import http://packages.confluent.io/rpm/1.0/archive.key && \
    yum install -y confluent-kafka-$SCALA_VERSION-$KAFKA_VERSION && \
    yum clean all

WORKDIR /srv/kafka
VOLUME /data

ADD run.sh /run.sh
ADD log4j.properties /etc/kafka/log4j.properties

CMD ["/run.sh"]
