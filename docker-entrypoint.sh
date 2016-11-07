#!/bin/sh

set -x

if [ "$1" == 'bin/nexus' ]; then
  if [ -f "${NEXUS_DATA}/keystore.jks" ]; then
    mkdir -p "/opt/nexus-${NEXUS_VERSION}/etc/ssl"
    ln -s "${NEXUS_DATA}/keystore.jks" "/opt/nexus-${NEXUS_VERSION}/etc/ssl/keystore.jks"
    sed \
      -e "s|OBF.*|${JKS_PASSWORD}</Set>|g" \
      -i "/opt/nexus-${NEXUS_VERSION}/etc/jetty-https.xml"
    sed \
      -e "s|nexus-args=.*|nexus-args=${karaf.etc}/jetty.xml,${karaf.etc}/jetty-http.xml,${karaf.etc}/jetty-requestlog.xml|g" \
      -i "/opt/nexus-${NEXUS_VERSION}/etc/org.sonatype.nexus.cfg"
    grep \
      -q "application-port-ssl" "/opt/nexus-${NEXUS_VERSION}/etc/org.sonatype.nexus.cfg" || \
      sed \
        -e "\|application-port|a\application-port-ssl=8443" \
        -i "/opt/nexus-${NEXUS_VERSION}/etc/org.sonatype.nexus.cfg"
  fi
  sed \
    -e "s|-Xms.*|-Xms${JAVA_MIN_MEM}|g" \
    -e "s|-Xmx.*|-Xmx${JAVA_MAX_MEM}|g" \
    -e "s|karaf.home=.*|karaf.home=/opt/nexus-${NEXUS_VERSION}|g" \
    -e "s|karaf.base=.*|karaf.base=/opt/nexus-${NEXUS_VERSION}|g" \
    -e "s|karaf.etc=.*|karaf.etc=/opt/nexus-${NEXUS_VERSION}/etc|g" \
    -e "s|java.util.logging.config.file=.*|java.util.logging.config.file=/opt/nexus-${NEXUS_VERSION}/etc|g" \
    -e "s|karaf.data=.*|karaf.data=${NEXUS_DATA}|g" \
    -e "s|java.io.tmpdir=.*|java.io.tmpdir=${NEXUS_DATA}/tmp|g" \
    -i "/opt/nexus-${NEXUS_VERSION}/bin/nexus.vmoptions"
  mkdir -p "${NEXUS_DATA}"
  chown -R nexus "${NEXUS_DATA}"
  exec su-exec nexus "$@"
fi

exec "$@"
