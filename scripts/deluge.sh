#!/bin/bash

# if config file doesnt exist (wont exist until user changes a setting) then copy default config file
if [[ ! -f /config/core.conf ]]; then
  echo "[info] Deluge config file doesn't exist, copying default..."
  cp /configs/core.conf /config
else
  echo "[info] Deluge config file already exists, skipping copy"
fi

if [[ ! -f /config/web.conf ]]; then
  echo "[info] Deluge Web config file doesn't exist, copying default..."
  cp /configs/web.conf /config
else
  echo "[info] Deluge Web config file already exists, skipping copy"
fi

# set deluge SSL setting
if [[ -n "${SSL}" ]] && [[ "${SSL}" = 'yes' ]]; then
  sed -i 's/"https": \(.*\),/"https": true,/' /config/web.conf
elif [[ -n "${SSL}" ]] && [[ "${SSL}" = 'no' ]]; then
  sed -i 's/"https": \(.*\),/"https": false,/' /config/web.conf
fi

# set deluge completed directory
if [[ -n "${DELUGE_DOWNLOAD_DIR}" ]]; then
  sed -i "s|\"move_completed_path\": \"\(.*\)\",|\"move_completed_path\": \"${DELUGE_DOWNLOAD_DIR}\",|" /config/core.conf
fi

# set deluge incomplete directory
if [[ -n "${DELUGE_INCOMPLETE_DIR}" ]]; then
  sed -i "s|\"download_location\": \"\(.*\)\",|\"download_location\": \"${DELUGE_INCOMPLETE_DIR}\",|" /config/core.conf
fi

# set deluge watch directory
if [[ -n "${DELUGE_WATCH_DIR}" ]]; then
  sed -i "s|\"autoadd_location\": \"\(.*\)\",|\"autoadd_location\": \"${DELUGE_WATCH_DIR}\",|" /config/core.conf
fi

# set deluge torrent backup directory
if [[ -n "${DELUGE_TORRENT_BACKUP}" ]]; then
  sed -i "s|\"torrentfiles_location\": \"\(.*\)\",|\"torrentfiles_location\": \"${DELUGE_TORRENT_BACKUP}\",|" /config/core.conf
fi

echo "[info] Attempting to start Deluge..."

if [[ -f /config/deluged.pid ]]; then
  echo "[info] Removing deluge pid file"
  rm -f /config/deluged.pid
fi

# run deluge daemon
/usr/bin/deluged -c /config -L "${DELUGE_DAEMON_LOG_LEVEL}" -l /config/deluged.log
echo "[info] Deluge process started"

echo "[info] Waiting for Deluge process to start listening on port 58846..."
while [[ $(netstat -lnt | awk "\$6 == \"LISTEN\" && \$4 ~ \".58846\"") == "" ]]; do
  sleep 0.1
done

echo "[info] Deluge process listening on port 58846"

# run script to check we don't have any torrents in an error state
/scripts/torrentcheck.sh

if ! pgrep -x "deluge-web" > /dev/null; then
  echo "[info] Starting Deluge Web UI..."
  # run deluge-web
  if [[ -f '/etc/alpine-release' ]]; then
    /usr/bin/deluge-web -d -c /config -L "${DELUGE_WEB_LOG_LEVEL}" -l /config/deluge-web.log
  elif [[ -f '/etc/debian_version' ]]; then
    /usr/bin/deluge-web -c /config -L "${DELUGE_WEB_LOG_LEVEL}" -l /config/deluge-web.log
fi
