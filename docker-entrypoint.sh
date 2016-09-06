#!/usr/bin/env sh

set -x

if [ "$1" == 'bin/nexus' ]; then
  sed \
    -e "s|-Xms1200M|-Xms${JAVA_MIN_MEM}|g" \
    -e "s|-Xmx1200M|-Xmx${JAVA_MAX_MEM}|g" \
    -e "s|karaf.home=.|karaf.home=/opt/nexus-${NEXUS_VERSION}|g" \
    -e "s|karaf.base=.|karaf.base=/opt/nexus-${NEXUS_VERSION}|g" \
    -e "s|karaf.etc=etc|karaf.etc=/opt/nexus-${NEXUS_VERSION}/etc|g" \
    -e "s|java.util.logging.config.file=etc|java.util.logging.config.file=/opt/nexus-${NEXUS_VERSION}/etc|g" \
    -e "s|karaf.data=data|karaf.data=${NEXUS_DATA}|g" \
    -e "s|java.io.tmpdir=data/tmp|java.io.tmpdir=${NEXUS_DATA}/tmp|g" \
    -i "/opt/nexus-${NEXUS_VERSION}/bin/nexus.vmoptions"
  mkdir -p "${NEXUS_DATA}"
  chown -R nexus "${NEXUS_DATA}"
  exec su-exec nexus "$@"
fi

exec "$@"
