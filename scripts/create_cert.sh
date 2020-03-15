#!/bin/bash

# remove cert/key if they exist already
[[ -f "${DELUGE_HOME}/ssl/daemon.cert" ]] && rm -f "${DELUGE_HOME}/ssl/daemon.cert"
[[ -f "${DELUGE_HOME}/ssl/daemon.pkey" ]] && rm -f "${DELUGE_HOME}/ssl/daemon.pkey"

# always ensure we have values for cert
Country=${Country:-US}
State=${State:-Reach}
Locality=${Locality:-Sector9}
Company=${Company:-MediaServices}
Department=${Department:-Mediaservices}
HostName=${HostName:-MediaBox.local}

openssl req -newkey rsa:4096 -nodes -keyout "${DELUGE_HOME}/ssl/daemon.pkey" \
-x509 -sha512 -days 3650 -out "${DELUGE_HOME}/ssl/daemon.cert" \
-subj "/C=${Country}/ST=${State}/L=${Locality}/O=${Company}/OU=${Department}/CN=${HostName}"
