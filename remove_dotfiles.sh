cd dotfiles
for dir in $(ls -d */); do
    dir=${dir%%/}
    stow -D $dir -t ~
    echo "removed '$dir'"
done
cd ..
