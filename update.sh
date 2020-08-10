#!/bin/bash

cd ~/dotfiles
git pull

INVENTORY_NAME="default"
ARGS=""

if [ "$(uname)" == 'Darwin' ]; then
    ARGS="--ask-become-pass"
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    OS=`cat /etc/os-release | grep -E '^ID=' | awk -F'=' '{print $2}' | sed 's/"//g'`
    
    if [ "$OS" = "ubuntu" ]; then
        sudo apt -y update
    elif [ "$OS" = "centos" ]; then
        VERSION=`cat /etc/os-release | grep -E '^VERSION_ID=' | awk -F'=' '{print $2}' | sed 's/"//g'`
        if [ "$VERSION" = "7" ]; then
            INVENTORY_NAME="centos7"
        fi
        sudo yum -y update
    fi
fi

ansible-playbook -i ~/dotfiles/ansible/inventory/"$INVENTORY_NAME" ~/dotfiles/ansible/site.yml $ARGS