#!/bin/bash

if [ "$(uname)" == 'Darwin' ]; then
    OS='mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    OS='linux'
fi

cd ~/dotfiles
git pull

if [ "$OS" = "mac" ]; then
elif [ "$OS" = "linux" ]; then
    if [ `which apt` ]; then
        sudo apt update
    fi
fi

ansible-playbook -i ~/dotfiles/ansible/hosts ~/dotfiles/ansible/site.yml