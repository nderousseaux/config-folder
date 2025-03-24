#!/bin/bash
# nothing or 1 argument (counter)
# Swap all windows in the current space

# Get all windows in the current space
windows=$(yabai -m query --windows --space | jq '.')

# Sort windows by their position in the space
if [ "$#" -eq 1 ]; then
	windows=$(echo $windows | jq 'sort_by(.frame.x) | reverse')
else
	windows=$(echo $windows | jq 'sort_by(.frame.x)')
fi


window_count=$(echo $windows | jq 'length')

# get all positions and sizes of windows
windows_positions=()

for i in $(seq 0 $(($window_count - 1))); do
		windows_positions[$i]=$(echo $windows | jq -r ".[$i].frame")
done

# Format of the frame object:
# {
#   "x": 80.0000,
#   "y": 109.0000,
#   "w": 1606.0000,
#   "h": 972.0000
# }

for i in $(seq 0 $(($window_count - 1))); do
	window=$(echo $windows | jq ".[$i]" | jq ".id")
	
	next_index=$((($i + 1) % $window_count))
	x=$(echo ${windows_positions[$next_index]} | jq '.x')
	y=$(echo ${windows_positions[$next_index]} | jq '.y')
	w=$(echo ${windows_positions[$next_index]} | jq '.w')
	h=$(echo ${windows_positions[$next_index]} | jq '.h')
	
	yabai -m window $window --move abs:$x:$y
	yabai -m window $window --resize abs:$w:$h
done