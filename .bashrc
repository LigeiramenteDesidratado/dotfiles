#!/bin/bash

stty -ixon # Disable ctrl-s and ctrl-q.
shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
HISTSIZE= HISTFILESIZE= # Infinite history.

# export PS1="\[$(tput bold)\]\[\033[38;5;11m\]\W > \[$(tput sgr0)\]"
export PS1="\[\033[38;5;160m\][\W] \[$(tput sgr0)\]"
export GPG_TTY=$(tty)
export EDITOR=nvim

source ~/.aliases
function c {
    builtin cd "$@" && clear && ls
}

# env
export PATH=$PATH:$HOME/.local/bin/:$HOME/.cargo/bin
# history with data
export HISTTIMEFORMAT="%d/%m/%y %T "

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
