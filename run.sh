#!/bin/bash

: ${KAFKA_BROKER_ID}
: ${KAFKA_ZOOKEEPER_CONNECT}
: ${KAFKA_ADVERTISED_HOST}
: ${KAFKA_ADVERTISED_PORT}
: ${KAFKA_LOG_CLEANER}
: ${KAFKA_AUTO_CREATE_TOPICS:=true}


if [[ -n ${KAFKA_BROKER_ID} ]]; then
  sed -e "s/broker.id=.*/broker.id=${KAFKA_BROKER_ID}/" \
    -i /srv/kafka/config/server.properties
fi

if [[ -n ${KAFKA_ZOOKEEPER_CONNECT} ]]; then
  sed -e "s/^zookeeper.connect=.*/zookeeper.connect=${KAFKA_ZOOKEEPER_CONNECT}/" \
    -i /srv/kafka/config/server.properties
fi

if [[ -n ${KAFKA_ADVERTISED_HOST} ]]; then
  sed -e "s/^#advertised.host.name=.*/advertised.host.name=${KAFKA_ADVERTISED_HOST}/" \
    -i /srv/kafka/config/server.properties
fi

if [[ -n ${KAFKA_ADVERTISED_PORT} ]]; then
  sed -e "s/^#advertised.port=.*/advertised.port=${KAFKA_ADVERTISED_PORT}/" \
    -i /srv/kafka/config/server.properties
fi

if [[ -n ${KAFKA_LOG_CLEANER} ]]; then
  sed -e "s/^log.cleaner.enable=.*/log.cleaner.enable=${KAFKA_LOG_CLEANER}/" \
    -i /srv/kafka/config/server.properties
fi

sed -e 's|^log.dirs=.*|log.dirs=/data|' -i /srv/kafka/config/server.properties
echo "auto.create.topics.enable=${KAFKA_AUTO_CREATE_TOPICS}" >> /srv/kafka/config/server.properties


if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
  exec bin/kafka-server-start.sh config/server.properties "$@"
fi

exec "$@"

