#!/bin/bash

# Get the screen dimensions
screen_width=$(yabai -m query --displays --display | jq '.frame.w')
screen_height=$(yabai -m query --displays --display | jq '.frame.h')

# Get the current window dimensions
window_width=$(yabai -m query --windows --window | jq '.frame.w')
window_height=$(yabai -m query --windows --window | jq '.frame.h')

# Calculate the new position to center the window
new_x=$(( (${screen_width%.*} - ${window_width%.*}) / 2 ))
new_y=$(( (${screen_height%.*} - ${window_height%.*}) / 2 ))

# Move the window to the new position
yabai -m window --move abs:$new_x:$new_y