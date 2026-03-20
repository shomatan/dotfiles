#!/bin/bash
# sync-plugins.sh
# 実際のClaude Codeプラグイン設定ファイルからchezmoiのmodify_スクリプトを再生成する
set -euo pipefail

CHEZMOI_SRC="${CHEZMOI_SOURCE_DIR:-$(chezmoi source-path)}"
PLUGINS_JSON="$HOME/.claude/plugins/installed_plugins.json"
MARKETPLACES_JSON="$HOME/.claude/plugins/known_marketplaces.json"

# jqの存在チェック
command -v jq >/dev/null 2>&1 || { echo "エラー: jqが必要です"; exit 1; }

# --- installed_plugins.json のmodify_スクリプト生成 ---
generate_installed_plugins_script() {
  if [ ! -f "$PLUGINS_JSON" ]; then
    echo "警告: $PLUGINS_JSON が見つかりません。スキップします。" >&2
    return 1
  fi

  # プラグインキーを抽出してJSON配列の中身にフォーマット
  local plugin_keys
  plugin_keys=$(jq -r '.plugins | keys | map("  \"" + . + "\"") | join(",\n")' "$PLUGINS_JSON")

  cat <<'SCRIPT_HEAD'
#!/bin/bash
# chezmoi modify_スクリプト: installed_plugins.jsonの管理
# プラグインの「どれをインストールするか」だけ管理し、
# version, lastUpdated, gitCommitSha, installPath等の動的フィールドは各マシンの値を保持する
set -euo pipefail

HOME_DIR="{{ .chezmoi.homeDir }}"

# stdinから現在のファイル内容を読み取る
CURRENT=$(cat)

# ファイルが空や不正な場合はベースJSONを使用
if [ -z "$CURRENT" ] || ! echo "$CURRENT" | jq empty 2>/dev/null; then
  CURRENT='{"version": 2, "plugins": {}}'
fi

# 管理対象プラグイン一覧（sync-plugins.shで自動更新される）
PLUGINS='[
SCRIPT_HEAD

  echo "$plugin_keys"

  cat <<'SCRIPT_TAIL'
]'

RESULT=$(echo "$CURRENT" | jq --arg home "$HOME_DIR" --argjson plugins "$PLUGINS" '
  .version = 2 |
  reduce ($plugins[]) as $key (.;
    ($key | split("@")) as $parts |
    $parts[0] as $name |
    $parts[1] as $marketplace |
    if .plugins[$key] then
      .
    else
      .plugins[$key] = [{
        "scope": "user",
        "installPath": ($home + "/.claude/plugins/cache/" + $marketplace + "/" + $name + "/unknown"),
        "version": "unknown",
        "installedAt": "1970-01-01T00:00:00.000Z",
        "lastUpdated": "1970-01-01T00:00:00.000Z"
      }]
    end
  )
')

# 末尾改行なしで出力
printf '%s' "$RESULT"
SCRIPT_TAIL
}

# --- known_marketplaces.json のmodify_スクリプト生成 ---
generate_known_marketplaces_script() {
  if [ ! -f "$MARKETPLACES_JSON" ]; then
    echo "警告: $MARKETPLACES_JSON が見つかりません。スキップします。" >&2
    return 1
  fi

  # マーケットプレイス情報をJSON形式で抽出（各エントリのsourceオブジェクトを取得）
  local marketplace_entries
  marketplace_entries=$(jq -r '
    to_entries |
    map("  \"" + .key + "\": " + (.value.source | tojson)) |
    join(",\n")
  ' "$MARKETPLACES_JSON")

  cat <<'SCRIPT_HEAD'
#!/bin/bash
# chezmoiのmodify_スクリプト: known_marketplaces.jsonのマーケットプレイスエントリを管理する
# source と installLocation は定義済みの値で設定し、lastUpdated は既存値を保持する

set -euo pipefail

HOME_DIR="{{ .chezmoi.homeDir }}"

# stdinから現在のファイル内容を読み取る（空の場合は空のJSONオブジェクト）
CURRENT="$(cat)"
if [ -z "$CURRENT" ] || [ "$CURRENT" = "{}" ]; then
  CURRENT='{}'
fi

# 管理対象マーケットプレイス（sync-plugins.shで自動更新される）
MARKETPLACES='{
SCRIPT_HEAD

  echo "$marketplace_entries"

  cat <<'SCRIPT_TAIL'
}'

RESULT="$(echo "$CURRENT" | jq \
  --arg home "$HOME_DIR" \
  --argjson marketplaces "$MARKETPLACES" \
  '
  reduce ($marketplaces | to_entries[]) as $entry (.;
    .[$entry.key].source = $entry.value |
    .[$entry.key].installLocation = ($home + "/.claude/plugins/marketplaces/" + $entry.key) |
    .[$entry.key].lastUpdated //= "1970-01-01T00:00:00.000Z"
  )
  ')"

# 末尾改行を除去（Claude Codeが生成するJSONには末尾改行がない）
printf '%s' "$RESULT"
SCRIPT_TAIL
}

# --- メイン処理 ---
INSTALLED_PLUGINS_TMPL="$CHEZMOI_SRC/dot_claude/plugins/modify_private_installed_plugins.json.tmpl"
KNOWN_MARKETPLACES_TMPL="$CHEZMOI_SRC/dot_claude/plugins/modify_private_known_marketplaces.json.tmpl"

CHANGED=0

# installed_plugins のmodify_スクリプト生成
if generate_installed_plugins_script > "${INSTALLED_PLUGINS_TMPL}.tmp"; then
  if ! diff -q "$INSTALLED_PLUGINS_TMPL" "${INSTALLED_PLUGINS_TMPL}.tmp" >/dev/null 2>&1; then
    mv "${INSTALLED_PLUGINS_TMPL}.tmp" "$INSTALLED_PLUGINS_TMPL"
    echo "更新: $INSTALLED_PLUGINS_TMPL"
    CHANGED=1
  else
    rm "${INSTALLED_PLUGINS_TMPL}.tmp"
    echo "変更なし: installed_plugins.json.tmpl"
  fi
fi

# known_marketplaces のmodify_スクリプト生成
if generate_known_marketplaces_script > "${KNOWN_MARKETPLACES_TMPL}.tmp"; then
  if ! diff -q "$KNOWN_MARKETPLACES_TMPL" "${KNOWN_MARKETPLACES_TMPL}.tmp" >/dev/null 2>&1; then
    mv "${KNOWN_MARKETPLACES_TMPL}.tmp" "$KNOWN_MARKETPLACES_TMPL"
    echo "更新: $KNOWN_MARKETPLACES_TMPL"
    CHANGED=1
  else
    rm "${KNOWN_MARKETPLACES_TMPL}.tmp"
    echo "変更なし: known_marketplaces.json.tmpl"
  fi
fi

echo ""
echo "同期完了"

# 変更があった場合はdiffを表示
if [ "$CHANGED" -eq 1 ]; then
  echo ""
  echo "--- chezmoi diff ---"
  chezmoi diff -- ~/.claude/plugins/installed_plugins.json ~/.claude/plugins/known_marketplaces.json || true
fi
