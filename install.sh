#!/bin/bash

# Step 1: Install Xcode Command Line Tools
if ! xcode-select -p &> /dev/null; then
    echo "🔍 Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    # Wait until the Xcode Command Line Tools are installed
    until xcode-select -p &> /dev/null; do
        sleep 5
    done
    echo "✅ Xcode Command Line Tools installed."
else
    echo "✅ Xcode Command Line Tools are already installed."
fi

# Step 2: Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "🔍 Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session
    if [[ $(uname -m) == "arm64" ]]; then
        # Apple Silicon Mac
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        # Intel Mac
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    echo "✅ Homebrew installed and configured."
else
    echo "✅ Homebrew is already installed."
fi

# Step 3: install and configure hyper
if ! command -v hyper &> /dev/null; then
    echo "🔍 Hyper terminal not found. Installing Hyper..."
    brew install --cask hyper
    echo "✅ Hyper terminal installed."
else
    echo "✅ Hyper terminal is already installed."
fi
# Copy the .hyper.js configuration file
echo "🔄 Configuring Hyper..."
cp "$(dirname "$0")/.hyper.js" ~/.hyper.js

# Update the colors object in .hyper.js using colors from colors.sh
echo "🎨 Updating Hyper colors..."

# Source the colors file
source "$(dirname "$0")/colors.sh"

# Function to get color value by name
get_color_value() {
    local color_name="$1"
    for color_entry in "${COLORS[@]}"; do
        if [[ "${color_entry%:*}" == "$color_name" ]]; then
            echo "${color_entry#*:}"
            return
        fi
    done
    echo "$color_name" # Return original if not found
}

# Replace base colors first
for color_entry in "${COLORS[@]}"; do
    color_name="${color_entry%:*}"
    color_value="${color_entry#*:}"
    sed -i '' "s/\\\${colors\\.$color_name}/$color_value/g" ~/.hyper.js
done

# Replace configuration variables that reference colors
for config_entry in "${CONFIG_VARS[@]}"; do
    config_name="${config_entry%:*}"
    color_ref="${config_entry#*:}"
    color_value=$(get_color_value "$color_ref")
    sed -i '' "s/\\\${colors\\.$config_name}/$color_value/g" ~/.hyper.js
done

total_replacements=$((${#COLORS[@]} + ${#CONFIG_VARS[@]}))
echo "✅ Updated $total_replacements variables in Hyper configuration (${#COLORS[@]} colors + ${#CONFIG_VARS[@]} config vars)"
