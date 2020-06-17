
# options
# -----------------------------------------------------------------------------
setopt print_eight_bit
setopt no_beep
setopt no_flow_control
setopt ignore_eof
setopt interactive_comments
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_glob


# promt
# -----------------------------------------------------------------------------
autoload -Uz colors
colors

PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "


# aliases
# -----------------------------------------------------------------------------
alias la='ls -la'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

alias sudo='sudo '

# global
alias -g L='| less'
alias -g G='| grep'
alias docker-login='(){ docker exec -it $1 sh -lc "su - $2" }'

alias vi='/usr/local/bin/nvim'
alias vim='/usr/bin/vi'

# git
alias gis='git status'
alias gic='git commit'
alias gif='git fetch'
alias gil='git pull'
alias gip='git push'
alias girh='git reset --hard'
alias gib='git branch'
alias gic='git checkout'

# key bind
# -----------------------------------------------------------------------------
bindkey '^R' history-incremental-pattern-search-backward

# zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


# vcs_info
# -----------------------------------------------------------------------------
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


# asdf
# -----------------------------------------------------------------------------
. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

# java
asdf where java > /dev/null 2>&1
if [ $? = 0 ]; then
    . ~/.asdf/plugins/java/set-java-home.zsh
fi


# complement
# -----------------------------------------------------------------------------
autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# word style
# -------------------------------------------------------------------------------------------------
autoload -Uz select-word-style
select-word-style default

zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified


# zplug
# -----------------------------------------------------------------------------
if [[ -f $ZPLUG_HOME/init.zsh ]]; then
    export ZPLUG_LOADFILE="$ZDOTDIR/zplug.zsh"
    source $ZPLUG_HOME/init.zsh

    if ! zplug check --verbose; then
        zplug install
    fi
    zplug load
fi


# zsh
# -----------------------------------------------------------------------------
typeset -gU cdpath fpath mailpath path

path=(
  /usr/local/{bin,sbin}
  $ZPLUG_HOME/bin
  $path
)

# sbt publish
export GPG_TTY=$(tty)
