
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