
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


# key bind
# -----------------------------------------------------------------------------
bindkey '^R' history-incremental-pattern-search-backward


# zplug
# -----------------------------------------------------------------------------
if [[ -f $ZPLUG_HOME/init.zsh ]]; then
    export ZPLUG_LOADFILE="$ZDOTDIR/zplug.zsh"
    source $ZPLUG_HOME/init.zsh

    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
        echo
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