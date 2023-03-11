#!/bin/bash

while true; do
	# get Spotify playing song name
	name=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '"' -f 2`
	url=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/url/{n;p}' | cut -d '"' -f 2`
	echo $name
	
	if [[ "$name" = *"Advertisement"* || "$name" = *"Spotify"* ]] || [[ $url == *"/ad/"* ]]; then
		echo "Muting"
		~/Spotify-Ads-Muter-Linux/mute_app.sh spotify mute
		sleep 5
	else
		echo "Unmuting"
		~/Spotify-Ads-Muter-Linux/mute_app.sh spotify unmute
	fi
	sleep 1
done
