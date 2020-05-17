#!/usr/bin/env sh

[[ $- != *i* ]] && return

export PATH="$PATH:$(find $HOME/scripts -type d | tr '\n' ':')~/.local/bin"

export TMPDIR="/tmp"
export FILE_TODO="$HOME/notes/todo"
export FILE_SHOPPING="$HOME/notes/shopping"
export DIR_WALLPAPERS="$HOME/media/wallpapers"
export DIR_CONFIG="$HOME/.config"

export EDITOR="kak"

export PROG_WM="bspwm"
export PROG_TERMINAL="st"



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

if [ "$DISPLAY" ]; then
	export PROMPT_COMMAND='echo -en "\033_;${PWD}\007\033]2;\007"'
fi


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

alias todo="$EDITOR $FILE_TODO"
alias shopping="$EDITOR $FILE_SHOPPING"

# use sane flags
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
alias v="evince"

alias goto='cd "$(find_dir)"'

alias dots='git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'


function cm {
	mkdir "$1" && cd "$1"
}



if [ "$(tty)" = "/dev/tty2" ]; then
	pgrep -x $PROG_WM || exec startx $PROG_WM
fi



