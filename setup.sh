source utils.sh

if [ $(id -u) -eq 0 ]; then
    error "Running script as root will install in root dir"
fi

if ! which sudo >/dev/null 2>&1; then
    error "sudo not found. ensure sudo is installed"
fi

if ! $(mokutil --sb-state | grep -q "SecureBoot disabled"); then
    error "SecureBoot must be disabled"
fi

TMP_INSTALL_DIR=$(mktemp)
note "created tmp dir $TMP_INSTALL_DIR"

inform "updating apt"
silent_exec "sudo apt-get -qq -y update"
silent_exec "sudo apt-get -qq -y upgrade"

inform "installing general dependencies"
apt_install cmake git-all stow autoconf build-essential curl jq

inform "adding aliases to bashrc"
bashrc_append '. .bash_aliases'

apt_install cmake git-all stow autoconf build-essential curl jq

# dotfiles
inform "stowing dotfiles"
mkdir -p $HOME/.dotfiles
note "copied dotfiles to '$HOME/.dotfiles'"
cp -r dotfiles/* $HOME/.dotfiles
cd $HOME/.dotfiles
for dir in $(ls -d */); do
    stow -R --no-folding "$dir" -t $HOME
    note "stowed $dir"
done
cd ~-

# tmux
inform "setting up tmux"
apt_install tmux

# sway
inform "setting up sway"
apt_install sway playerctl pulseaudio-utils brightnessctl

# fuzzel, waybar, sddm
inform "setting up WM addons"
note "installing fuzzel, waybar, sddm"
apt_install fuzzel waybar
apt_install_no_recommends sddm

# neovim
inform "setting up neovim"
apt_install xclip ripgrep
note "downloading v0.11.1"
silent_exec curl -L -o $TMP_INSTALL_DIR/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim /opt/nvim-linux-x86_64
note "unpacking nvim"
silent_exec sudo tar -C /opt -xzf $TMP_INSTALL_DIR/nvim.tar.gz
bashrc_append 'PATH="$PATH:/opt/nvim-linux-x86_64/bin"'

# qmk
if query "Do you want to setup qmk for the ZSA Moonlander Mark I?"; then
    inform "setting up qmk"
    apt_install python3-pip
    silent_exec sudo python3 -m pip install qmk
    bashrc_append 'PATH="$PATH:$HOME/.local/bin"'
    source $HOME/.bashrc
    note "running qmk setup (this might take a few minutes)"
    silent_exec qmk setup -y zsa/qmk_firmware -b firmware23
fi

# nodejs
if query "Do you want to install nodejs?"; then
    inform "setting up nodejs"
    note "installing nvm"
    silent_exec "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
    export NVM_DIR="$HOME/.nvm"
    note "installing nodejs v20"
    silent_exec "source $NVM_DIR/nvm.sh && nvm install 20"
fi

# c++
if query "Do you want to install c++ std lib?"; then
    inform "c++ standard dependencies"
    apt_install libstdc++-12-dev
fi

# wifi adapter driver
if query "Do you want install morrownr/8812au-20210820 driver (last tested on kernel v5.15.0-131-generic, Mint 21.3 Virginia)?"; then
    note "installing kernel headers"
    apt_install linux-headers-$(uname -r)
    git clone https://github.com/morrownr/8812au-20210820.git $TMP_INSTALL_DIR/morrow_driver
    cd $TMP_INSTALL_DIR/morrow_driver
    silent_exec "sudo ./install-driver.sh"
    cd ~-
fi

# git config
inform "setting up git config"
git config --global user.useConfigOnly true
git config --global url."git@github.com:".insteadOf "https://github.com/"
if query "Do you want set git global user?"; then
    echo -ne "${QUERY_COLOR}  user.name: ${RESET_COLOR}"
    read -r name
    git config --global user.name "$name"
    echo -ne "${QUERY_COLOR}  user.email: ${RESET_COLOR}"
    read -r email
    git config --global user.email "$email"
    git config --global url.ssh://git@github.com/.insteadOf https://github.com/
    note "$(git config --global --list)"
fi

inform "Setup complete"
note "you should reboot to make sure all configs and new packages are properly loaded"
note "don't forget to set git ssh key"
