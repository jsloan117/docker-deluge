#!/bin/bash

# if config file doesnt exist (wont exist until user changes a setting) then copy default config file
if [[ ! -f "${DELUGE_HOME}/core.conf" ]]; then
  echo "INFO Deluge config file doesn't exist, copying default..."
  cp /configs/core.conf "${DELUGE_HOME}"
else
  echo "INFO Deluge config file already exists, skipping copy"
fi

if [[ ! -f "${DELUGE_HOME}/web.conf" ]]; then
  echo "INFO Deluge Web config file doesn't exist, copying default..."
  cp /configs/web.conf "${DELUGE_HOME}"
else
  echo "INFO Deluge Web config file already exists, skipping copy"
fi

# generate self-signed SSL cert
if [[ -n "${GENCERT}" ]] && [[ "${GENCERT}" = 'yes' ]]; then
  /scripts/create_cert.sh
fi

# set deluge SSL setting
if [[ -n "${SSL}" ]] && [[ "${SSL}" = 'yes' ]]; then
  sed -i 's/"https": \(.*\),/"https": true,/' "${DELUGE_HOME}/web.conf"
elif [[ -n "${SSL}" ]] && [[ "${SSL}" = 'no' ]]; then
  sed -i 's/"https": \(.*\),/"https": false,/' "${DELUGE_HOME}/web.conf"
fi

# ensure deluge plugin directory is under $DELUGE_HOME
if [[ -n "${DELUGE_HOME}" ]]; then
  sed -i "s|\"plugins_location\": \"\(.*\)\",|\"plugins_location\": \"${DELUGE_HOME}/plugins\",|" "${DELUGE_HOME}/core.conf"
fi

# set deluge completed directory
if [[ -n "${DELUGE_DOWNLOAD_DIR}" ]]; then
  sed -i "s|\"move_completed_path\": \"\(.*\)\",|\"move_completed_path\": \"${DELUGE_DOWNLOAD_DIR}\",|" "${DELUGE_HOME}/core.conf"
fi

# set deluge incomplete directory
if [[ -n "${DELUGE_INCOMPLETE_DIR}" ]]; then
  sed -i "s|\"download_location\": \"\(.*\)\",|\"download_location\": \"${DELUGE_INCOMPLETE_DIR}\",|" "${DELUGE_HOME}/core.conf"
fi

# set deluge watch directory
if [[ -n "${DELUGE_WATCH_DIR}" ]]; then
  sed -i "s|\"autoadd_location\": \"\(.*\)\",|\"autoadd_location\": \"${DELUGE_WATCH_DIR}\",|" "${DELUGE_HOME}/core.conf"
fi

# set deluge torrent backup directory
if [[ -n "${DELUGE_TORRENT_BACKUP}" ]]; then
  sed -i "s|\"torrentfiles_location\": \"\(.*\)\",|\"torrentfiles_location\": \"${DELUGE_TORRENT_BACKUP}\",|" "${DELUGE_HOME}/core.conf"
fi

echo "INFO Attempting to start Deluge..."

if [[ -f "${DELUGE_HOME}/deluged.pid" ]]; then
  echo "INFO Removing deluge pid file"
  rm -f "${DELUGE_HOME}/deluged.pid"
fi

# run deluge daemon
/usr/bin/deluged -c "${DELUGE_HOME}" -L "${DELUGE_DAEMON_LOG_LEVEL}" -l "${DELUGE_HOME}/deluged.log"
echo "INFO Deluge process started"

echo "INFO Waiting for Deluge process to start listening on port 58846..."
while [[ $(netstat -lnt | awk "\$6 == \"LISTEN\" && \$4 ~ \".58846\"") == "" ]]; do
  sleep 0.1
done

echo "INFO Deluge process listening on port 58846"

# run script to check if we have any torrents in an error state
/scripts/torrentcheck.sh

if ! pgrep -x "deluge-web" > /dev/null; then
  echo "INFO Starting Deluge Web UI..."
  # run deluge-web
  if [[ -f '/etc/alpine-release' ]]; then
    /usr/bin/deluge-web -d -c "${DELUGE_HOME}" -L "${DELUGE_WEB_LOG_LEVEL}" -l "${DELUGE_HOME}/deluge-web.log"
  elif [[ -f '/etc/debian_version' ]]; then
    /usr/bin/deluge-web -c "${DELUGE_HOME}" -L "${DELUGE_WEB_LOG_LEVEL}" -l "${DELUGE_HOME}/deluge-web.log"
  fi
fi
