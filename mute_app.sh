#!/bin/bash
# Script to respawn or mute an application using PulseAudio

# it works as mute_app.sh <app_name> <action>, such as mute_app.sh spotify mute
if [ -z "$1" ]; then
    echo "Please provide an application name."
    exit 1
fi

if [ -z "$2" ]; then
    echo "Please provide an action: mute, unmute, or respawn."
    exit 1
fi

if [[ "$2" != "mute" && "$2" != "unmute" && "$2" != "respawn" ]]; then
    echo "The action must be mute, unmute, or respawn."
    exit 1
fi

# Get the sink input index for the sink with matching application name
sink_input_index=$(pacmd list-sink-inputs | grep -B 20 -P "application.name = \"${1}\"" | grep "index" | awk '{print $2}')

if [ -z "$sink_input_index" ]; then
    echo "Could not find sink input index for $1."
    exit 1
fi

# Perform the specified action
if [ "$2" == "mute" ]; then
    pacmd set-sink-input-mute "$sink_input_index" 1 > /dev/null 2>&1
    echo "Muted $1."
elif [ "$2" == "unmute" ]; then
    pacmd set-sink-input-mute "$sink_input_index" 0 > /dev/null 2>&1
    echo "Unmuted $1."
elif [ "$2" == "respawn" ]; then
    # Kill the application
    pkill -x "$1"
    # Wait for the application to close
    while pgrep -x "$1" > /dev/null; do sleep 1; done
    # Restart the application
    "$1" > /dev/null 2>&1 &
    echo "Respawned $1."
fi

exit 0
