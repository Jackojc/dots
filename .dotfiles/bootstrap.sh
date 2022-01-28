#!/usr/bin/env sh


alias dots='git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'

die() {
	echo "[!] an error occured: $@!" && exit 1
}

notice() {
	echo "[*] $@"
}


platform="$1"

case "$platform" in
	"x230") notice "installing for x230..." ;;
	"x240") notice "installing for x240..." ;;
	"amdfx") notice "installing for amdfx..." ;;
	*) die "unknown platform, make sure to specify one of: 'x230', 'x240' or 'amdfx' as the first argument" ;;
esac


# Copy system wide configs.
notice "copying system config"
sudo cp -rf etc/* /etc 2>&1 > /dev/null
sudo cp -rf usr/* /usr 2>&1 > /dev/null


# Enable non-free and 32 bit repos.
notice "adding repos"
sudo xbps-install -Sy void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree 2>&1 > /dev/null || die "installing non-free repos"

# Install packages.
notice "installing packages"
sudo xbps-install -Syu $(sed 's/#.*//' < package_list.txt | tr '\n' ' ' | sed 's/ \+/ /gp') 2>&1 > /dev/null || die "installing packages"


cd $HOME 2>&1 > /dev/null

# Setup home directory structure.
notice "setting up home directory structure"
mkdir -pv docs downloads notes projects scraps scripts misc 2>&1 > /dev/null
mkdir -pv media/tv media/wallpaper media/videos media/pictures media/movies media/music media/torrents 2>&1 > /dev/null

# Download wallpapers.
notice "downloading wallpapers"
git clone https://github.com/Jackojc/wallpapers.git wallpapers 2>&1 > /dev/null || notice "\twallpapers already downloaded"

# Setup dotfiles.
notice "checking out dotfiles"
dots checkout 2>&1 > /dev/null

# Setup font cache.
notice "refreshing font cache"
fc-cache -vrf 2>&1 > /dev/null

# Fix Tmux colours in st.
notice "installing terminfo fix for tmux"
tic .config/kak/tmux-256color.terminfo 2>&1 > /dev/null

# Setup core services.
notice "enable services"
sudo ln -s /etc/sv/dbus       /var/service 2>&1 > /dev/null
sudo ln -s /etc/sv/chronyd    /var/service 2>&1 > /dev/null

if [ "$platform" = "x230" ] || [ "$platform" = "x240" ]; then
	sudo ln -s /etc/sv/iwd        /var/service 2>&1 > /dev/null
	sudo ln -s /etc/sv/tlp        /var/service 2>&1 > /dev/null
	sudo ln -s /etc/sv/thinkfan   /var/service 2>&1 > /dev/null
	sudo ln -s /etc/sv/bluetoothd /var/service 2>&1 > /dev/null
fi


# Install st and dmenu.
notice "building st"
cd /tmp 2>&1 > /dev/null
git clone https://github.com/Jackojc/st 2>&1 > /dev/null && (
	cd st
	./build.sh 2>&1 > /dev/null
	sudo make install 2>&1 > /dev/null
) || notice "\tst already installed"

notice "building dmenu"
cd /tmp 2>&1 > /dev/null
git clone https://github.com/Jackojc/dmenu 2>&1 > /dev/null && (
	cd dmenu
	./build.sh 2>&1 > /dev/null
	sudo make install 2>&1 > /dev/null
) || notice "\tdmenu already installed"


# Swapfile.
notice "creating swap file"
test -f /swapfile && notice "\tswapfile already exists" || (
	sudo fallocate -l 8G /swapfile 2>&1 > /dev/null
	sudo chmod 600 /swapfile 2>&1 > /dev/null
	sudo mkswap /swapfile 2>&1 > /dev/null
	sudo swapon /swapfile 2>&1 > /dev/null
	echo "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab 2>&1 > /dev/null

	# Swapiness
	notice "set swappiness"
	sudo sysctl -w vm.swappiness=45 2>&1 > /dev/null
	sudo mkdir -p /etc/sysctl.d 2>&1 > /dev/null
	echo "vm.swappiness=35" | sudo tee /etc/sysctl.d/99-swappiness.conf 2>&1 > /dev/null
)




# Nonfree stuff
notice "enabling non-free binary packages"
cd ~/scraps/ 2>&1 > /dev/null
git clone https://github.com/void-linux/void-packages --depth=1 2>&1 > /dev/null
cd void-packages/ 2>&1 > /dev/null
./xbps-src binary-bootstrap 2>&1 > /dev/null
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf


notice "installing spotify"
xbps-query discord 2>&1 > /dev/null && notice "\tspotify already installed" || (
	./xbps-src pkg spotify 2>&1 > /dev/null
	./xbps-src install spotify 2>&1 > /dev/null
	sudo xbps-install --repository=hostdir/binpkgs/nonfree spotify 2>&1 > /dev/null
)


notice "installing discord"
xbps-query spotify 2>&1 > /dev/null && notice "\tdiscord already installed" || (
	./xbps-src pkg discord 2>&1 > /dev/null
	./xbps-src install discord 2>&1 > /dev/null
	sudo xbps-install --repository=hostdir/binpkgs/nonfree discord 2>&1 > /dev/null
)


sudo plymouth-set-default-theme deus_ex 2>&1 > /dev/null
notice "make sure to run dracut to enable plymouth module"

notice "run the commands in `gpg_commands` to fix directory perm issue"
