#!/bin/bash
tmux new-session -d -s adfree
tmux send-keys '~/spotify-muter-linux/mute_spotify_timer.sh' C-m # C-m sends ENTER keystroke
