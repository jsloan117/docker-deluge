#!/bin/bash

# This script ensures that we recheck any torrents that are in an error state when we
# start Deluge. This script must be run as the user running the Deluge daemon (abc).

mapfile -t torrent_id_error_array < <( deluge-console -c "${DELUGE_HOME}" "info" | grep -B 1 'State: Error' | xargs | grep -P -o -m 1 '(?<=ID:\s)[^\s]+' | xargs )

if [[ -n ${torrent_id_error_array[*]} ]]; then
	echo "WARN Torrents with state 'Error' found"
	# loop over torrent id's with state error and recheck
	for t in "${torrent_id_error_array[@]}"; do
		echo "INFO Rechecking Torrent ID ${t} ..."
		/usr/bin/deluge-console -c "${DELUGE_HOME}" "recheck ${t}"
	done
fi
