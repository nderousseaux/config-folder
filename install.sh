#!/bin/zsh

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

# Step 4: Install and configure zsh and oh-my-zsh 
if ! command -v zsh &> /dev/null; then
    echo "🔍 zsh not found. Installing zsh..."
    brew install zsh
    echo "✅ zsh installed."
else
    echo "✅ zsh is already installed."
fi

# Step 5: Install oh-my-zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🔍 oh-my-zsh not found. Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ oh-my-zsh installed." 
else
    echo "✅ oh-my-zsh is already installed."
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "🔍 zsh-syntax-highlighting plugin not found. Installing..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "✅ zsh-syntax-highlighting plugin installed."
else
    echo "✅ zsh-syntax-highlighting plugin is already installed."
fi

# Install zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "🔍 zsh-autosuggestions plugin not found. Installing..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo "✅ zsh-autosuggestions plugin installed."
else
    echo "✅ zsh-autosuggestions plugin is already installed."
fi

# Install autojump
if ! command -v autojump &> /dev/null; then
    echo "🔍 autojump not found. Installing autojump..."
    brew install autojump
    echo "✅ autojump installed."
else
    echo "✅ autojump is already installed."
fi

# Move my theme to oh-my-zsh custom themes directory
echo "🔍 Installing sober theme..."
mkdir -p ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes
cp "$(dirname "$0")/sober.zsh-theme" ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/sober.zsh-theme
echo "✅ sober theme installed."

# Copy the .zshrc configuration file
echo "🔄 Configuring zsh..."
cp "$(dirname "$0")/.zshrc" ~/.zshrc
echo "✅ zsh configured."

# Step 6: Configure SSH
echo "🔄 Configuring SSH..."
if [ ! -d ~/.ssh ]; then
    mkdir -p ~/.ssh
fi
rm -rf ~/.ssh/config.d
rm -f ~/.ssh/config
cp "$(dirname "$0")/ssh/config" ~/.ssh/config
cp -r "$(dirname "$0")/ssh/config.d" ~/.ssh/config.d
rm -rf ~/.ssh/rsa_keys
cp -r "$(dirname "$0")/ssh/rsa_keys" ~/.ssh/rsa_keys
chmod 700 ~/.ssh/rsa_keys/priv
chmod 600 ~/.ssh/rsa_keys/priv/*
echo "✅ SSH configured."

# Step 7: Install and configure git
if ! command -v git &> /dev/null; then
    echo "🔍 git not found. Installing git..."
    brew install git
    echo "✅ git installed."
else
    echo "✅ git is already installed."
fi
# Copy the .gitconfig configuration file
echo "🔄 Configuring git..."
cp "$(dirname "$0")/.gitconfig" ~/.gitconfig
echo "✅ git configured."

# Step 8: Install and configure tmux
if ! command -v tmux &> /dev/null; then
    echo "🔍 tmux not found. Installing tmux..."
    brew install tmux
    echo "✅ tmux installed."
else
    echo "✅ tmux is already installed."
fi
# Copy the .tmux.conf configuration file
echo "🔄 Configuring tmux..."
cp "$(dirname "$0")/.tmux.conf" ~/.tmux.conf

# Update the colors in .tmux.conf using colors from colors.sh
echo "🎨 Updating tmux colors..."

# Replace base colors in tmux configuration
tmux_replacements=0
for color_entry in "${COLORS[@]}"; do
    color_name="${color_entry%:*}"
    color_value="${color_entry#*:}"
    # Count replacements made
    before_count=$(grep -o "\${colors\.$color_name}" ~/.tmux.conf | wc -l | tr -d ' ')
    sed -i '' "s/\\\${colors\\.$color_name}/$color_value/g" ~/.tmux.conf
    tmux_replacements=$((tmux_replacements + before_count))
done

echo "✅ tmux configured with $tmux_replacements color replacements."

echo "🎉 Setup complete! Please restart your terminal to apply all changes."