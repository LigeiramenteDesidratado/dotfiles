export TERMINAL=/usr/local/bin/st
export EDITOR="nvim --noplugin"
export BROWSER=brave
export READER=/usr/bin/zathura
export TERM=st-256color
export COLORTERM=24bit
export WALLCMD="/usr/bin/xwallpaper --daemon --zoom "

# stop gdb from downloading debug info
# unset DEBUGINFOD_URLS

# golang home and bin dir
export GOPATH=$HOME/dev/golang
export GOBIN=$GOPATH/bin

export PATH=$PATH:$GOPATH:$GOBIN:$HOME/.local/bin/:$HOME/.local/bin/cron:$HOME/.cargo/bin

# AUTOCOMPLETION
  
# initialize autocompletion
autoload -U compinit && compinit

# history setup
setopt SHARE_HISTORY
HISTFILE=$HOME/.zsh_history
SAVEHIST=100000
HISTSIZE=100000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE

# coloured manuals
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

setprompt() {
  setopt prompt_subst

  if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
    $='%F{yellow}%M%f'
  else
    p_host='%F{green}%M%f'
  fi

  PS1='%F{120}[%f%F{255}%K{236}%c%k%f%F{120}]%f '

  PS2=$'%_>'
  RPROMPT=$'$(__git_ps1 "%%F{69}[%%f%%F{255}%%K{236}%s%%f%%k%%F{69}]")%f%(?.    . %F{red}$?)%f'
}
setprompt

source $HOME/.aliases

# function c {
#     builtin cd "$@" && clear && l
# }
function list_all() {
  emulate -L zsh
  l
}
chpwd_functions=(${chpwd_functions[@]} "list_all")

function fman() {
    man -k . | fzf -q "$1" --prompt='man> '  --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}

function in() {
    yay -Slq | fzf -q "$1" -m --preview 'yay -Si {1}'| xargs -ro yay -S
}
# Remove installed packages (change to pacman/AUR helper of your choice)
function re() {
    yay -Qq | fzf -q "$1" -m --preview 'yay -Qi {1}' | xargs -ro yay -Rns
}

# use current dir as terminal title
precmd () { print -Pn "\e]2;%~\a" }

# PLUGINS
source ~/.zsh/plugins/git/git-prompt.sh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#=================================================#
# git prompt options
#=================================================#
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_STATESEPARATOR=' '
GIT_PS1_HIDE_IF_PWD_IGNORED=true
GIT_PS1_COMPRESSSPARSESTATE=true

#=================================================#
# FZF plugin options
#=================================================#
export FZF_DEFAULT_OPTS="--bind 'alt-k:preview-up,alt-j:preview-down,ctrl-y:execute-silent(printf {} | cut -f 2- | xclip -r -i)' --inline-info --height 50% --layout=default"
export FZF_CTRL_T_COMMAND=""
export FZF_CTRL_T_OPTS=""
export FZF_CTRL_R_OPTS=""
export FZF_DEFAULT_COMMAND="rg --files --no-messages --no-ignore --no-ignore-vcs --hidden -S --glob !.git --glob !node_modules --glob !.ccls-cache --glob !.icons "
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude ".git"'
export FZF_ALT_C_OPTS=""
export FZF_COMPLETION_TRIGGER=",,"
export FZF_COMPLETION_DIR_COMMANDS="cd rmdir pushd"
bindkey '^j' fzf-cd-widget

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  eval $FZF_DEFAULT_COMMAND . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

#=================================================#
# zsh-autosuggestions plugin options
#=================================================#
ZSH_AUTOSUGGEST_USE_ASYNC=true
bindkey '^f' autosuggest-accept
