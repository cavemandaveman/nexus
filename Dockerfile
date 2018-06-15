FROM alpine:3.6

LABEL maintainer="cavemandaveman <cavemandaveman@protonmail.com>"

ENV SONATYPE_DIR="/opt/sonatype"
ENV NEXUS_VERSION="3.12.1-01" \
    NEXUS_HOME="${SONATYPE_DIR}/nexus" \
    NEXUS_DATA="/nexus-data" \
    SONATYPE_WORK=${SONATYPE_DIR}/sonatype-work \
    JAVA_MIN_MEM="1200M" \
    JAVA_MAX_MEM="1200M" \
    JKS_PASSWORD="changeit"

RUN set -x \
    && apk --no-cache add \
        openjdk8-jre-base \
        libressl \
        su-exec \
    && mkdir -p "${SONATYPE_DIR}" \
    && wget -qO - "https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz" \
    | tar -zxC "${SONATYPE_DIR}" \
    && mv "${SONATYPE_DIR}/nexus-${NEXUS_VERSION}" "${NEXUS_HOME}" \
    && adduser -S -h ${NEXUS_DATA} nexus

EXPOSE 5000 8081 8443

WORKDIR "${NEXUS_HOME}"

VOLUME "${NEXUS_DATA}"

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["bin/nexus", "run"]
