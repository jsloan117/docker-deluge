FROM ubuntu:18.04
LABEL Name=docker-deluge Version=1.2
LABEL maintainer="Jonathan Sloan"

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "*** updating system ***" \
    && apt-get update && apt-get -y upgrade \
    && echo "*** installing packages ***" \
    && apt-get -y install wget iputils-ping iproute2 net-tools deluged deluge-console deluge-web jq tzdata bash supervisor procps \
    && wget https://github.com/krallin/tini/releases/download/v0.18.0/tini_0.18.0-amd64.deb \
    && dpkg -i tini_0.18.0-amd64.deb \
    && rm -f tini_0.18.0-amd64.deb \
    && echo "*** cleanup ***" \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/* \
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
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash", "/scripts/init.sh" ]
