# dotfiles

![macOS](https://github.com/shomatan/dotfiles/workflows/macOS/badge.svg?branch=main)
![Windows(WSL)](https://github.com/shomatan/dotfiles/workflows/Windows/badge.svg?branch=main)

## Usage

### Install

    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply shomatan

### Update

    cd ~/.local/share/chezmoi && git pull && chezmoi apply -v

## WezTerm キーマップ

リーダーキー: `Ctrl+a`

### ペイン操作

| キー | 機能 |
|------|------|
| `Leader` → `-` | 縦分割 |
| `Leader` → `\` | 横分割 |
| `Leader` → `h/j/k/l` | ペイン移動 |
| `Leader` → `H/J/K/L` | ペインサイズ調整 |
| `Leader` → `z` | ペインズーム |
| `Leader` → `x` | ペインを閉じる |
| `Leader` → `q` | ペイン選択モード |
| `Leader` → `Space` | ペイン回転 |

### タブ操作

| キー | 機能 |
|------|------|
| `Leader` → `c` | 新しいタブ |
| `Leader` → `n/p` | 次/前のタブ |
| `Leader` → `0-9` | タブ番号で移動 |
| `Leader` → `&` | タブを閉じる |

### コピー・その他

| キー | 機能 |
|------|------|
| `Leader` → `[` | コピーモード (Vim風) |
| `Leader` → `]` | ペースト |
| `Leader` → `r` | 設定再読み込み |
| `Leader` → `:` | コマンドパレット |

### Git Worktree

| キー | 機能 |
|------|------|
| `Ctrl+Shift+g` → `w` | Worktree選択 → 新タブで開く |
| `Ctrl+Shift+g` → `a` | ブランチ選択/新規作成 → Worktree作成 |
| `Ctrl+Shift+g` → `d` | Worktree削除 |

### Ctrl+Shift ショートカット

| キー | 機能 |
|------|------|
| `Ctrl+Shift+-` | 縦分割 |
| `Ctrl+Shift+\|` | 横分割 |
| `Ctrl+Shift+h/j/k/l` | ペイン移動 |
| `Ctrl+Shift+z` | ペインズーム |
| `Ctrl+Shift+n/p` | 次/前のタブ |

### Mac標準 (Cmd)

| キー | 機能 |
|------|------|
| `Cmd+c/v` | コピー/ペースト |
| `Cmd+t` | 新しいタブ |
| `Cmd+w` | 閉じる |
| `Cmd+n` | 新しいウィンドウ |
| `Cmd+1-9` | タブ切り替え |
| `Cmd+=/-/0` | フォントサイズ変更 |
| `Cmd+Enter` | フルスクリーン |

## Neovim キーマップ

| キー | 機能 |
|------|------|
| `Ctrl+j Ctrl+j` | ターミナルモードから抜ける |
| `Ctrl+j q` | ターミナルを閉じる |

## IdeaVim キーマップ

### 基本操作

| キー | 機能 |
|------|------|
| `jj` | ESC (インサートモード) |
| `1` | 行頭へ (`0`) |
| `2` | 行末へ (`$`) |

### ファイル・タブ

| キー | 機能 |
|------|------|
| `Space w` | 保存 |
| `Space q` | 保存して閉じる |
| `Space ESC` | 閉じる |
| `gn` / `gp` | 次/前のタブ |

### 検索・ジャンプ

| キー | 機能 |
|------|------|
| `/` | 検索 |
| `Esc Esc` | ハイライト解除 |
| `Ctrl+o` / `Ctrl+i` | 戻る/進む |
| `Space p` | ファイル検索 |
| `Space c` | コマンド検索 |
| `Space f` | 全体検索 |
| `Space o` | ファイル構造 |
| `Space b` | 最近のファイル |
| `Space t` | ターミナル |

### コード操作

| キー | 機能 |
|------|------|
| `gd` | 定義へジャンプ |
| `gr` | 参照検索 |
| `gy` | 型定義へジャンプ |
| `gi` | 実装へジャンプ |
| `go` | GitHubで開く |
| `K` | ドキュメント表示 |
| `Space rn` | リネーム |
| `dp` / `dn` | 前/次のエラーへ |
| `Space d` | 問題パネル |
| `sf` | プロジェクトツリー |