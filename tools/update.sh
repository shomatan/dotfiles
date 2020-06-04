#!/bin/bash

if [ "$(uname)" == 'Darwin' ]; then
    OS='mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    OS='linux'
fi

cd ~/dotfiles
git pull

if [ "${CI}" ]; then
    PARAM=""
else
    PARAM="--ask-become-pass"
fi

if [ "$OS" = "mac" ]; then
    ansible-playbook -i ~/dotfiles/ansible/hosts ~/dotfiles/ansible/playbook.mac.yml "${PARAM}"
elif [ "$OS" = "linux" ]; then
    if [ `which apt` ]; then
        sudo apt update
        ansible-playbook -i ~/dotfiles/ansible/hosts ~/dotfiles/ansible/playbook.ubuntu.yml "${PARAM}"
    fi
fi