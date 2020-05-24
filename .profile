#!/usr/bin/env sh

[[ $- != *i* ]] && return

export PATH="$PATH:$(find $HOME/scripts -type d | tr '\n' ':')~/.local/bin"

export TODO="$HOME/notes/todo"
export DIR_WALLPAPERS="$HOME/media/wallpapers"

# export XDG_RUNTIME_DIR="/tmp"

# export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_DATA_HOME="$HOME/.local/share"
# export XDG_CACHE_HOME="$HOME/.cache"

export XDG_PUBLICSHARE_DIR="/dev/null"
export XDG_TEMPLATES_DIR="/dev/null"
export XDG_DESKTOP_DIR="$HOME"
export XDG_DOCUMENTS_DIR="$HOME/docs"
export XDG_DOWNLOAD_DIR="$HOME/downloads"
export XDG_MUSIC_DIR="$HOME/media/music"
export XDG_PICTURES_DIR="$HOME/media/pictures"
export XDG_VIDEOS_DIR="$HOME/media/videos"


export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"


export SUDO_ASKPASS="prompt_pass"
export FZF_DEFAULT_OPTS="--layout=reverse --height 25%"


export WINDOWMANAGER="bspwm"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"
export EDITOR="kak"



# prompt
ESC=$(printf "\e")
RESET="$(tput sgr0)"

PATHCOL="$ESC[95m"
PATHCOLROOT="$ESC[91m"
GITCOL="$ESC[92m"
PS2COL="$(tput setaf 6)"

git_prompt() {
	git branch 2>/dev/null | rg -o '\*.+' | cut -b1 --complement
}

if [ "$EUID" -ne 0 ]; then
	# non root
	export PS1='[\[$PATHCOL\]\W\[$GITCOL\]$(git_prompt)\[$RESET\]] '
else
	# root
	export PS1='[\[$PATHCOLROOT\]\W\[$GITCOL\]$(git_prompt)\[$RESET\]]# '
fi

export PS2='| \[${PS2COL}\]=>\[${RESET}\] '



export PROMPT_DIRTRIM=3
export CDPATH="."

export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:l:z:s:bg:fg:history:clear:c"


# Set PWD of `st` after every command.
# This lets us launch other instances of `st`
# in the same directory.
if [ "$DISPLAY" ]; then
	export PROMPT_COMMAND='echo -en "\033_;${PWD}\007\033]2;\007"'
fi

# Append history after every command.
export PROMPT_COMMAND="history -a; ${PROMPT_COMMAND}"


shopt -s checkwinsize
shopt -s globstar 2> /dev/null
shopt -s nocaseglob
shopt -s histappend
shopt -s cmdhist
shopt -s autocd 2> /dev/null
shopt -s dirspell 2> /dev/null
shopt -s cdspell 2> /dev/null
shopt -s cdable_vars

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set mark-symlinked-directories on"


stty -ixon

bind Space:magic-space

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

bind '"\e[C": forward-char'
bind '"\e[D": backward-char'


alias ~='cd $HOME'
alias ..='cd ..'
alias ..1='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'

alias install="sudo xbps-install -S"
alias remove="sudo xbps-remove -R"
alias query="xbps-query -Rs"
alias update="sudo xbps-install -Su"
alias cleanup="sudo xbps-remove -Oo"

alias todo="$EDITOR $TODO"

alias tmux="attach_to_tmux"

# use sane flags
alias sudo="sudo -E"
alias uptime="uptime -p"
alias less="more"
alias mkdir="mkdir -pv"
alias cp="cp -iva"
alias mv="mv -iv"
alias rm="rm -vI"
alias df="df -h"
alias free="free -m"
alias sxiv="sxiv -aq"
alias qmv="qmv -fdo"
alias ls="exa -F --group-directories-first"

# shortened
alias gc="git clone --recursive"
alias e="$EDITOR"
alias c="clear"
alias l="ls"
alias s="fzf"
alias b="bat"
alias v="$READER"

alias jump='cd "$(find_dir)"'
alias dots='git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'


function cm {
	mkdir "$1" && cd "$1"
}



if [ "$(tty)" = "/dev/tty2" ]; then
	pgrep -x $WINDOWMANAGER || exec startx $WINDOWMANAGER
fi



