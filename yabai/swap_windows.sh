#!/bin/bash
# 1 argument : <left|right|up|down>

# Get the current window id
current_window_id=$(yabai -m query --windows --window | jq -r '.id')

# Get all windows in the current space
windows=$(yabai -m query --windows --space | jq '.')

# Get the first window id in the direction specified
case $1 in
	"left")
		windows=$(echo $windows | jq 'sort_by(.frame.x)')
		;;
	"right")
		windows=$(echo $windows | jq 'sort_by(.frame.x) | reverse')
		;;
	"up")
		windows=$(echo $windows | jq 'sort_by(.frame.y)')
		;;
	"down")
		windows=$(echo $windows | jq 'sort_by(.frame.y) | reverse')
		;;
esac
# Looking for the window after the current one
window_count=$(echo $windows | jq 'length')
for i in $(seq 0 $(($window_count - 1))); do
	window_id=$(echo $windows | jq -r ".[$i].id")
	if [ "$window_id" = "$current_window_id" ]; then
		next_index=$((($i + 1) % $window_count))
		new_window_id=$(echo $windows | jq -r ".[$next_index].id")
		break
	fi
done

# swap position AND size
current_window_frame=$(echo $windows | jq ".[] | select(.id == $current_window_id) | .frame")
new_window_frame=$(echo $windows | jq ".[] | select(.id == $new_window_id) | .frame")

current_window_x=$(echo $current_window_frame | jq '.x')
current_window_y=$(echo $current_window_frame | jq '.y')
current_window_w=$(echo $current_window_frame | jq '.w')
current_window_h=$(echo $current_window_frame | jq '.h')

new_window_x=$(echo $new_window_frame | jq '.x')
new_window_y=$(echo $new_window_frame | jq '.y')
new_window_w=$(echo $new_window_frame | jq '.w')
new_window_h=$(echo $new_window_frame | jq '.h')

yabai -m window $current_window_id --move abs:$new_window_x:$new_window_y
yabai -m window $current_window_id --resize abs:$new_window_w:$new_window_h

yabai -m window $new_window_id --move abs:$current_window_x:$current_window_y
yabai -m window $new_window_id --resize abs:$current_window_w:$current_window_h
