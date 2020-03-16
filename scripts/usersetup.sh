#!/bin/bash

set -e

RUN_AS=root

if [ -n "${PUID}" ] && [ ! "$(id -u root)" -eq "${PUID}" ]; then
  RUN_AS=abc
  if [ ! "$(id -u ${RUN_AS})" -eq "${PUID}" ]; then usermod -o -u "${PUID}" "${RUN_AS}"; fi
  if [ ! "$(id -g ${RUN_AS})" -eq "${PGID}" ]; then groupmod -o -g "${PGID}" "${RUN_AS}"; fi
  if [ -n "${DELUGE_HOME}" ]; then usermod -md "${DELUGE_HOME}" "${RUN_AS}"; fi

  # Make sure directories exist before chown and chmod
  dlist=( "/data" "${DELUGE_HOME}" \
  "${DELUGE_DOWNLOAD_DIR}" "${DELUGE_INCOMPLETE_DIR}" \
  "${DELUGE_WATCH_DIR}" "${DELUGE_TORRENT_BACKUP}" )

  dirlist=()
  for xdir in "${dlist[@]}"; do
    if [[ -n "${xdir}" ]]; then
      dirlist+=( "${xdir}" )
    fi
  done

  for xdir in "${dirlist[@]}"; do
    if [[ ! -d "${xdir}" ]]; then
      mkdir -p "${xdir}"
    fi
  done

  echo "INFO Setting owner for deluge paths to ${PUID}:${PGID}"
  echo "INFO Setting permissions for files (644) and directories (755)"
  for xdir in "${dirlist[@]}"; do
    chown -R "${RUN_AS}":"${RUN_AS}" "${xdir}"
    chmod -R go=rX,u=rwX "${xdir}"
  done
fi

echo "
-------------------------------------
Deluge will run as
-------------------------------------
User name:   ${RUN_AS}
User uid:    $(id -u ${RUN_AS})
User gid:    $(id -g ${RUN_AS})
User home:   ${DELUGE_HOME}
-------------------------------------
"

export PUID PGID RUN_AS
