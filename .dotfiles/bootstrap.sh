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
sudo cp -rf etc/* /etc 1> /dev/null 2>&1
sudo cp -rf usr/* /usr 1> /dev/null 2>&1


# Enable non-free and 32 bit repos.
notice "adding repos"
sudo xbps-install -Sy void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree 1> /dev/null 2>&1 || die "installing non-free repos"

# Install packages.
notice "installing packages"
sudo xbps-install -Syu $(sed 's/#.*//' < package_list.txt | tr '\n' ' ' | sed 's/ \+/ /gp') 1> /dev/null 2>&1 || die "installing packages"


cd $HOME 1> /dev/null 2>&1

# Setup home directory structure.
notice "setting up home directory structure"
mkdir -pv docs downloads media notes projects scraps scripts music movies tv videos pictures 1> /dev/null 2>&1

# Download wallpapers.
notice "downloading wallpapers"
git clone https://github.com/Jackojc/wallpapers.git wallpapers 1> /dev/null 2>&1 || notice "\twallpapers already downloaded"

# Setup dotfiles.
notice "checking out dotfiles"
dots checkout 1> /dev/null 2>&1

# Setup font cache.
notice "refreshing font cache"
fc-cache -vrf 1> /dev/null 2>&1

# Fix Tmux colours in st.
notice "installing terminfo fix for tmux"
tic .config/kak/tmux-256color.terminfo 1> /dev/null 2>&1

# Setup core services.
notice "enable services"
sudo ln -s /etc/sv/dbus       /var/service 1> /dev/null 2>&1
sudo ln -s /etc/sv/chronyd    /var/service 1> /dev/null 2>&1
sudo ln -s /etc/sv/irqbalance /var/service 1> /dev/null 2>&1
sudo ln -s /etc/sv/earlyoom   /var/service 1> /dev/null 2>&1

if [ "$platform" = "x230" ] || [ "$platform" = "x240" ]; then
	sudo ln -s /etc/sv/iwd        /var/service 1> /dev/null 2>&1
	sudo ln -s /etc/sv/tlp        /var/service 1> /dev/null 2>&1
	sudo ln -s /etc/sv/thinkfan   /var/service 1> /dev/null 2>&1
	sudo ln -s /etc/sv/bluetoothd /var/service 1> /dev/null 2>&1
fi


# Install st and dmenu.
notice "building st"
cd /tmp 1> /dev/null 2>&1
git clone https://github.com/Jackojc/st 1> /dev/null 2>&1 && (
	cd st
	./build.sh 1> /dev/null 2>&1
	sudo make install 1> /dev/null 2>&1
) || notice "\tst already installed"

notice "building dmenu"
cd /tmp 1> /dev/null 2>&1
git clone https://github.com/Jackojc/dmenu 1> /dev/null 2>&1 && (
	cd dmenu
	./build.sh 1> /dev/null 2>&1
	sudo make install 1> /dev/null 2>&1
) || notice "\tdmenu already installed"


# Swapfile.
notice "creating swap file"
test -f /swapfile && notice "\tswapfile already exists" || (
	sudo fallocate -l 8G /swapfile 1> /dev/null 2>&1
	sudo chmod 600 /swapfile 1> /dev/null 2>&1
	sudo mkswap /swapfile 1> /dev/null 2>&1
	sudo swapon /swapfile 1> /dev/null 2>&1
	echo "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab 1> /dev/null 2>&1

	# Swapiness
	notice "set swappiness"
	sudo sysctl -w vm.swappiness=45 1> /dev/null 2>&1
	sudo mkdir -p /etc/sysctl.d 1> /dev/null 2>&1
	echo "vm.swappiness=35" | sudo tee /etc/sysctl.d/99-swappiness.conf 1> /dev/null 2>&1
)




# Nonfree stuff
notice "enabling non-free binary packages"
cd ~/scraps/ 1> /dev/null 2>&1
git clone https://github.com/void-linux/void-packages --depth=1 1> /dev/null 2>&1
cd void-packages/ 1> /dev/null 2>&1
./xbps-src binary-bootstrap 1> /dev/null 2>&1
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf


notice "installing spotify"
xbps-query discord 1> /dev/null 2>&1 && notice "\tspotify already installed" || (
	./xbps-src pkg spotify 1> /dev/null 2>&1
	./xbps-src install spotify 1> /dev/null 2>&1
	sudo xbps-install --repository=hostdir/binpkgs/nonfree spotify 1> /dev/null 2>&1
)


notice "installing discord"
xbps-query spotify 1> /dev/null 2>&1 && notice "\tdiscord already installed" || (
	./xbps-src pkg discord 1> /dev/null 2>&1
	./xbps-src install discord 1> /dev/null 2>&1
	sudo xbps-install --repository=hostdir/binpkgs/nonfree discord 1> /dev/null 2>&1
)


sudo plymouth-set-default-theme deus_ex 1> /dev/null 2>&1
notice "make sure to run dracut to enable plymouth module"

notice "run the commands in `gpg_commands` to fix directory perm issue"
