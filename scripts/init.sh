#!/bin/bash

if [[ ! -f /etc/supervisor.conf ]]; then
  if [[ ! -f /etc/supervisor.d/deluge.conf ]]; then
    mkdir -p /etc/supervisor.d
    cp /configs/deluge.conf /etc/supervisor.d
  fi
  cp /configs/supervisor.conf /etc
fi

# ensure ownership & permissions are correctly set
/scripts/usersetup.sh

exec /usr/bin/supervisord -c /etc/supervisor.conf -n
