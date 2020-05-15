export ZSH=$HOME/.oh-my-zsh
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR=vim
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/opt/vagrant/bin

alias vi="nvim"
ZSH_THEME="wedisagree"
plugins=(git)

source $ZSH/oh-my-zsh.sh

ulimit -n 4096

# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/
########################################
# 言語設定
case $TERM in

linux) LANG=C ;;

*) LANG=ja_JP.UTF-8 ;;

esac

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# エイリアス

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi



########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
    if [ -e /Volumes/Work/Vagrant ]; then
        export VAGRANT_HOME=/Volumes/Work/Vagrant
    fi
    ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac

# vim:set ft=zsh:
export PATH="/usr/local/bin:$PATH"

. /usr/local/opt/asdf/asdf.sh

. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash
export PATH="/usr/local/sbin:$PATH"
export PATH=~/.local/bin:$PATH

# sbt publish
export GPG_TTY=$(tty)