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

note "created tmp dir $TMP_INSTALL_DIR"

inform "updating apt"
sudo apt-get -qq -y update
sudo apt-get -qq -y upgrade

inform "installing general dependencies"
apt_install cmake git-all stow autoconf build-essential curl jq wget zip unzip

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
note "installing xwayland, fuzzel, waybar, sddm"
apt_install fuzzel waybar xwayland
apt_install_no_recommends sddm

#clipboard
inform "setting up clipboard"
apt_install wl-clipboard

# patched jetbrains mono nerd font
inform "installing JetBrains Mono font"
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip -O $TMP_INSTALL_DIR/jetbrainsmono.zip
sudo unzip -o -qq $TMP_INSTALL_DIR/jetbrainsmono.zip -d /usr/local/share/fonts/JetBrainsMono_NerdFonts
fc-cache -f -r -v > /dev/null

# neovim
inform "setting up neovim"
apt_install ripgrep
note "downloading v0.11.1"
curl -sS -L -o $TMP_INSTALL_DIR/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim /opt/nvim-linux-x86_64
note "unpacking nvim"
sudo tar -C /opt -xzf $TMP_INSTALL_DIR/nvim.tar.gz
bashrc_append 'PATH="$PATH:/opt/nvim-linux-x86_64/bin"'

# spotify
if query "Do you want to install spotify?"; then
    inform "installing spotify"
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get -qq -y update
    apt_install xwayland spotify-client # note: I only got spotify to launch when I had xwayland
    sudo cp /usr/share/spotify/spotify.desktop $HOME/.local/share/applications
fi

# qmk
if query "Do you want to setup qmk for the ZSA Moonlander Mark I?"; then
    inform "setting up qmk"
    apt_install python3-pip pipx
    sudo pipx install qmk
    bashrc_append 'PATH="$PATH:$HOME/.local/bin"'
    source $HOME/.bashrc
    note "running qmk setup (this might take a few minutes)"
    qmk setup -y zsa/qmk_firmware -b firmware23
fi

# firefox
if query "Do you want to install/replace with a version from the mozilla repository"; then
    note "adding mozilla repo to apt sources"
    sudo install -d -m 0755 /etc/apt/keyrings
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
    echo -e "Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000" | sudo tee /etc/apt/preferences.d/mozilla > /dev/null

    note "uninstalling firefox-esr"
    sudo apt-get autoremove -qq --purge firefox-esr

    sudo apt-get -qq -y update
    apt_install firefox
fi

# programming languages
if query "Do you want to setup frequently used languages and tools?"; then
    bash ./setup-lang-tools.sh
fi

# wifi adapter driver
if query "Do you want install morrownr/8812au-20210820 driver (last tested on kernel v5.15.0-131-generic, Mint 21.3 Virginia)?"; then
    note "installing kernel headers"
    apt_install linux-headers-$(uname -r)
    git_clone https://github.com/morrownr/8812au-20210820.git $TMP_INSTALL_DIR/morrow_driver
    cd $TMP_INSTALL_DIR/morrow_driver
    note "installing morrownr/8812au-20210820 driver"
    sudo ./install-driver.sh
    cd ~-
fi

# git config
rm -f $HOME/.gitconfig
git config --global user.useConfigOnly true
git config --global --add url."git@github.com:".pushInsteadOf "https://github.com/"
git config --global --add url."git@github.com:".pushInsteadOf "http://github.com/"
git config --global --add url."git@github.com:".pushInsteadOf "git://github.com/"
if query "Do you want set git global user?"; then
    inform "setting up git config"
    echo -ne "${QUERY_COLOR}  user.name: ${RESET_COLOR}"
    read -r name
    echo -ne "${QUERY_COLOR}  user.email: ${RESET_COLOR}"
    read -r email
    git config --global user.name "$name"
    git config --global user.email "$email"
    note "$(git config --global --list)"
fi

inform "Setup complete"
note "you should reboot to make sure all configs and new packages are properly loaded"
note "don't forget to copy your ssh key to github"
