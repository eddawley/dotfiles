#!/bin/bash

create_symlinks() {
    # Get the directory in which this script lives.
    script_dir=$(dirname "$(readlink -f "$0")")

    # Get a list of all files in this directory that start with a dot.
    files=$(find -maxdepth 1 -type f -name ".*")

    # Create a symbolic link to each file in the home directory.
    for file in $files; do
        name=$(basename $file)
        echo "Creating symlink to $name in home directory."
        rm -rf ~/$name
        ln -s $script_dir/$name ~/$name
    done
}


zshrc() {
    echo "==========================================================="
    echo "             enable backports for git                      "
    echo "-----------------------------------------------------------"
    echo deb http://deb.debian.org/debian buster-backports main | tee /etc/apt/sources.list.d/buster-backports.list 
    echo "==========================================================="
    echo "             update apt                                    "
    echo "-----------------------------------------------------------"
    apt update
    echo "==========================================================="
    echo "             upgrade git                                   "
    echo "-----------------------------------------------------------"
    apt install -t buster-backports -y git
    echo "==========================================================="
    echo "             install zsh                                   "
    echo "-----------------------------------------------------------"
    rm /etc/zsh/zlogin
    apt install -y zsh
    echo "==========================================================="
    echo "             install ohmyzsh                               "
    echo "-----------------------------------------------------------"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "==========================================================="
    echo "             cloning powerlevel10k                         "
    echo "-----------------------------------------------------------"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo "==========================================================="
    echo "             import configs                                "
    echo "-----------------------------------------------------------"
    create_symlinks 
}

zshrc
