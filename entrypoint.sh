#!/bin/sh

set -e

if [ "$1" = 'lms' ]; then
	if [ "$SQUEEZE_VOL" ] && [ -d "$SQUEEZE_VOL" ]; then
		for subdir in prefs logs cache; do
			mkdir -p $SQUEEZE_VOL/$subdir
			chown -R squeezeboxserver:nogroup $SQUEEZE_VOL/$subdir
		done
	fi

	exec /start-squeezebox.sh "$@"
fi

exec "$@"
