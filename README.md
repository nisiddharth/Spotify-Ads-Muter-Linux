# Spotify Ads muter for Linux

This is purely a bash script.

Uses dbus, applicable for systems using PulseAudio. Only works while using Spotify client (doesn't matter how you install it) and not web browser.

Mutes and unmutes Spotify within 5 seconds of start and end of Ads.

### Usage:

To use just run `mute_spotify_timer.sh` either using terminal or Alt + F2 launcher or just add it to list of system Startup Applications. To allow monitoring the ongoing status, run `adfree.sh` as a Startup Application, or with `bash adfree.sh`. It creates a new background tmux session called  `adfree `, which can be connected to with `tmux a -t adfree`.

### Maintenance:

I'll make this more efficient when I'll feel free. Meanwhile you can send Pull Requests!
