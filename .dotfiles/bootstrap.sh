#!/usr/bin/env sh


alias dots='git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'

die() {
	echo "[!] an error occured!" && exit 1
}

notice() {
	echo "[*] $@"
}


cd "$HOME"

# Enable non-free and 32 bit repos.
notice "adding repos"
sudo xbps-install -Sy void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree || die

# Install packages.
notice "installing packages"
sudo xbps-install -Syu $(tr '\n' ' ' < ./packages) || die

# Setup home directory structure.
notice "setting up home directory structure"
mkdir -pv docs downloads media notes projects scraps scripts
mkdir -pv media/music media/movies media/tv media/videos media/pictures

# Download wallpapers.
notice "downloading wallpapers"
git clone https://github.com/Jackojc/wallpapers.git media/wallpapers

# Setup dotfiles.
notice "checking out dotfiles"
dots checkout

# Setup font cache.
notice "refreshing font cache"
fc-cache -vrf

# Fix Tmux colours in st.
notice "installing terminfo fix for tmux"
tic .config/kak/tmux-256color.terminfo

# Setup core services.
notice "enable core services"
sudo ln -s /etc/sv/dbus       /var/service
sudo ln -s /etc/sv/chronyd    /var/service
sudo ln -s /etc/sv/tlp        /var/service
sudo ln -s /etc/sv/irqbalance /var/service
sudo ln -s /etc/sv/thinkfan   /var/service
sudo ln -s /etc/sv/iwd        /var/service

