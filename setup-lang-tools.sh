source utils.sh

# nodejs
if query "Do you want to install nodejs?"; then
    inform "setting up nodejs"
    note "installing nvm"
    curl -sS -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    note "installing nodejs v20"
    source $NVM_DIR/nvm.sh
    nvm install 20
fi

# c++
if query "Do you want to install c++ std lib?"; then
    inform "c++ standard dependencies"
    apt_install libstdc++-12-dev
fi

