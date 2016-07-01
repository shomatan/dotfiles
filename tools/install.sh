#!/bin/bash

rm -rf ~/dotfiles
rm -f ~/.vimrc
rm -f ~/.zshrc
rm -rf ~/.vim

git clone https://github.com/shomatan/dotfiles.git ~/dotfiles

mkdir -p ${XDG_CONFIG_HOME:=~/.config}/nvim
ln -s ~/dotfiles/.vimrc   $XDG_CONFIG_HOME/nvim/init.vim
ln -s ~/dotfiles/vimfiles $XDG_CONFIG_HOME/nvim/
ln -Fis ~/dotfiles/.zshrc ~/.zshrc

#git clone https://github.com/yyuu/pyenv.git ~/.pyenv

source ~/.zshrc

#pyenv install 3.5.1
#pyenv global 3.5.1
#pyenv rehash
#pip3 install neovim

# Install plugins
vi +:q >/dev/null 2>&1
