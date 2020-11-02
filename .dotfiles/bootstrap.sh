#!/usr/bin/env sh


alias dots='git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'

die() {
	echo "[!] an error occured!" && exit 1
}

notice() {
	echo "[*] $@"
}


# Copy system wide configs.
sudo cp -rf etc/* /etc

# Add sensors to thinkfan config.
sudo find /sys/devices -type f -name 'temp*_input' | xargs -I {} echo "hwmon {}" | sudo tee -a /etc/thinkfan.conf


# Enable non-free and 32 bit repos.
notice "adding repos"
sudo xbps-install -Sy void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree || die

# Install packages.
notice "installing packages"
sudo xbps-install -Syu $(sed 's/#.*//' < package_list.txt | tr '\n' ' ' | sed 's/ \+/ /gp') || die


cd $HOME

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
sudo ln -s /etc/sv/thinkfan   /var/service
sudo ln -s /etc/sv/iwd        /var/service
sudo ln -s /etc/sv/irqbalance /var/service
sudo ln -s /etc/sv/earlyoom   /var/service
sudo ln -s /etc/sv/bluetoothd /var/service

# Install st and dmenu.
cd /tmp

git clone https://github.com/Jackojc/st
git clone https://github.com/Jackojc/dmenu

cd st
./build.sh
sudo make install

cd ../dmenu
./build.sh
sudo make install

# Swapfile.
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab

# Swapiness
sudo sysctl -w vm.swappiness=70
sudo mkdir -p /etc/sysctl.d
echo "vm.swappiness=70" | sudo tee /etc/sysctl.d/99-swappiness.conf

# Nonfree stuff
cd ~/scraps/
git clone https://github.com/void-linux/void-packages --depth=1
cd void-packages/
./xbps-src binary-bootstrap
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf
./xbps-src pkg spotify
./xbps-src install spotify
sudo xbps-install --repository=hostdir/binpkgs/nonfree spotify
