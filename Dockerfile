FROM alpine:edge
LABEL Name=docker-deluge Maintainer="Jonathan Sloan"

RUN echo "*** adding alpine testing repo ***" \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "*** installing packages ***" \
    && apk --no-cache add gcc musl-dev boost-python3 python3-dev py3-asn1 \
    py3-cairo py3-chardet py3-gobject3 py3-hyperlink py3-libtorrent-rasterbar \
    py3-mako py3-markupsafe py3-openssl py3-pillow py3-rencode py3-service_identity \
    py3-setproctitle py3-setuptools py3-six py3-twisted py3-xdg py3-zope-interface \
    geoip-dev bash tini net-tools supervisor shadow grep procps \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
    && python get-pip.py --disable-pip-version-check --no-cache-dir \
    && rm -f get-pip.py \
    && pip --no-cache-dir install GeoIP distro deluge \
    && echo "*** cleanup ***" \
    && apk del gcc musl-dev python3-dev \
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
