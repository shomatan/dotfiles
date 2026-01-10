#!/bin/bash
# Setup git hooks and aliases for dotfiles repository

DOTFILES_DIR="$HOME/.local/share/chezmoi"

if [ -d "$DOTFILES_DIR/.git" ]; then
  cd "$DOTFILES_DIR"

  # Setup hooks
  if [ -d ".hooks" ]; then
    git config core.hooksPath .hooks
    echo "Configured git hooks"
  fi

  # Setup alias for template files (sed -i syntax differs between macOS and Linux)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    git config alias.add-tmpl '!f() { chezmoi add --template "$1" && src=$(chezmoi source-path "$1") && sed -i "" "s|'"$HOME"'|{{ .chezmoi.homeDir }}|g" "$src" && git add "$src"; }; f'
  else
    git config alias.add-tmpl '!f() { chezmoi add --template "$1" && src=$(chezmoi source-path "$1") && sed -i "s|'"$HOME"'|{{ .chezmoi.homeDir }}|g" "$src" && git add "$src"; }; f'
  fi
  echo "Configured git alias: add-tmpl"
fi
