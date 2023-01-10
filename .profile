#!/usr/bin/env sh

[[ $- != *i* ]] && return

export $(dbus-launch)

export PATH="$PATH:$(find $HOME/scripts -type d | tr '\n' ':')~/.local/bin:/home/jack/.local/share/cargo/bin"

export TODO="$HOME/notes/todo"
export DIR_MEDIA="$HOME/media"
export DIR_MUSIC="$DIR_MEDIA/music"
export DIR_WALLPAPERS="$DIR_MEDIA/wallpapers"
export DIR_NOTES="$HOME/notes"
export DIR_STICKERS="$HOME/stickers"

export XDG_PUBLICSHARE_DIR="/dev/null"
export XDG_TEMPLATES_DIR="/dev/null"
export XDG_DESKTOP_DIR="$HOME"
export XDG_DOCUMENTS_DIR="$HOME/docs"
export XDG_DOWNLOAD_DIR="$HOME/downloads"
export XDG_MUSIC_DIR="$DIR_MEDIA/music"
export XDG_PICTURES_DIR="$DIR_MEDIA/pictures"
export XDG_VIDEOS_DIR="$DIR_MEDIA/videos"

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_HOME="$HOME/.config"

export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export LESSHISTFILE="-"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GOPATH="$XDG_DATA_HOME/go"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"

export GPG_TTY=$(tty)
export FZF_DEFAULT_OPTS="--layout=reverse --height 25%"
export PF_INFO="ascii title os host uptime pkgs editor wm"

export SAMPLER_SAVE_DIRECTORY="$HOME/samples"
export SAMPLER_TMP_FILE="$XDG_RUNTIME_DIR/SAMPLER"

export RECORDER_SAVE_DIRECTORY="$HOME/recordings"
export RECORDER_TMP_FILE="$XDG_RUNTIME_DIR/RECORDER"

export PASH_LENGTH="50"
export PASH_PATTERN="_[:alnum:][:graph:]"
export PASH_KEYID="jackojc@gmail.com"
export PASH_DIR="$XDG_DATA_HOME/passwords"
export PASH_CLIP='xclip -sel c'
export PASH_TIMEOUT="6"

export XSECURELOCK_PROMPT=time_hex
export XSECURELOCK_SHOW_HOSTNAME=0
export XSECURELOCK_SHOW_USERNAME=0
export XSECURELOCK_SHOW_DATETIME=0
export XSECURELOCK_FONT="Terminus (TTF)"

export BAR_FIFO="$XDG_RUNTIME_DIR/bar_fifo"
export BAR_FONT="Terminus (TTF)"
export BAR_NAME=bspwm_bar

export HOTKEY_FIFO="$XDG_RUNTIME_DIR/hotkey_fifo"

export WINDOWMANAGER="bspwm"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"
export EDITOR="kak"
export VIEWER="sxiv"

export WM="bspwm"


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

export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:l:la:ll:lal:lt:l.:jump:goto:z:s:bg:fg:history:clear:c"


# Set PWD of `st` after every command.
# This lets us launch other instances of `st`
# in the same directory.
if [ "$DISPLAY" ]; then
	export PROMPT_COMMAND='echo -en "\033_;${PWD}\007\033]2;\007"'
	echo -en "\033_;${PWD}\007\033]2;\007"
fi

# Append history after every command.
export PROMPT_COMMAND="history -a; ${PROMPT_COMMAND}"


shopt -s checkwinsize
shopt -s globstar
shopt -s nocaseglob
shopt -s histappend
shopt -s cmdhist
shopt -s autocd
shopt -s dirspell
shopt -s cdspell
shopt -s cdable_vars
shopt -s expand_aliases

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

# use sane flags
alias sudo="sudo -E"
alias uptime="uptime -p"
alias less="more"
alias mkdir="mkdir -pv"
alias cp="cp -iva"
alias mv="mv -iv"
alias rm="rm -vI"
alias df="duf"
alias free="free -m"
alias sxiv="sxiv -aq"
alias qmv="qmv -fdo"
alias ls="exa --classify --color always --group-directories-first"
alias du="dust"
alias hexdump="hexyl"
alias cat="bat"
alias pass="pash"
alias ip="ip -br -c"
alias ping="gping"

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
alias m="make"
alias e="$EDITOR"
alias c="clear"
alias s="fzf"
alias b="bat"
alias v="$READER"
alias hd="hexdump"
alias img="sxiv"
alias o="xdg-open"

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
	pgrep $WINDOWMANAGER || exec dbus-run-session startx $WINDOWMANAGER >/dev/null 2>&1
fi

