# Environment
if [[ -z "$XDG_CONFIG_HOME" ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -z "$XDG_CACHE_HOME" ]]; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi

if [[ -z "$XDG_DATA_HOME" ]]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi

# Language
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

# Editor
export EDITOR=nvim
export GIT_EDITOR="${EDITOR}"

# history
export HISTFILE="$ZDOTDIR/history"
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt hist_ignore_dups

# sbt publish
export GPG_TTY=$(tty)

# zplug
export ZPLUG_HOME=~/.local/share/zplug

# snap
if [[ -f "/etc/profile.d/apps-bin-path.sh" ]]; then
    source /etc/profile.d/apps-bin-path.sh
fi
