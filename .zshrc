

# Oh my zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="common"

plugins=(git virtualenv zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

#Couleur des fichiers
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad


#On ajoute les path
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Library/TeX/texbin/:$PATH"
export PATH="$PATH:/Users/nderousseaux/bin/"
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/bison/bin:$PATH"
export PATH="/usr/local/opt/flex/bin:$PATH"
export PATH=/usr/local/opt/python/libexec/bin:$PATH
export C_INCLUDE_PATH=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.1.sdk/usr/include
export CPLUS_INCLUDE_PATH=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.1.sdk/usr/include
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
eval $(opam config env --root=~/.opam)

#Extensions

# Autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# Autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Alias
alias linux='docker run -it --hostname linux --name linux --rm -v "$PWD":/code nderousseaux/linux'
alias glinux='xhost + 127.0.0.1 && docker run -it --hostname linux --name linux --rm -e DISPLAY=host.docker.internal:0 -v "$PWD":/code nderousseaux/linux'
alias quoi="echo FEUR !"
alias tg='echo "Ok..."; sleep 2; exit'
alias v='vim'


_cli_zsh_autocomplete() {
    local -a opts
    local cur
    cur=${words[-1]}
    if [[ "$cur" == "-"* ]]; then
        opts=("${(@f)$(_CLI_ZSH_AUTOCOMPLETE_HACK=1 ${words[@]:0:#words[@]-1} ${cur} --generate-bash-completion)}")
    else
        opts=("${(@f)$(_CLI_ZSH_AUTOCOMPLETE_HACK=1 ${words[@]:0:#words[@]-1} --generate-bash-completion)}")
    fi

    if [[ "${opts[1]}" != "" ]]; then
        _describe 'values' opts
    else
        _files
    fi

    return
}

compdef _cli_zsh_autocomplete influx

function brew() {
  command brew "$@" 

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_update
  fi
}

export NODE_OPTIONS='--disable-warning=ExperimentalWarning'
