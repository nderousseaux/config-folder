#!/bin/bash

# Base color definitions for terminal configurations
# Format: "colorName:hexValue"
COLORS=(
    "black:#1E2127"
    "grey:#282C34"
    "greyOpacity:#282C34BF"
    "lightGrey:#34373f"
    "red:#E06C75"
    "green:#98C379"
    "yellow:#D19A66"
    "blue:#61AFEF"
    "magenta:#C678DD"
    "cyan:#56B6C2"
    "white:#ABB2BF"
    "lightBlack:#5C6370"
    "lightRed:#E06C75"
    "lightGreen:#98C379"
    "lightYellow:#D19A66"
    "lightBlue:#61AFEF"
    "lightMagenta:#C678DD"
    "lightCyan:#56B6C2"
    "lightWhite:#FFFFFF"
    "limeGreen:#32CD32"
    "lightCoral:#F08080"
)

# Configuration variables that reference base colors
# Format: "configName:colorReference"
CONFIG_VARS=(
    "cursorColor:lightBlack"
    "cursorAccentColor:black"
    "foregroundColor:white"
    "backgroundColor:greyOpacity"
    "selectionColor:lightGrey"
    "borderColor:grey"
)