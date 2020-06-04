#!/bin/bash

if [ "$(uname)" == 'Darwin' ]; then
    OS='mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    OS='linux'
fi

git clone https://github.com/shomatan/dotfiles.git ~/dotfiles

if [ "$OS" = "mac" ]; then
    # create vscode dir
    mkdir -p ~/Library/Application\ Support/Code/User

    xcode-select --install
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew install ansible
    ansible-playbook -i ~/dotfiles/ansible/hosts ~/dotfiles/ansible/playbook.mac.yml
elif [ "$OS" = "linux" ]; then
    if [ `which apt` ]; then
        sudo apt -y update
        sudo apt -y install ansible
        ansible-playbook -i ~/dotfiles/ansible/hosts ~/dotfiles/ansible/playbook.ubuntu.yml
    fi
fi