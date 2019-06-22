FROM alpine:edge
LABEL Name=docker-deluge Version=1.2
LABEL maintainer="Jonathan Sloan"

RUN echo "*** adding alpine testing repo ***" \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "*** updating system ***" \
    && apk update && apk upgrade \
    && echo "*** installing packages ***" \
    && apk --no-cache add bash tini deluge supervisor shadow grep procps \
    && echo "*** cleanup ***" \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/* \
    && useradd -u 911 -U -d /config -s /bin/false abc

ADD config /configs
ADD scripts /scripts

ENV DELUGE_HOME=/config \
    DELUGE_DOWNLOAD_DIR=/data/completed \
    DELUGE_INCOMPLETE_DIR=/data/incomplete \
    DELUGE_WATCH_DIR=/data/watched \
    DELUGE_TORRENT_BACKUP=/data/torrents \
    DELUGE_DAEMON_LOG_LEVEL=info \
    DELUGE_WEB_LOG_LEVEL=info \
    PUID= \
    PGID= \
    UMASK= \
    SSL=yes

VOLUME /config /data
EXPOSE 8112 58846 58946 58946/udp
ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "/bin/bash", "/scripts/init.sh" ]
