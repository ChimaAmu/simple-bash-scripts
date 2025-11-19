#!/bin/bash

# A simple shell script to use as a pomodoro app.
# The first argument is the focus time length.
# The second argument is the break length.
# Made by Kiailandi (https://github.com/kiailandi)

wseconds="${1:-25}*60";
pseconds="${2:-wseconds/300}*60";

usage()
{
    echo "Usage: $0 {focus time length} {break length}"
    echo "Times given should be integers representing minutes"
    echo "Defaults: focus time length = 25 minutes"
    echo "          break time length = 5 minutes"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -gt 2 ]; then
    echo "The Pomodoro Technique is a time management method developed by Francesco Cirillo in the late 1980s."
    usage
    exit 0
fi

integers='^[0-9]+$'
if ! [[ "$1" =~ $integers ]] || ! [[ "$2" =~ $integers ]]; then
    usage
    exit 1
fi

# Check os and behave accordingly
if [ "$(uname)" == "Darwin" ]; then
    while true; do
        date1=$(($(date +%s) + wseconds))
        while [ "$date1" -ge $(('date +%s')) ]; do
            echo -ne "$(date -u -j -f %s $((date1 - $(date +%s))) +%H:%M:%S)\r"
        done
        osascript -e 'display notification "Time to walk and rest!" with title "Break"';
        read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n';
        date2=$(($(date +%s) + pseconds))
        while [ "$date2" -ge "$(date +%s)" ]; do
            echo -ne "$(date -u -j -f %s $((date2 - $(date +%s))) +%H:%M:%S)\r"
        done
        osascript -e 'display notification "Time to get back to work" with title "Work"';
        read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n';
    done
elif [ "$(printf "%s" "$(uname -s)" | cut -c 1-5)" == "Linux" ] ; then
    while true; do
        date1=$(($(date +%s) + wseconds));
        while [ "$date1" -ge "$(date +%s)" ]; do
            echo -ne "$(date -u --date @$((date1 - $(date +%s))) +%H:%M:%S)\r"
        done
        notify-send "Break" "Time to walk and rest";
        read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n';
        date2=$(($(date +%s) + pseconds))
        while [ "$date2" -ge "$(date +%s)" ]; do
            echo -ne "$(date -u --date @$((date2 - $(date +%s))) +%H:%M:%S)\r"
        done
        notify-send "Work" "Time to get back to work";
        read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n';
    done
else
    echo -ne "Your OS is currently not supported\n";
fi
