FROM ubuntu:18.04
LABEL Name=docker-deluge Maintainer="Jonathan Sloan"

ENV DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8 LANG=C.UTF-8

RUN echo "*** installing packages ***" \
    && apt-get update && apt-get -y --no-install-recommends install wget net-tools bash python3 python3-pip procps software-properties-common \
    && add-apt-repository ppa:deluge-team/stable && apt-get update && apt-get -y --no-install-recommends install deluged deluge-console deluge-web \
    && pip3 install supervisor \
    && wget -q --no-check-certificate https://github.com/krallin/tini/releases/download/v0.18.0/tini_0.18.0-amd64.deb \
    && dpkg -i tini_0.18.0-amd64.deb \
    && rm -f tini_0.18.0-amd64.deb \
    && echo "*** cleanup ***" \
    && apt-get -y remove python3-pip software-properties-common \
    && apt-get -y autoremove && apt-get autoclean \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apt/* /var/lib/apt/lists/* \
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
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash", "/scripts/init.sh" ]
