source utils.sh

# nodejs
if query "Do you want to install nodejs?"; then
    local PROFILE="" # prevent the script from writing to bashrc
    local XDG_CONFIG_HOME="$HOME/.config" # ensure .nvm files are placed correctly

    inform "setting up nodejs"
    note "installing nvm"
    curl -sS -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    note "installing nodejs v20"
    source $NVM_DIR/nvm.sh
    nvm install 20

    custom_export "export NVM_DIR=\"\$([ -z \"\${XDG_CONFIG_HOME-}\" ] && printf %s \"\${HOME}/.nvm\" || printf %s "\${XDG_CONFIG_HOME}/nvm")\"
        [ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\""
fi

# c++
if query "Do you want to install c++ std lib?"; then
    inform "c++ standard dependencies"
    apt_install libstdc++-12-dev
fi

# go
if query "Do you want to install golang?"; then
    curl -sS -L -o $TMP_INSTALL_DIR/go.tar.gz "https://dl.google.com/go/go1.25.0.linux-amd64.tar.gz"
    sudo rm -rf /opt/go
    sudo tar -C /opt -xzf $TMP_INSTALL_DIR/go.tar.gz
    custom_export 'PATH="$PATH:/opt/go/bin"'
fi
