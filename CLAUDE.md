# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## リポジトリ概要

これは [chezmoi](https://www.chezmoi.io/) で管理されているdotfilesリポジトリです。chezmoiは、複数のマシン間で個人設定ファイルを安全に管理するためのdotfileマネージャーです。

## よく使うコマンド

### 変更を適用
```bash
chezmoi apply -v
```

### リモートから更新
```bash
cd ~/.local/share/chezmoi && git pull && chezmoi apply -v
```

### 管理されているファイルを編集
```bash
chezmoi edit <file>
```

### 新しいファイルを管理対象に追加
```bash
chezmoi add <file>
```

### 適用される変更を確認
```bash
chezmoi diff
```

## アーキテクチャ

### Chezmoiの構造
- `dot_` プレフィックスのファイルはdotfileになります（例：`dot_zshrc` → `~/.zshrc`）
- `private_` プレフィックスのファイルはプライベート扱い（パーミッション 0600）
- `.tmpl` サフィックスのファイルはchezmoiが処理するGoテンプレート
- `executable_` プレフィックスでファイルを実行可能にする

### 主要コンポーネント

1. **シェル設定**
   - `dot_zshrc`: 環境設定、エイリアス、プラグイン管理を含むメインのzsh設定
   - `dot_p10k.zsh`: Powerlevel10kテーマ設定

2. **エディタ設定**
   - `dot_config/nvim/`: LazyVimベースのNeovim設定（`init.lua`）
   - `dot_ideavimrc`: JetBrains IDE用のIdeaVim設定
   - `private_Library/private_Application Support/private_Cursor/User/`: Cursorエディタ設定

3. **自動化スクリプト**
   - `run_once_5-install-packages.sh.tmpl`: 初期パッケージインストール（Homebrew、mise、zsh）
   - `run_after_10-brew-upgrade.sh.tmpl`: macOSでの自動brew upgrade

4. **Claude Code連携**
   - `dot_claude/settings.json`: Claude Codeのフック設定
   - `dot_claude/executable_claude-completion-notify.sh`: タスク完了時の通知スクリプト

### テンプレート変数
テンプレートはchezmoiの組み込み変数を使用：
- `{{ .chezmoi.os }}`: OS（darwin、linuxなど）
- `{{ .chezmoi.osRelease }}`: OSリリース情報

## 開発ワークフロー

1. chezmoiソースディレクトリ（`~/.local/share/chezmoi/`）でファイルを変更
2. `chezmoi diff` で変更をプレビュー
3. `chezmoi apply -v` で変更を適用
4. gitにコミットしてプッシュ

## ドキュメント更新ルール

キーバインドを変更した場合、対応するREADMEも更新すること：

| 設定ファイル | README |
|-------------|--------|
| `dot_config/nvim/lua/plugins/*.lua` | `dot_config/nvim/README.md` |
| `dot_config/wezterm/*.lua` | `dot_config/wezterm/README.md` |
| `dot_ideavimrc` | `README.md`（IdeaVimセクション） |

## Claude Codeフック

このリポジトリには、Claude Codeがタスクを完了した際に通知を送るカスタムフックが含まれています。フックは `dot_claude/settings.json` で設定され、停止イベント時に `~/.claude/claude-completion-notify.sh` を実行します。