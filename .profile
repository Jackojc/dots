#!/usr/bin/env sh

[[ $- != *i* ]] && return

export PATH="$PATH:$(find $HOME/scripts -type d | tr '\n' ':')~/.local/bin:/home/jack/.local/share/cargo/bin"

export TODO="$HOME/notes/todo"
export DIR_MEDIA="$HOME/media"
export DIR_WALLPAPERS="$DIR_MEDIA/wallpapers"

export XDG_PUBLICSHARE_DIR="/dev/null"
export XDG_TEMPLATES_DIR="/dev/null"
export XDG_DESKTOP_DIR="$HOME"
export XDG_DOCUMENTS_DIR="$HOME/docs"
export XDG_DOWNLOAD_DIR="$HOME/downloads"
export XDG_MUSIC_DIR="$DIR_MEDIA/music"
export XDG_PICTURES_DIR="$DIR_MEDIA/pictures"
export XDG_VIDEOS_DIR="$DIR_MEDIA/videos"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export LESSHISTFILE="-"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"

export GPG_TTY=$(tty)
export FZF_DEFAULT_OPTS="--layout=reverse --height 25%"
export SAMPLER_SAVE_DIRECTORY="$HOME/samples"

export WINDOWMANAGER="bspwm"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"
export EDITOR="kak"


# prompt
ESC=$(printf "\e")
RESET="$(tput sgr0)"

PATHCOL="$ESC[1;95m"
PATHCOLROOT="$ESC[1;91m"
GITCOL="$ESC[1;92m"
PS2COL="$(tput setaf 6)"

git_prompt() {
	git branch 2>/dev/null | rg -o '\*.+' | cut -b1 --complement
}

if [ "$EUID" -ne 0 ]; then
	# non root
	export PS1='\[$PATHCOL\]\W\[$GITCOL\]$(git_prompt)\[$RESET\] '
else
	# root
	export PS1='\[$PATHCOLROOT\]\W\[$GITCOL\]$(git_prompt)\[$RESET\] # '
fi

export PS2='| \[${PS2COL}\]=>\[${RESET}\] '



export PROMPT_DIRTRIM=3
export CDPATH="."

export HISTSIZE=500000
export HISTFILESIZE=100000
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:l:la:ll:lal:lt:l.:jump:goto:z:s:bg:fg:history:clear:c"


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

alias xi="sudo xbps-install -S"
alias xr="sudo xbps-remove -R"
alias xu="sudo xbps-install -Su"
alias xc="sudo xbps-remove -Oo"

# Allows us to pass multiple arguments that will be expanded into a single string.
# i.e: `xq a b c`
xq() {
	xbps-query -Rs "$(eval echo \"$@\")"
}

alias todo="$EDITOR $TODO"

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
alias ls="exa --classify --color always --group-directories-first"
alias du="dust"
alias hexdump="hexyl"
alias cat="bat"

# git
alias gc="git commit"
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias ga="git add"
alias gl="git log"
alias gpl="git pull"
alias gpsh="git push"

# shortened
alias e="$EDITOR"
alias c="clear"
alias s="fzf"
alias b="bat"
alias v="$READER"
alias hd="hexdump"
alias img="sxiv"

alias l="ls"
alias la="l -a"
alias ll="l -l"
alias lal="l -al"
alias lt="l -T"
alias l.="la | rg --color never '^\.'"

alias jump='cd "$(find_dir)"'
alias goto='jump'
alias dots='git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'


# Make directory and cd into it.
cm() {
	mkdir "$1" 2>&1 > /dev/null
	cd "$1" 2>&1 > /dev/null
}



if [ "$(tty)" = "/dev/tty2" ]; then
	pgrep -x $WINDOWMANAGER || exec startx $WINDOWMANAGER 1> /dev/null 2>&1
fi


source /home/jack/.config/broot/launcher/bash/br
