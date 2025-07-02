#!/bin/bash
# ~/.claude/claude-completion-notify.sh

# 入力データから情報を取得
SESSION_ID=$(jq -r '.session_id')
STOP_HOOK_ACTIVE=$(jq -r '.stop_hook_active')

# 無限ループを防ぐ
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
    exit 0
fi

# プロジェクト名を取得
PROJECT_NAME=$(basename "$PWD")

# 詳細な通知を送信
terminal-notifier \
    -title "Claude Code 🤖" \
    -subtitle "プロジェクト: $PROJECT_NAME" \
    -message "処理が完了しました (Session: ${SESSION_ID:0:8})" \
    -sound "Blow" \
    -group "claude-code-completion"