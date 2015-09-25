#!/bin/bash

: ${KAFKA_BROKER_ID}
: ${KAFKA_ZOOKEEPER_CONNECT}
: ${KAFKA_PORT}
: ${KAFKA_ADVERTISED_HOST}
: ${KAFKA_ADVERTISED_PORT}
: ${KAFKA_LOG_CLEANER}
: ${KAFKA_AUTO_CREATE_TOPICS:=true}
: ${KAFKA_ENABLE_DELETE_TOPICS:=true}

KAFKA_CONFIG=/etc/kafka/server.properties

if [[ -n ${KAFKA_BROKER_ID} ]]; then
  sed -e "s/broker.id=.*/broker.id=${KAFKA_BROKER_ID}/" \
    -i $KAFKA_CONFIG
fi

if [[ -n ${KAFKA_ZOOKEEPER_CONNECT} ]]; then
  sed -e "s/^zookeeper.connect=.*/zookeeper.connect=${KAFKA_ZOOKEEPER_CONNECT}/" \
    -i $KAFKA_CONFIG
fi

if [[ -n ${KAFKA_PORT} ]]; then
  sed -e "s/^port=.*/port=${KAFKA_PORT}/" \
    -i $KAFKA_CONFIG
fi

if [[ -n ${KAFKA_ADVERTISED_HOST} ]]; then
  sed -e "s/^#advertised.host.name=.*/advertised.host.name=${KAFKA_ADVERTISED_HOST}/" \
    -i $KAFKA_CONFIG
fi

if [[ -n ${KAFKA_ADVERTISED_PORT} ]]; then
  sed -e "s/^#advertised.port=.*/advertised.port=${KAFKA_ADVERTISED_PORT}/" \
    -i $KAFKA_CONFIG
fi

if [[ -n ${KAFKA_LOG_CLEANER} ]]; then
  sed -e "s/^log.cleaner.enable=.*/log.cleaner.enable=${KAFKA_LOG_CLEANER}/" \
    -i $KAFKA_CONFIG
fi

sed -e 's|^log.dirs=.*|log.dirs=/data|' -i $KAFKA_CONFIG
echo "auto.create.topics.enable=${KAFKA_AUTO_CREATE_TOPICS}" >> $KAFKA_CONFIG

echo "delete.topic.enable=${KAFKA_ENABLE_DELETE_TOPICS}" >> $KAFKA_CONFIG

if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
  exec /bin/kafka-server-start $KAFKA_CONFIG "$@"
fi

exec "$@"
