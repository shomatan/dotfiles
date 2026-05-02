# dotfiles

![macOS](https://github.com/shomatan/dotfiles/workflows/macOS/badge.svg?branch=main)
![Windows(WSL)](https://github.com/shomatan/dotfiles/workflows/Windows/badge.svg?branch=main)

## Usage

### Install

    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply shomatan

### Update

    chezmoi update

### ghq（リポジトリ管理）

```bash
brew install ghq
```

リポジトリは `~/dev` に配置される。

### fzf（ファジーファインダー）

```bash
brew install fzf
```

### bat（catの代替）

```bash
brew install bat
```

### テンプレートファイルの更新

Claude Code プラグイン設定などテンプレート管理しているファイルを更新する場合：

```bash
git add-tmpl ~/.claude/plugins/known_marketplaces.json
git commit -m "update plugins"
```

- `git add-tmpl` は `chezmoi add --template` + sed置換 + `git add` のエイリアス
- 絶対パスは自動で `{{ .chezmoi.homeDir }}` に置換される（冪等）

新マシンでは `chezmoi apply` 時に git alias と hooks が自動設定される。

## キーバインド全体マップ

[Karabiner / Aerospace / WezTerm / Neovim / IdeaVim を一望できるHTML図解](https://raw.githack.com/shomatan/dotfiles/main/diagrams/keybindings.html)（[ソース](diagrams/keybindings.html)）

## ツール別ドキュメント

| ツール | 説明 | ドキュメント |
|--------|------|--------------|
| WezTerm | ターミナル（tmux風キーバインド） | [README](dot_config/wezterm/README.md) |
| Neovim | LazyVimベースのエディタ | [README](dot_config/nvim/README.md) |
| IdeaVim | JetBrains IDE用Vimエミュレータ | [全体マップ](https://raw.githack.com/shomatan/dotfiles/main/diagrams/keybindings.html#ideavim) |
