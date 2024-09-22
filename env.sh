# git
apt-get -qq -y install git-all

# i3
apt-get -qq -y install i3 playerctl # config requires playerctl
# install i3blocks
git clone https://github.com/vivien/i3blocks
cd i3blocks
./autogen.sh
./configure
make
make install
cd ..
rm -rf i3blocks

# picom
# install dependencies
apt-get -qq -y install libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev meson ninja-build uthash-dev
# clone latest release
picom_latest_release_tag=$(curl -s https://api.github.com/repos/yshui/picom/releases/latest | grep -oP '"tag_name": "\K(.*?)(?=")')
git clone --depth 1 --branch $picom_latest_release_tag https://github.com/yshui/picom
# build and install
cd picom
meson setup --buildtype=release build
ninja -C build
cd build/src
ninja -C build install
# cleanup
cd ../../../
rm -rf picom

# neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
rm nvim-linux64.tar.gz
apt-get -qq -y install xclip # for nvim clipboard

# tmux
apt-get -qq -y install tmux

# qmk
apt-get -qq -y install python3-pip
python3 -m pip install --user qmk
qmk setup -y zsa/qmk_firmware -b firmware23
############ uncomment below to install keymap app #############
# curl -L https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz --output keymap.tar.gz
# tar -xvzf keymap.tar.gz -C ~/Documents
# apt install libusb-1.0-0-dev
# cp zsa_rules /etc/udev/rules.d/50-zsa.rules
# groupadd plugdev
# usermod -aG plugdev $USER
