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

# Get the sink input index for the sink with matching application name, and use grep to find all matching indexes
sink_input_indexes=$(pacmd list-sink-inputs | grep -B 20 "application.name = \"$1\"" | awk '/index:/{print $2}')
# this second command catches Chromium commercials
sink_input_indexes_alt=$(pacmd list-sink-inputs | grep -B 27 "application.process.binary = \"$1\"" | awk '/index:/{print $2}')
# Now combine the sink input indexes from both commands to remove duplicates
sink_input_indexes=$(echo -e "$sink_input_indexes\n$sink_input_indexes_alt" | sort -n | uniq)

if [ -z "$sink_input_indexes" ]; then
    echo "Could not find sink input index for $1."
    exit 1
fi

# Perform the specified action on each sink input index
for sink_input_index in $sink_input_indexes; do
    if [ "$2" == "mute" ]; then
        pacmd set-sink-input-mute "$sink_input_index" 1 > /dev/null 2>&1
        echo "Muted $1 on sink input index $sink_input_index."
    elif [ "$2" == "unmute" ]; then
        pacmd set-sink-input-mute "$sink_input_index" 0 > /dev/null 2>&1
        echo "Unmuted $1 on sink input index $sink_input_index."
    elif [ "$2" == "respawn" ]; then
        # Kill the application
        pkill -x "$1"
        # Wait for the application to close
        while pgrep -x "$1" > /dev/null; do sleep 1; done
        # Restart the application
        "$1" > /dev/null 2>&1 &
        echo "Respawned $1."
        # break out of the loop after respawning the application because this is only needed once
        break
    fi
done

exit 0
