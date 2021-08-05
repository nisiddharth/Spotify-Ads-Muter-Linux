#!/bin/bash

while true; do
	# get Spotify playing song name
	name=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '"' -f 2`

	echo $name

	if [[ "$name" = *"Advertisement"* || "$name" = *"Spotify"* ]]; then
		echo "Muting"
		~/spotify-muter-linux/mute_app.sh spotify mute
		sleep 25
	else
		echo "Unmuting"
		~/spotify-muter-linux/mute_app.sh spotify unmute
	fi
	sleep 5
done
