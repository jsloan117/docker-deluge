#!/bin/bash

if [[ ! -f /etc/supervisor.conf ]]; then
  if [[ ! -f /etc/supervisor/conf.d/deluge.conf ]]; then
    mkdir -p /etc/supervisor/conf.d
    cp /configs/deluge.conf /etc/supervisor/conf.d
  fi
  cp /configs/supervisor.conf /etc
fi

# ensure ownership & permissions are correctly set
/scripts/usersetup.sh

exec /usr/bin/supervisord -c /etc/supervisor.conf -n
