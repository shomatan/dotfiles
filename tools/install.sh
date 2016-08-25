#!/bin/bash

rm -rf ~/dotfiles
rm -f ~/.vimrc
rm -f ~/.zshrc
rm -rf ~/.vim

git clone https://github.com/shomatan/dotfiles.git ~/dotfiles
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

mkdir -p ${XDG_CONFIG_HOME:=~/.config}/nvim
ln -s ~/dotfiles/.vimrc   $XDG_CONFIG_HOME/nvim/init.vim
ln -s ~/dotfiles/vimfiles $XDG_CONFIG_HOME/nvim/
ln -Fis ~/dotfiles/.zshrc ~/.zshrc

# screen
rm -f ~/.screenrc
ln -s ~/dotfiles/screenrc ~/.screenrc

# Install plugins
nvim +":UpdateRemotePlugins" +:q >/dev/null 2>&1
nvim +":UpdateRemotePlugins" +:q >/dev/null
