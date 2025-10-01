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
if [ -f ~/.hyper.js ]; then
    rm -f ~/.hyper.js.old
    cp ~/.hyper.js ~/.hyper.js.old
    rm -f ~/.hyper.js
    echo "✅ Existing .hyper.js backed up to ~/.hyper.js.old"
fi
cp "$(dirname "$0")/.hyper.js" ~/.hyper.js
echo "✅ Hyper configured."

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

# Move custom themes folder
echo "🔍 Installing custom themes..."
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes" ]; then
    rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes.old"
    mv "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes.old"
    rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
fi
cp -lR "$(dirname "$0")/oh-my-zsh-themes" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
echo "✅ Custom themes installed."


# Copy the .zshrc configuration file
echo "🔄 Configuring zsh..."
if [ -f ~/.zshrc ]; then
    rm -f ~/.zshrc.old
    cp ~/.zshrc ~/.zshrc.old
    rm -f ~/.zshrc
    echo "✅ Existing .zshrc backed up to ~/.zshrc.old"
fi
ln "$(dirname "$0")/.zshrc" ~/.zshrc
echo "✅ zsh configured."

# Step 6: Configure SSH
echo "🔄 Configuring SSH..."
# Backup existing SSH configuration if it exists
if [ -d ~/.ssh ]; then
    rm -rf ~/.ssh.old
    cp -r ~/.ssh ~/.ssh.old
    rm -rf ~/.ssh
    echo "✅ Existing SSH configuration backed up to ~/.ssh.old"
fi
# Create a symbolic link to the SSH configuration directory
cp -lR "$(dirname "$0")/ssh" ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/rsa_keys/priv/*
chmod 644 ~/.ssh/rsa_keys/pub/*
chmod 644 ~/.ssh/config
chmod 644 ~/.ssh/config.d/*
# Restore known_hosts from backup if it exists
if [ -f ~/.ssh.old/known_hosts ]; then
    cp ~/.ssh.old/known_hosts ~/.ssh/known_hosts
    chmod 644 ~/.ssh/known_hosts
    echo "✅ Restored known_hosts from backup"
fi
echo "✅ SSH configured."

# Step 7: Install and configure git
if ! command -v git &> /dev/null; then
    echo "🔍 git not found. Installing git..."
    brew install git
    echo "✅ git installed."
else
    echo "✅ git is already installed."
fi
if [ -f ~/.gitconfig ]; then
    rm -f ~/.gitconfig.old
    cp ~/.gitconfig ~/.gitconfig.old
    rm -f ~/.gitconfig
    echo "✅ Existing git configuration backed up to ~/.gitconfig.old"
fi
cp "$(dirname "$0")/git/config" ~/.gitconfig

# Step 8: Install and configure vim
if ! command -v vim &> /dev/null; then
    echo "🔍 vim not found. Installing vim..."
    brew install vim
    echo "✅ vim installed."
else
    echo "✅ vim is already installed."
fi
# Copy the .vimrc configuration file
echo "🔄 Configuring vim..."
if [ -f ~/.vimrc ]; then
    rm -f ~/.vimrc.old
    cp ~/.vimrc ~/.vimrc.old
    rm -f ~/.vimrc
    echo "✅ Existing .vimrc backed up to ~/.vimrc.old"
fi
ln "$(dirname "$0")/.vimrc" ~/.vimrc

# Install vim-plug plugin manager if not installed
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    echo "🔍 vim-plug not found. Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "✅ vim-plug installed."
else
    echo "✅ vim-plug is already installed."
fi

# Install plugins defined in .vimrc
echo "🔄 Installing vim plugins..."
vim +PlugInstall +qall
echo "✅ vim plugins installed."

echo "✅ vim configured."


# Step 9: Install and configure tmux
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