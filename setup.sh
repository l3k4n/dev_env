inform_configure () {
    echo "\e[1;36m==========================================================\e[0m"
    echo "\e[1;36mConfiguring: $@\e[0m"
    echo "\e[1;36m==========================================================\e[0m"
}
inform_msg () {
    echo "\e[33m$@\e[0m"
}
add_to_bashrc () {
    if ! grep -q "$@" ~/.bashrc; then
        echo "$@" >> ~/.bashrc
    fi
}

if [ $(id -u) -eq 0 ]; then
	echo "DO NOT RUN SETUP SCRIPT AS ROOT"
	exit
fi

####################################################### ENVIRONMENT
# dependencies
inform_configure "general dependencies"
sudo apt-get -qq -y install cmake git-all stow autoconf

# i3
inform_configure "i3"
sudo apt-get -qq -y install i3 playerctl # config requires playerctl
# install i3blocks
git clone https://github.com/vivien/i3blocks
cd i3blocks
./autogen.sh
./configure
make
make install
cd ..
rm -rf i3blocks

# terminal
inform_configure "gnome terminal preferences"
cat gterminal.preferences | dconf load /org/gnome/terminal/

#feh
inform_configure "feh"
sudo apt install feh

# picom
inform_configure "picom"
# install dependencies
sudo apt-get -qq -y install libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev meson ninja-build uthash-dev libxext-dev libxcb-dpms0-dev
# clone latest release
picom_latest_release_tag=$(curl -s https://api.github.com/repos/yshui/picom/releases/latest | grep -oP '"tag_name": "\K(.*?)(?=")')
git clone --depth 1 --branch $picom_latest_release_tag https://github.com/yshui/picom
# build and install
cd picom
meson setup --buildtype=release build
sudo ninja -C build install
# cleanup
cd ..
rm -rf picom

# neovim
inform_configure "neovim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
add_to_bashrc 'PATH="$PATH:/opt/nvim-linux64/bin"'
rm nvim-linux64.tar.gz
sudo apt-get -qq -y install xclip # for clipboard
sudo apt-get -qq -y install ripgrep # for telescope

# tmux
inform_configure "tmux"
sudo apt-get -qq -y install tmux

# qmk
inform_configure "qmk"
sudo apt-get -qq -y install python3-pip
sudo python3 -m pip install qmk
add_to_bashrc 'PATH="$PATH:$HOME/.local/bin"'
. ~/.bashrc
inform_msg "cloning might take a while"
qmk setup -y zsa/qmk_firmware -b firmware23
############ uncomment below to install keymap app #############
# curl -L https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz --output keymap.tar.gz
# tar -xvzf keymap.tar.gz -C ~/Documents
# apt install libusb-1.0-0-dev
# cp zsa_rules /etc/udev/rules.d/50-zsa.rules
# groupadd plugdev
# usermod -aG plugdev $USER

####################################################### LANGUAGES
inform_configure "nodejs"
# nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 20

inform_configure "c++ standard dependencies"
sudo apt-get -qq -y libstdc++-12-dev # save myself the headache

####################################################### DOTFILES
inform_configure "dotfiles"
cd dotfiles
for dir in $(ls -d */); do
    dir=${dir%%/}
    stow -D $dir -t ~
    stow "$dir" -t ~
    inform_msg "stowed '$dir'"
done
cd ..

####################################################### SYSTEM UPDATE
inform_configure "system updates"
sudo apt-get -qq -y update
sudo apt-get -qq -y upgrade

echo "\e[1;32m==========================================================\e[0m"
echo "\e[1;32mSetup complete\e[0m"
echo "\e[1;32m==========================================================\e[0m"

inform_msg "run 'apt purge cinnamon --autoremove' to remove cinnamon (make sure i3 works first)"
