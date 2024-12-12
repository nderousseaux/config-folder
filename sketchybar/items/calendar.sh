#!/bin/bash

calendar=(
  label.padding_left=10
  label.font="$FONT:Black:12.0"
  update_freq=30
  script="$PLUGIN_DIR/calendar.sh"
  click_script="open -a 'Calendar'"
)

sketchybar --add item calendar right       \
           --set calendar "${calendar[@]}" \
           --subscribe calendar system_woke
