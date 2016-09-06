FROM alpine:3.4

MAINTAINER cavemandaveman <cavemandaveman@openmailbox.org>

ENV NEXUS_VERSION="3.0.1-01" \
    NEXUS_DATA="/nexus-data" \
    JAVA_MIN_MEM="1200M" \
    JAVA_MAX_MEM="1200M" \
    JKS_PASSWORD="changeit"

RUN set -x \
    && apk --no-cache add \
        openjdk8-jre-base \
        openssl \
        su-exec \
    && mkdir "/opt" \
    && wget -qO - "https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz" \
    | tar -zxC "/opt" \
    && adduser -S -h ${NEXUS_DATA} nexus

EXPOSE 8081 8443

WORKDIR "/opt/nexus-${NEXUS_VERSION}"

VOLUME ${NEXUS_DATA}

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["bin/nexus", "run"]
