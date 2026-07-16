#!/usr/bin/env bash
#
# gist 由来の Claude スキルを upstream から再取得し、差分があれば
# chezmoi ソースと実体（~/.claude）へ反映してローカルコミットする。
# chezmoi update の post フック（hooks.update.post）から呼ばれる。
# 単体実行も可。--dry-run で取得と差分表示のみ（書き込み・コミット・push なし）。
#
# 差分があれば source と ~/.claude へ反映し commit、origin（公開リポジトリ）へ push する。
#
set -euo pipefail

DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

# フック実行時は chezmoi が CHEZMOI_SOURCE_DIR を渡す。単体実行時のみ問い合わせる
# （フック内で chezmoi を再呼び出しすると state ロックに触れるため避ける）。
SRC="${CHEZMOI_SOURCE_DIR:-$(chezmoi source-path)}"

# 管理対象: "<gist raw URL>|<スキル名>"
# スキルを増やす場合はこの配列に 1 行足すだけでよい。
SKILLS=(
  "https://gist.githubusercontent.com/k16shikano/eb2929f13ed19c97188393d297be8432/raw|cognitive-rhythm-writing"
  "https://gist.githubusercontent.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d/raw|japanese-tech-writing"
)

changed=()
for entry in "${SKILLS[@]}"; do
  url="${entry%%|*}"
  name="${entry##*|}"
  rel="dot_claude/skills/${name}/SKILL.md"
  src="${SRC}/${rel}"
  dst="${HOME}/.claude/skills/${name}/SKILL.md"

  tmp="$(mktemp)"
  # 取得失敗（404/5xx・ネットワーク断）は破棄してスキップ（誤コミット防止）
  if ! curl -fsSL "$url" -o "$tmp"; then
    echo "skip（取得失敗）: ${name}" >&2
    rm -f "$tmp"
    continue
  fi
  # 空・frontmatter 無し（エラーページ等）は破棄してスキップ
  if [ ! -s "$tmp" ] || [ "$(head -n1 "$tmp")" != "---" ]; then
    echo "skip（内容が不正）: ${name}" >&2
    rm -f "$tmp"
    continue
  fi

  # 既存ソースと同一なら何もしない
  if [ -f "$src" ] && cmp -s "$tmp" "$src"; then
    rm -f "$tmp"
    continue
  fi

  changed+=("$rel")
  if [ "$DRY_RUN" = 1 ]; then
    echo "diff（要更新）: ${name}" >&2
    rm -f "$tmp"
    continue
  fi

  # ソースと実体（~/.claude）の両方へ反映
  mkdir -p "$(dirname "$src")" "$(dirname "$dst")"
  cp "$tmp" "$src"
  cp "$tmp" "$dst"
  chmod 0644 "$src" "$dst"
  rm -f "$tmp"
  echo "更新: ${name}" >&2
done

if [ "${#changed[@]}" -eq 0 ]; then
  echo "差分なし" >&2
  exit 0
fi

if [ "$DRY_RUN" = 1 ]; then
  echo "[dry-run] ${#changed[@]} 件に差分あり（コミット・push は行わない）" >&2
  exit 0
fi

git -C "$SRC" add -- "${changed[@]}"
# 取得結果が HEAD と一致（作業コピーのみ汚れていた等）なら commit しない
if git -C "$SRC" diff --cached --quiet -- "${changed[@]}"; then
  echo "コミット対象なし（内容は HEAD と一致）" >&2
  exit 0
fi
git -C "$SRC" commit -q -m "chore(claude): gist 由来スキルを upstream に同期"
echo "コミット: ${#changed[@]} 件" >&2

# 公開リポジトリへ push（失敗は非致命。commit はローカルに残り次回持ち越す）
if git -C "$SRC" push --quiet; then
  echo "push: 完了" >&2
else
  echo "push: 失敗（後で手動 push してください）" >&2
fi
