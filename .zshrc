############## OH-MY-ZSH ##############
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="sober"
plugins=(git virtualenv zsh-syntax-highlighting zsh-autosuggestions tmux)
source $ZSH/oh-my-zsh.sh

#Couleur des fichiers
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Auto jump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

############## PATH ##############
# Package managers
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# Development tools
export PATH="/Library/TeX/texbin:$PATH"
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/bison/bin:$PATH"
export PATH="/usr/local/opt/flex/bin:$PATH"

# Programming languages
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin"

# User binaries
export PATH="$PATH:/Users/nderousseaux/bin/"

# Include paths
export C_INCLUDE_PATH="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.1.sdk/usr/include"
export CPLUS_INCLUDE_PATH="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.1.sdk/usr/include"


############## Alias ##############
alias bssh="ssh -t bastion --"
# alias dpda=" docker run --rm --volume "$PWD":/mnt --workdir /mnt -u 1000:1000 -i -t pdagog/refc"