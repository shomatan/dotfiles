#!/bin/bash

git clone https://github.com/shomatan/dotfiles.git ~/dotfiles

INVENTORY_NAME="default"

if [ "$(uname)" == 'Darwin' ]; then
    # create vscode dir
    mkdir -p ~/Library/Application\ Support/Code/User

    xcode-select --install
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew install ansible
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    OS=`cat /etc/os-release | grep -E '^ID=' | awk -F'=' '{print $2}' | sed 's/"//g'`
    
    if [ "$OS" = "ubuntu" ]; then
        sudo apt -y update
        sudo apt -y install ansible
    elif [ "$OS" = "centos" ]; then
        VERSION=`cat /etc/os-release | grep -E '^VERSION_ID=' | awk -F'=' '{print $2}' | sed 's/"//g'`
        if [ "$VERSION" = "7" ]; then
            INVENTORY_NAME="centos7"
        fi

        sudo yum -y update
        sudo yum -y install epel-release
        sudo yum -y install ansible
    fi
fi

ansible-playbook -i ~/dotfiles/ansible/inventory/"$INVENTORY_NAME" ~/dotfiles/ansible/site.yml