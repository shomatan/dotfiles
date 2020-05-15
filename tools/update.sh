#!/bin/bash

if [ "$(uname)" == 'Darwin' ]; then
    OS='mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    OS='linux'
fi

cd ~/dotfiles
git pull

if [ "$OS" = "mac" ]; then
    ansible-playbook -i ~/dotfiles/ansible/hosts ~/dotfiles/ansible/playbook.mac.yml --ask-become-pass
elif [ "$OS" = "linux" ]; then
    if [ `which apt` ]; then
        sudo apt update
        ansible-playbook -i ~/dotfiles/ansible/hosts ~/dotfiles/ansible/playbook.ubuntu.yml --ask-become-pass
    fi
fi