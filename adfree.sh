#!/bin/bash
tmux new-session -d -s adfree
tmux send-keys "~/Spotify-Ads-Muter-Linux/mute_spotify_timer.sh $respawn" C-m