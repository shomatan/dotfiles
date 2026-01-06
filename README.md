# dotfiles

![macOS](https://github.com/shomatan/dotfiles/workflows/macOS/badge.svg?branch=main)
![Windows(WSL)](https://github.com/shomatan/dotfiles/workflows/Windows/badge.svg?branch=main)

## Usage

### Install

    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply shomatan

### Update

    chezmoi update

## ツール別ドキュメント

| ツール | 説明 | ドキュメント |
|--------|------|--------------|
| WezTerm | ターミナル（tmux風キーバインド） | [README](dot_config/wezterm/README.md) |
| Neovim | LazyVimベースのエディタ | [README](dot_config/nvim/README.md) |
| IdeaVim | JetBrains IDE用Vimエミュレータ | 下記参照 |

## IdeaVim

| カテゴリ | キー | 機能 |
|----------|------|------|
| 基本 | `jj` | ESC (インサートモード) |
| 基本 | `1` / `2` | 行頭 / 行末 |
| ファイル | `Space w` | 保存 |
| ファイル | `Space q` | 保存して閉じる |
| ファイル | `Space ESC` | 閉じる |
| タブ | `gn` / `gp` | 次/前のタブ |
| 検索 | `/` | 検索 |
| 検索 | `Esc Esc` | ハイライト解除 |
| 検索 | `Space p` | ファイル検索 |
| 検索 | `Space c` | コマンド検索 |
| 検索 | `Space f` | 全体検索 |
| ナビ | `Ctrl+o` / `Ctrl+i` | 戻る/進む |
| ナビ | `Space o` | ファイル構造 |
| ナビ | `Space b` | 最近のファイル |
| ナビ | `Space t` | ターミナル |
| ナビ | `Space d` | 問題パネル |
| ナビ | `sf` | プロジェクトツリー |
| コード | `gd` | 定義へジャンプ |
| コード | `gr` | 参照検索 |
| コード | `gy` | 型定義へジャンプ |
| コード | `gi` | 実装へジャンプ |
| コード | `go` | GitHubで開く |
| コード | `K` | ドキュメント表示 |
| コード | `Space rn` | リネーム |
| コード | `dp` / `dn` | 前/次のエラーへ |
