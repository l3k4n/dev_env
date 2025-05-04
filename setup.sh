source utils.sh

if [ $(id -u) -eq 0 ]; then
    error "Running script as root will install in root dir"
fi

if ! which sudo >/dev/null 2>&1; then
    error "sudo not found. make sure sudo is installed"
fi

inform "updating apt"
silent_exec "sudo apt-get -qq -y update"
silent_exec "sudo apt-get -qq -y upgrade"

inform "installing general dependencies"
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
cd -

# tmux
inform "setting up tmux"
apt_install tmux

# tmux
inform "setting up sway"
apt_install sway

# neovim
inform "setting up neovim"
apt_install xclip ripgrep
note "downloading v0.11.1"
silent_exec curl -LO https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.tar.gz
rm -rf /opt/nvim
note "unpacking nvim"
silent_exec sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
bashrc_append 'PATH="$PATH:/opt/nvim-linux-x86_64/bin"'
rm nvim-linux-x86_64.tar.gz

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
    git clone https://github.com/morrownr/8812au-20210820.git
    cd 8812au-20210820
    silent_exec "sudo ./install-driver.sh"
    cd ..
    rm -rf 8812au-20210820
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
    git config --global url.ssh://git@github.com/.insteadOf https://github.com/
    note "$(git config --global --list)"
fi

inform "Setup complete"
note "you should reboot to make sure all configs and new packages are properly loaded"
note "don't forget to set git ssh key"
