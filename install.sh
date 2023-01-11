#!/bin/bash

set -x

if [ "$(uname)" == 'Darwin' ]; then
	which brew > /dev/null 2>&1
	if [ $? -eq 1 ]; then
    sudo xcode-select --install
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    softwareupdate --install-rosetta --agree-to-license
	else
		brew update
	fi
  export PATH=$PATH:/opt/homebrew/bin
	brew install asdf
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf
fi

. $HOME/.asdf/asdf.sh
asdf where java > /dev/null 2>&1
if [ $? = 0 ]; then
    . ~/.asdf/plugins/java/set-java-home.zsh
fi

asdf plugin add java
asdf reshim
asdf plugin add sbt
asdf reshim

if [ ! -d ~/dotfiles ]; then
  git clone https://github.com/shomatan/dotfiles.git ~/dotfiles
  cd dotfiles
else
  cd dotfiles
  git pull
fi

asdf install
sbt run
