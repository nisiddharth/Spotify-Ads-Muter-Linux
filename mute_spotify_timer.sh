#!/bin/bash

respawn=false # set whether to mute or restart spotify to skip ads

while true; do
	# get Spotify playing song name
	name=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '"' -f 2`
	url=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/url/{n;p}' | cut -d '"' -f 2`
	echo $name
	# if song name contains "Advertisement" or "Spotify" or url contains "/ad/"
	if  [[ "$name" = *"Advertisement"* || "$name" = *"Spotify"* ]] || [[ $url == *"/ad/"* ]]; then
		echo "Muting"
		~/git/Spotify-Ads-Muter-Linux/mute_app.sh spotify mute
		if [[ $respawn == true ]]; then
			echo "Respawning"
			~/git/Spotify-Ads-Muter-Linux/mute_app.sh spotify respawn
		fi
	else
		echo "Unmuting"
		~/git/Spotify-Ads-Muter-Linux/mute_app.sh spotify unmute
	fi
	sleep 1
done
