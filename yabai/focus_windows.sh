#!/bin/bash
# 1 argument : left, up, down, right

# Get all windows in the current space
windows=$(yabai -m query --windows --space | jq '.')

# Sort windows by their position in the space
if [ "$#" -eq 1 ] && [ "$1" == "left" ]; then
	windows=$(echo $windows | jq 'sort_by(.frame.x) | reverse')

elif [ "$#" -eq 1 ] && [ "$1" == "up" ]; then
	windows=$(echo $windows | jq 'sort_by(.frame.y)')

elif [ "$#" -eq 1 ] && [ "$1" == "down" ]; then

	windows=$(echo $windows | jq 'sort_by(.frame.y) | reverse')	

else
	windows=$(echo $windows | jq 'sort_by(.frame.x)')
fi

windows_ids=$(echo $windows | jq -r '.[].id')

current_window_id=$(yabai -m query --windows --window | jq -r '.id')
current_window_index=$(($(echo $windows_ids | tr ' ' '\n' | grep -n $current_window_id | cut -d: -f1) - 1))

next_index=$((($current_window_index + 1) % $(echo $windows | jq 'length')))
next_id=$(echo $windows | jq -r ".[$next_index].id")


yabai -m window --focus $next_id