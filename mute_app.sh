#!/bin/bash
# Script to mute an application using PulseAudio, depending solely on
# process name, constructed as answer on askubuntu.com:.
# http://askubuntu.com/questions/180612/script-to-mute-an-application

# It works as: mute_application.sh vlc mute OR mute_application.sh vlc unmute

if [ -z "$1" ]; then
    echo "Please provide me with an application name"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Please provide me with an action mute/unmute after the application name"
    exit 1
fi

if ! [[ "$2" == "mute" || "$2" == "unmute" ]]; then
    echo "The 2nd argument must be mute/unmute"
    exit 1
fi

process_id=$(pidof "$1")

if [ $? -ne 0 ]; then
    echo "There is no such process as "$1""
    exit 1
fi

temp=$(mktemp)

pacmd list-sink-inputs > $temp

inputs_found=0;
current_index=-1;

while read line; do
    if [ $inputs_found -eq 0 ]; then
	    inputs=$(echo -ne "$line" | awk '{print $2}')
	    if [[ "$inputs" == "to" ]]; then
		    continue
	    fi
	    inputs_found=1
    else
	    if [[ "${line:0:6}" == "index:" ]]; then
		    current_index="${line:7}"
	    elif [[ "${line:0:25}" == "application.process.id = " ]]; then
		    if [[ "${line:25}" == "\"$process_id\"" ]]; then
			    # index found...
			    break;
		    fi
	    fi
    fi
done < $temp

rm -f $temp

if [ $current_index -eq -1 ]; then
    echo "Could not find "$1" in the processes that output sound."
    exit 1
fi

# muting...
if [[ "$2" == "mute" ]]; then
    pacmd set-sink-input-mute "$current_index" 1 > /dev/null 2>&1
else
    pacmd set-sink-input-mute "$current_index" 0 > /dev/null 2>&1
fi

exit 0
