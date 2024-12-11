#!/bin/bash

clock=(
  update_freq=30
  script="$PLUGIN_DIR/clock.sh"
  click_script="open -a 'Clock'"
)

sketchybar --add item clock right       \
           --set clock "${clock[@]}" \
           --subscribe clock system_woke
