source utils.sh

if [ $(id -u) -ne 0 ]; then
	error "Script needs root permision"
	exit
fi

inform "updating apt"
silent_exec "sudo apt-get -qq -y update"
silent_exec "sudo apt-get -qq -y upgrade"

inform "installing general dependencies"
apt_install cmake git-all stow autoconf

# dotfiles
inform "stowing dotfiles"
cd dotfiles
for dir in $(ls -d */); do
    dir=${dir%%/}
    stow -D $dir -t ~
    stow "$dir" -t ~
    note "stowed '$dir' dotfiles"
done
cd ..

if query "Do you want install gnab driver (last tested on kernel v5.15, mint 21.3 virginia)?"; then
    git_clone https://github.com/gnab/rtl8812au.git
    cd rtl8812au
    silent_exec make
    silent_exec sudo insmod 8812au.ko
    cd ..
    rm -rf rtl8812au
fi

# git config
if query "Do you want set basic git global config opts?"; then
    inform "setting git global config"
    echo -ne "${QUERY_COLOR}  user.name: ${RESET_COLOR}"
    read -r name
    git config --global user.name "$name"
    echo -ne "${QUERY_COLOR}  user.email: ${RESET_COLOR}"
    read -r email
    git config --global user.email "$email"
    note $(git config --global --list)
fi

# i3
inform "setting up i3"
apt_install i3 playerctl
note "setting up i3blocks"
git_clone https://github.com/vivien/i3blocks
cd i3blocks
silent_exec ./autogen.sh
silent_exec ./configure
silent_exec make
note "installing i3 blocks"
silent_exec sudo make install
cd ..
rm -rf i3blocks

# picom
inform "setting up picom"
apt_install libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev meson ninja-build uthash-dev libxext-dev libxcb-dpms0-dev
picom_latest_release_tag=$(curl -s https://api.github.com/repos/yshui/picom/releases/latest | grep -oP '"tag_name": "\K(.*?)(?=")')
note "latest picom release $picom_latest_release_tag"
git_clone --depth 1 --branch $picom_latest_release_tag https://github.com/yshui/picom
cd picom
silent_exec meson setup --buildtype=release build
silent_exec sudo ninja -C build install
cd ..
rm -rf picom

#feh
inform "setting up feh"
apt_install feh

# tmux
inform "setting up tmux"
apt_install tmux

# neovim
inform "setting up neovim"
apt_install xclip ripgrep
note "downloading latest nvim release"
silent_exec curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm -rf /opt/nvim
note "unpacking nvim"
silent_exec sudo tar -C /opt -xzf nvim-linux64.tar.gz
bashrc_append 'PATH="$PATH:/opt/nvim-linux64/bin"'
rm nvim-linux64.tar.gz

# qmk
if query "Do you want to setup qmk for the ZSA Moonlander Mark I?"; then
    inform "setting up qmk"
    apt_install python3-pip
    silent_exec sudo python3 -m pip install qmk
    bashrc_append 'PATH="$PATH:$HOME/.local/bin"'
    source ~/.bashrc
    note "running qmk setup (this might take a few minutes)"
    silent_exec qmk setup -y zsa/qmk_firmware -b firmware23
fi

# terminal
if query "Do you want to setup gnome terminal preferences?"; then
    inform "setting up gnome terminal preferences"
    cat gterminal.preferences | dconf load /org/gnome/terminal/
fi

# nodejs
if query "Do you want to install nodejs?"; then
    inform "setting up nodejs"
    note "installing nvm"
    silent_exec curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    note "installing nodejs v20"
    silent_exec "source $NVM_DIR/nvm.sh && nvm install 20"
fi

# c++
if query "Do you want to install c++ std lib?"; then
    inform "c++ standard dependencies"
    sudo apt-get -qq -y libstdc++-12-dev
fi

inform "Setup complete"
note "you should reboot to make sure all configs and new packages are properly loaded"
note "if i3wm is installed you should delete your current WM"
