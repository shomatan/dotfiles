#!/bin/bash
# Setup git hooks for dotfiles repository

DOTFILES_DIR="$HOME/.local/share/chezmoi"

if [ -d "$DOTFILES_DIR/.git" ] && [ -d "$DOTFILES_DIR/.hooks" ]; then
  cd "$DOTFILES_DIR"
  git config core.hooksPath .hooks
  echo "Configured git hooks for dotfiles repository"
fi
