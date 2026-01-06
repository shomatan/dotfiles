#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Thino Memo
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📝
# @raycast.argument1 { "type": "text", "placeholder": "メモ内容" }
# @raycast.packageName Obsidian

# Documentation:
# @raycast.description Obsidianのデイリーノートにメモを追加
# @raycast.author Your Name

[[ "$(uname)" != "Darwin" ]] && exit 0

if ! command -v thn &> /dev/null; then
  brew tap ignission/tap
  brew install thn
fi

thn "$1"
