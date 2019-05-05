#!/bin/bash

set -e

RUN_AS=root

if [ -n "$PUID" ] && [ ! "$(id -u root)" -eq "$PUID" ]; then
  RUN_AS=abc
  if [ ! "$(id -u ${RUN_AS})" -eq "$PUID" ]; then usermod -o -u "$PUID" ${RUN_AS} ; fi
  if [ ! "$(id -g ${RUN_AS})" -eq "$PGID" ]; then groupmod -o -g "$PGID" ${RUN_AS} ; fi

  # Make sure directories exist before chown and chmod
  dirlist=( "/config" "/data" "${DELUGE_HOME}" \
  "${DELUGE_DOWNLOAD_DIR}" "${DELUGE_INCOMPLETE_DIR}" \
  "${DELUGE_WATCH_DIR}" "${DELUGE_TORRENT_BACKUP}" )

  for dirx in "${dirlist[@]}"; do
    if [[ ! -d "${dirx}" ]]; then
      mkdir -p "${dirx}"
    fi
  done

  echo "Setting owner for deluge paths to ${PUID}:${PGID}"
  chown -R ${RUN_AS}:${RUN_AS} \
    /config /data \
    ${DELUGE_HOME} \
    ${DELUGE_DOWNLOAD_DIR} \
    ${DELUGE_INCOMPLETE_DIR} \
    ${DELUGE_WATCH_DIR} \
    ${DELUGE_TORRENT_BACKUP}

  echo "Setting permission for files (644) and directories (755)"
  chmod -R go=rX,u=rwX \
    /config /data \
    ${DELUGE_HOME} \
    ${DELUGE_DOWNLOAD_DIR} \
    ${DELUGE_INCOMPLETE_DIR} \
    ${DELUGE_WATCH_DIR} \
    ${DELUGE_TORRENT_BACKUP}
fi

echo "
-------------------------------------
Deluge will run as
-------------------------------------
User name:   ${RUN_AS}
User uid:    $(id -u ${RUN_AS})
User gid:    $(id -g ${RUN_AS})
-------------------------------------
"

export PUID
export PGID
export RUN_AS
