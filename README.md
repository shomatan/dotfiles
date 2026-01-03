# dotfiles

![macOS](https://github.com/shomatan/dotfiles/workflows/macOS/badge.svg?branch=main)
![Windows(WSL)](https://github.com/shomatan/dotfiles/workflows/Windows/badge.svg?branch=main)

## Usage

### Install

    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply shomatan

### Update

    cd ~/.local/share/chezmoi && git pull && chezmoi apply -v

## WezTerm

リーダーキー: `Ctrl+a`

| カテゴリ | キー | 機能 |
|----------|------|------|
| ペイン | `Leader` → `-` | 縦分割 |
| ペイン | `Leader` → `\` | 横分割 |
| ペイン | `Leader` → `h/j/k/l` | ペイン移動 |
| ペイン | `Leader` → `H/J/K/L` | ペインサイズ調整 |
| ペイン | `Leader` → `z` | ペインズーム |
| ペイン | `Leader` → `x` | ペインを閉じる |
| ペイン | `Leader` → `q` | ペイン選択モード |
| ペイン | `Leader` → `Space` | ペイン回転 |
| タブ | `Leader` → `c` | 新しいタブ |
| タブ | `Leader` → `n/p` | 次/前のタブ |
| タブ | `Leader` → `0-9` | タブ番号で移動 |
| タブ | `Leader` → `&` | タブを閉じる |
| その他 | `Leader` → `[` | コピーモード (Vim風) |
| その他 | `Leader` → `]` | ペースト |
| その他 | `Leader` → `r` | 設定再読み込み |
| その他 | `Leader` → `:` | コマンドパレット |
| Git | `Ctrl+Shift+g` → `w` | Worktree選択 → 新タブで開く |
| Git | `Ctrl+Shift+g` → `a` | Worktree作成 |
| Git | `Ctrl+Shift+g` → `d` | Worktree削除 |
| ショートカット | `Ctrl+Shift+-` | 縦分割 |
| ショートカット | `Ctrl+Shift+\|` | 横分割 |
| ショートカット | `Ctrl+Shift+h/j/k/l` | ペイン移動 |
| ショートカット | `Ctrl+Shift+z` | ペインズーム |
| ショートカット | `Ctrl+Shift+n/p` | 次/前のタブ |

## Neovim

| カテゴリ | キー | 機能 |
|----------|------|------|
| ターミナル | `Ctrl+/` | ターミナル（トグル） |
| ターミナル | `Space f t` | フローティングターミナル |
| ターミナル | `Ctrl+j Ctrl+j` | ターミナルモードから抜ける (分割キーボード向け) |
| ターミナル | `Ctrl+j q` | AIビューを閉じる |
| Oil | `-` | 親ディレクトリを開く |
| Oil | `Space e` | ファイラーを開く |
| Oil | `q` | 閉じる |

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