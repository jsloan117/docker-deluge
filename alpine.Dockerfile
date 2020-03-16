# THIS APPEARS TO BE BROKEN AT THIS TIME
FROM alpine:edge
LABEL Name=docker-deluge Maintainer="Jonathan Sloan"

RUN echo "*** adding alpine testing repo ***" \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "*** installing packages ***" \
    && apk update && apk --no-cache add bash tini net-tools deluge supervisor shadow grep procps \
    && echo "*** cleanup ***" \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/lib/apk/* \
    && useradd -u 911 -U -d /deluge-home -s /bin/false abc

COPY configs /configs
COPY scripts /scripts
COPY VERSION .

ENV DELUGE_HOME="/deluge-home" \
    DELUGE_DOWNLOAD_DIR="/data/completed" \
    DELUGE_INCOMPLETE_DIR="/data/incomplete" \
    DELUGE_WATCH_DIR="/data/watched" \
    DELUGE_TORRENT_BACKUP="/data/torrents" \
    DELUGE_DAEMON_LOG_LEVEL="info" \
    DELUGE_WEB_LOG_LEVEL="info" \
    PUID="911" \
    PGID="911" \
    SSL="yes"

VOLUME /data
EXPOSE 8112
ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "/bin/bash", "/scripts/init.sh" ]
