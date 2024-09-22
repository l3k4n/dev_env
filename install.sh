inform () { echo "\033[0;35m$@\033[0m"; }

inform "setting up 'env'"
bash ./env.sh

inform "setting up 'langs'"
bash ./langs.sh

for dir in dotfiles/*; do
    stow -D $dir -t ~
    stow "$dir" -t ~
    inform "stowed '$dir'"
done
