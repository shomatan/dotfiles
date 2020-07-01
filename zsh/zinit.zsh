zinit wait lucid for \
    softmoth/zsh-vim-mode \
    zsh-users/zsh-history-substring-search \
    zdharma/history-search-multi-word \
    mollifier/anyframe \
    OMZ::plugins/kubectl \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions