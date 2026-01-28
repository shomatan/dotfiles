Claude Code関連の設定ファイルをchezmoiのテンプレートとして追加してください。

手順:
1. `chezmoi status` で `.claude/` 配下の変更を確認
2. 変更があれば `git add-tmpl` で以下のファイルを追加:
   - `~/.claude/plugins/installed_plugins.json`
   - `~/.claude/plugins/known_marketplaces.json`
   - `~/.claude/settings.json`
3. `git status --short` でステージング状態を表示
